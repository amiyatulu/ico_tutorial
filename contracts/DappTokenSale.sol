pragma solidity >=0.4.22 <0.7.0;

import "./DappToken.sol";

// 9. Import SafeMath
import "./SafeMath.sol";

contract DappTokenSale {

    // 10. using the SafeMath Library
    using SafeMath for uint256;

    address admin;
    DappToken public tokenContract;
    uint256 public tokenPrice;

    // 4. Token Sold
    uint256 public tokensSold;

    // 6. Sell Event
    event Sell(address _buyer, uint256 _amount);

    constructor(DappToken _tokenContract, uint256 _tokenPrice) public {

        // 1. Assign an Admin
        admin = msg.sender;

        // 2. Token Contract
        tokenContract = _tokenContract;

        //3. Token Price
        tokenPrice = _tokenPrice;

    }
    function buyTokens(uint256 _numberOfTokens) public payable {

        // 8. Require that value is equal to tokens
        require(msg.value == _numberOfTokens.mul(tokenPrice), "msg.value is not equal to required value");

        // 9. Require that the contract has enough tokens
        require(tokenContract.balanceOf(address(this)) >= _numberOfTokens, "contract don't have enough tokens");
        // Require that a transfer is successful

        // 5. Keep track of tokenSold
        tokensSold += _numberOfTokens;

        // 7. Trigger Sell Event
        emit Sell(msg.sender, _numberOfTokens);

    }
}