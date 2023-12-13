// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

// Look carefully at the contract's code below.

// You will beat this level if

// 1. you claim ownership of the contract
// 2. you reduce its balance to 0

contract Fallback {

  mapping(address => uint) public contributions;
  address public owner;

  constructor() {
    owner = msg.sender;
    contributions[msg.sender] = 1000 * (1 ether);
  }

  modifier onlyOwner {
        require(
            msg.sender == owner,
            "caller is not the owner"
        );
        _;
    }

  function contribute() public payable {
    require(msg.value < 0.001 ether);
    contributions[msg.sender] += msg.value;
    if(contributions[msg.sender] > contributions[owner]) {
      owner = msg.sender; // changing the owner if contribution is > than the current owner's
    }
  }

  function getContribution() public view returns (uint) {
    return contributions[msg.sender];
  }

  function withdraw() public onlyOwner {
    payable(owner).transfer(address(this).balance); // only the owner can withdraw
  }

  receive() external payable { // this is triggered when eth is sent directly to the contract
    require(msg.value > 0 && contributions[msg.sender] > 0); 
    owner = msg.sender; // changing the owner if contribution is > than 0 and sent eth amount > 0
  }
}