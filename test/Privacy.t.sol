// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "forge-std/Test.sol";
import "../src/Privacy.sol";

contract PrivacyTest is Test {
    Privacy privacy;

    function setUp() public {
        privacy = new Privacy();
    }

    function testHashUserData() public view {
        bytes32 hash = privacy.hashUserData("TestData");
        assertTrue(hash != bytes32(0), "Hash not generated correctly");
    }

    function testStoreAndVerifyHash() public {
        bytes memory data = "UserData";
        bytes32 hash = privacy.hashUserData(data);
        privacy.storeUserDataHash(data);
        assertTrue(privacy.verifyProof(hash), "Hash verification failed");
    }
}
