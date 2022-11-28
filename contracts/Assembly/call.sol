// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// Contract which can be called by EOA/Contract
contract CallableContract {
    address public caller;

    // Records the caller in storage slot
    function recordCaller() external {
        caller = msg.sender;
    }
}

// Contract which calls a callable contract
contract CallingContract {
    address public callableContractAddress;

    // initialize the callable contract 
    constructor(address _contractAddress) {
        callableContractAddress = _contractAddress;
    }

    // Call other contracts using solidity inbuilt methods
    function callBySolidity() external {
        CallableContract(callableContractAddress).recordCaller();
    }

    // Call other contracts using inline assembly
    function callByAssembly() external  {
        // function signature of callable function
        bytes32 funcSignature = keccak256("recordCaller()");

        assembly {
            // loads the callable contract address from storage slot 0
            let contractAddress := sload(0x00)

            // Loads a free memory pointer
            let freeMemory := mload(0x40)

            // stores the function signature in the first free slot (0x80)
            mstore(freeMemory, funcSignature)

            // Performs a external call to recordCaller function in callable contract
            // call(gas, target_address, value, input_pointer, input_size, output_pointer, output_size)
            let result := call(gas(), contractAddress, 0, freeMemory, 0x04, 0, 0)
            
            // revert if the external call is failed
            if eq(result, 0) {
                revert(0, 0)
            }
        }
    }
}
