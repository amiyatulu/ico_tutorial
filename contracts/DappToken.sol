pragma solidity >=0.4.22 <0.7.0;

contract DappToken {
    // Initialize the smart contract with number of tokens available. 
    // To do this:
    // Constructor
    // Set the total number of tokens
    // Read the total number of tokens

    uint256 public totalSupply;

    constructor () public {
        totalSupply = 1000000;
    }


}