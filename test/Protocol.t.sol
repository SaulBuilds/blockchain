// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "forge-std/Test.sol";
import "../src/Protocol.sol";
import "../src/KYCVerification.sol";

contract ProtocolTest is Test {
    Protocol protocol;
    KYCVerification kyc;
    address client = address(0xABC);

    function setUp() public {
        kyc = new KYCVerification();
        protocol = new Protocol(address(kyc));
    }

    function testMintClientIDWithKYC() public {
        kyc.verifyKYC(client);
        protocol.mintClientID(client);
        assertTrue(protocol.clientFactories(client) != address(0), "Client factory not created");
    }

    function testAddCreditTool() public {
        protocol.addCreditTool(address(0x111));
        assertTrue(protocol.approvedCreditTools(address(0x111)), "Credit tool not approved");
    }

    function testSetPermissions() public {
        protocol.mintClientID(client);
        protocol.setPermissions(protocol.clientFactories(client), address(0x222), true);
        bool permission = ClientFactory(protocol.clientFactories(client)).userPermissions(address(0x222));
        assertTrue(permission, "Permission was not set correctly");
    }
}
