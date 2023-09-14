// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// await web3.eth.getStorageAt(contract.address,1) to get password loaded from storage
// 0x412076657279207374726f6e67207365637265742070617373776f7264203a29

contract Vault {
  bool public locked;
  bytes32 private password;

  constructor(bytes32 _password) {
    locked = true;
    password = _password;
  }

  function unlock(bytes32 _password) public {
    if (password == _password) {
      locked = false;
    }
  }
}