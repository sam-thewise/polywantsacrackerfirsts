// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.2/contracts/access/Ownable.sol";

contract Authorizable is Ownable {

    mapping(address => bool) public authorized;

    modifier onlyAuthorized() {
        require(authorized[msg.sender] || owner() == msg.sender);
        _;
    }

    function addAuthorized(address toAdd) onlyOwner public {
        authorized[toAdd] = true;
    }

    function removeAuthorized(address toRemove) onlyOwner public {
        require(toRemove != msg.sender);
        authorized[toRemove] = false;
    }

}