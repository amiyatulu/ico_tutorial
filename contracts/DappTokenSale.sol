pragma solidity >=0.4.22 <0.7.0;

import "./DappToken.sol";

contract DappTokenSale {

    address admin;
    DappToken public tokenContract;
    uint256 public tokenPrice;

    constructor(DappToken _tokenContract, uint256 _tokenPrice) public {

        // 1. Assign an Admin
        admin = msg.sender;

        // 2. Token Contract
        tokenContract = _tokenContract;

        //3. Token Price
        tokenPrice = _tokenPrice;

    }
}