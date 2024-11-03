// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "forge-std/Test.sol";
import "../src/ClientFactory.sol";
import "../src/LoanVault.sol";

contract ClientFactoryTest is Test {
    ClientFactory factory;
    address client = address(0x123);
    address protocol = address(this);

    function setUp() public {
        factory = new ClientFactory(client, protocol);
    }

    function testCreateVault() public {
        factory.createVault();
        assertTrue(address(factory.vault()) != address(0), "Vault was not created");
    }

    function testSetUserPermissions() public {
        factory.setUserPermissions(address(0x1), true);
        assertTrue(factory.userPermissions(address(0x1)), "User permission not set correctly");
    }

    function testInitiateLoanWithVault() public {
        // Ensure vault has sufficient balance before initiating a loan
        factory.createVault();
        factory.setUserPermissions(address(this), true);

        // Deposit enough balance for collateral
        LoanVault vault = factory.vault();
        vm.prank(address(this)); // Simulate client depositing funds
        vault.deposit(100 ether);

        // Initiate loan with sufficient collateral
        factory.initiateLoan(100 ether);
        assertEq(vault.lockedCollateral(), 100 ether, "Collateral was not locked correctly");
    }

    function testUnauthorizedUserCannotInitiateLoan() public {
        vm.expectRevert("User not authorized");
        factory.initiateLoan(100 ether);
    }
}
