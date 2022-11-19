pragma solidity 0.8.1;

contract SimpleStorageMemory {
    // Register the storage_variable at slot 0
    uint256 public storage_variable;

    function setValue(uint256 _a, uint256 _b) public {
        storage_variable = _a + _b;
    }

    function setValueByAssembly(uint256 _a, uint256 _b) public {
        assembly {
            // stores the resultant value of a + b into the storage_variable
            sstore(0, add(_a, _b))
        }
    }

    function getValue() public view returns (uint256) {
        // In-built solidity return statement
        return storage_variable;
    }

    function getValueByAssembly() public view returns (uint256) {
        assembly {
            // load the value of storage_variable into result
            let result := sload(0)
            // store the result value into the memory slot at 0 which is a scratch space
            mstore(0x00, result)
            // return the result which is taken from the offset 0x00 (0) to 0x00 (32)
            return(0x00, 0x20)
        }
    }
}
