// SPDX-License-Identifier: MIT
pragma solidity 0.8.1;

contract EventLog {
    // hasing the event signature with crypto algorithm
    bytes32 private sampleEventOneSignature =
        keccak256("SampleEventOne(uint256,uint256)");
    bytes32 private sampleEventTwoSignature =
        keccak256("SampleEventTwo(uint256,uint256,uint256)");

    // event declaration
    event SampleEventOne(uint256 indexed valueOne, uint256 valueTwo);
    event SampleEventTwo(
        uint256 indexed valueOne,
        uint256 indexed valueTwo,
        uint256 valueThree
    );

    // events are emitted by inbuilt soldity methods
    function emitEvent() external {
        emit SampleEventOne(1, 2);
        emit SampleEventTwo(1, 2, 3);
    }

    // events are emitted by assembly
    function emitEventByAssembly() external {
        assembly {
            // loading the event signature from storage slot 0
            let eventOneSignature := sload(0x00)
            // loading the event signature from storage slot 1
            let eventTwoSignature := sload(0x01)

            // accessing the solidity reserved free memory pointer
            let freeMemory := mload(0x40)

            // storing the non indexed value in memory
            mstore(freeMemory, 2)

            // emiting the event - log2(pointer, size, topic1, topic2);
            log2(freeMemory, 0x20, eventOneSignature, 1)

            // storing the non indexed value in memory
            mstore(freeMemory, 3)

            // emiting the event - log2(pointer, size, topic1, topic2, topic3);
            log3(freeMemory, 0x20, eventTwoSignature, 1, 2)
        }
    }
}
