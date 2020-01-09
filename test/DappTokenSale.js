const DappTokenSale = artifacts.require("DappTokenSale");
// 1. Decalare DappToken
const DappToken = artifacts.require("DappToken");

contract("DappTokenSale", function(accounts) {
  let tokenSaleInstance;
  var tokenInstance;
  // 2. Set the admin, who has all money.
  var admin = accounts[0];
  var buyer = accounts[1];
  var tokenPrice = 1000000000000000; //wei (0.001 ether)
  // 3. Set the token available for sale
  var tokensAvailable = 750000;
  var numberOfTokens;

  it("initializes the contract with the correct values", function() {
    return DappTokenSale.deployed()
      .then(function(instance) {
        tokenSaleInstance = instance;
        return tokenSaleInstance.address;
      })
      .then(function(address) {
        assert.notEqual(address, 0x0, "has contract address");
        return tokenSaleInstance.tokenContract();
      })
      .then(function(address) {
        assert.notEqual(address, 0x0, "has contract address");
        return tokenSaleInstance.tokenPrice();
      })
      .then(function(price) {
        assert.equal(price, tokenPrice, "token price is correct");
      });
  });

  it("facilitates token buying", function() {
    return DappToken.deployed()
      .then(function(instance) {
        // 4. Grab token instance first
        tokenInstance = instance;
        return DappTokenSale.deployed();
      })
      .then(function(instance) {
        // 5. Then grap token sale instance
        tokenSaleInstance = instance;

        // 6. Provision 75% of all tokens to the token sale
        return tokenInstance.transfer(tokenSaleInstance.address, tokensAvailable, { from: admin });
      })
      .then(function(receipt) {
        numberOfTokens = 10;
        var value = numberOfTokens * tokenPrice;
        // 7. Memo: tokenPrice is 0.001 ether in wei
        // Memo: msg.value contains the amount of wei (ether / 1e18) sent in the transaction.
        return tokenSaleInstance.buyTokens(numberOfTokens, { from: buyer, value: value });
      })
      .then(function(receipt) {
        assert.equal(receipt.logs.length, 1, "triggers one event");
        assert.equal(receipt.logs[0].event, "Sell", 'should be "Sell" event');
        assert.equal(receipt.logs[0].args._buyer, buyer, "logs the account that purchased the tokens");
        assert.equal(receipt.logs[0].args._amount, numberOfTokens, "logs the number of tokens purchaged");
        return tokenSaleInstance.tokensSold();
      })
      .then(function(amount) {
        assert.equal(amount.toNumber(), numberOfTokens, "increments the number of tokens in tokenSold variable");
        return tokenInstance.balanceOf(buyer);
      })
      .then(function(balance) {
        // console.log(balance.toNumber(), "balance of buyer");
        assert.equal(balance.toNumber(), numberOfTokens, "balance of buyer is not same as number of tokens given to buyToken function");
        return tokenInstance.balanceOf(tokenSaleInstance.address);
      })
      .then(function(balance) {
        // console.log(balance.toNumber(), "balance of contract address");
        assert.equal(balance.toNumber(), tokensAvailable - numberOfTokens, "contract balance didn't decreased by numberOfTokens send to buyToken function");
        //8. Try to buy tokens different with the ether value, the value i.e. wei sent in the transcation is much less than numberOfTokens * tokenPrice
        return tokenSaleInstance.buyTokens(numberOfTokens, { from: buyer, value: 1 });
      })
      .then(assert.fail)
      .catch(function(error) {
        assert(error.message.indexOf("revert") >= 0, "msg.value must be more than numberOfTokens * tokenPrice");
        //9. Ask to buy with numberOfTokens more than the smart contract has
        return tokenSaleInstance.buyTokens(800000, { from: buyer, value: 800000 * tokenPrice });
      })
      .then(assert.fail)
      .catch(function(error) {
        assert(error.reason == "contract don't have enough tokens", "cannot purchase more tokens than available");
      });
  });
});
