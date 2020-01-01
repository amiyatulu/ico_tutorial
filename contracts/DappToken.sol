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
    // 6. Transfer money, similar to transfer function, but its done by me (msg.sender) on behalf of _from address
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        
        // 7. Check if _from account has enough balance
        require(_value <= balanceOf[_from], "You are trying to spend more than user has");

        // 8. Check if msg.sender tranfers amount of money that is allowed
        require(_value <= allowance[_from][msg.sender], "You are trying to spend more than allowed limit");

        // 10. Deduct balance _from account, and adding it to _to account
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        // 11. Deduct the allowance
        allowance[_from][msg.sender] -= _value;


        // 9. Tranfer event
        emit Transfer(_from, _to, _value);

        return true;

    }
}