pragma solidity ^0.4.23;

contract DummyMaster {
    // resolver needs to be the first in storage to match the Proxy contract storage ordering
    address impl;
    uint count;

    function increment() public {
        count = count + 1;
    }
    function get() external view returns (uint) {
        return count;
    }
}

contract Dummy {
    address impl;

    constructor (address _impl) public {
      impl = _impl;
    }

    function () public {
     require(msg.sig != 0x0);
     address _impl = impl;
     assembly {
        let ptr := mload(0x40)
        calldatacopy(ptr, 0, calldatasize)
        let result := delegatecall(gas, _impl, ptr, calldatasize, ptr, 0)
        let size := returndatasize
        returndatacopy(ptr, 0, size)
        switch result
        case 0 { revert(ptr, size) }
        default { return(ptr, size) }
    }
  }
}

//This is simply used to easier create contract calls with web3js/ethersjs
contract DummyInterface {
    function increment() external;
    function get() external view returns (uint);
}
