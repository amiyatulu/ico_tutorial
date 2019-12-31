pragma solidity >=0.4.22 <0.7.0;

contract DappToken {
    string public name = "DApp Token";
    string public symbol = "DAPP";
    string public standard = "DApp Token v1.0";

    uint256 public totalSupply;


    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value

    );

    // 2. Approval even, see the documentation
    // I the owner, approved _spender to spend _value number of dapp tokens
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    mapping(address => uint256) public balanceOf;

    // 4. allownance variable, it contains nested mapping. We have mapping within a mapping
    mapping(address => mapping(address => uint256)) public allowance;

    constructor (uint256 _initialSupply) public {
        balanceOf[msg.sender] = _initialSupply;
        totalSupply = _initialSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {

    require(balanceOf[msg.sender] >= _value, "Don't have enough money");

    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;

    emit Transfer(msg.sender, _to, _value);

    return true;
    }

    // 1. Approve function (Allows _spender to withdraw from your account multiple times)
    function approve(address _spender, uint256 _value) public returns (bool success) {

    // 5. Allowance
    allowance[msg.sender][_spender] = _value;

    // 3. Call the Approval event
        emit Approval(msg.sender, _spender, _value);

        return true;
    }
}