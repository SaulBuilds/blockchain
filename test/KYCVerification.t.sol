// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "forge-std/Test.sol";
import "../src/KYCVerification.sol";

contract KYCVerificationTest is Test {
    KYCVerification kyc;

    function setUp() public {
        kyc = new KYCVerification();
    }

    function testVerifyKYC() public {
        bool verified = kyc.verifyKYC(address(this));
        assertTrue(verified, "KYC verification failed");
    }

    function testKYCStatusOnChain() public {
        kyc.verifyKYC(address(this));
        assertTrue(kyc.kycApproved(address(this)), "KYC status not set correctly");
    }
}
