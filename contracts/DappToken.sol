pragma solidity >=0.4.22 <0.7.0;

contract DappToken {
    string public name = "DApp Token";
    string public symbol = "DAPP";
    string public standard = "DApp Token v1.0";

    uint256 public totalSupply;

    //4. Its there in documentation, please see it.
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value

    );

    mapping(address => uint256) public balanceOf;

    constructor (uint256 _initialSupply) public {
        balanceOf[msg.sender] = _initialSupply;
        totalSupply = _initialSupply;
    }

    // 1. Transfer, please also look at the documentation
    function transfer(address _to, uint256 _value) public returns (bool success) {
    // 2. Exception if account doesn't have enough
    require(balanceOf[msg.sender] >= _value, "Don't have enough money");
    //3. Transfer the balance
    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;
    //5. Transfer Event
    emit Transfer(msg.sender, _to, _value);
    //6. Return a boolean
    return true;
    }
}