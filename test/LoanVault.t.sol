// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "forge-std/Test.sol";
import "../src/LoanVault.sol";

contract LoanVaultTest is Test {
    LoanVault vault;

    function setUp() public {
        vault = new LoanVault();
    }

    function testDepositAndBalance() public {
        vault.deposit(100);
        assertEq(vault.balances(address(this)), 100, "Balance not updated after deposit");
    }

    function testWithdrawFunds() public {
        vault.deposit(100);
        vault.withdraw(50);
        assertEq(vault.balances(address(this)), 50, "Balance not updated after withdrawal");
    }

    function testLockAndReleaseCollateral() public {
        vault.deposit(200);
        vault.lockCollateral(100);
        assertEq(vault.lockedCollateral(), 100, "Collateral not locked");

        vault.releaseCollateral(50);
        assertEq(vault.lockedCollateral(), 50, "Collateral not released correctly");
    }

    function testInsufficientBalanceWithdraw() public {
        vault.deposit(50);
        vm.expectRevert("Insufficient balance");
        vault.withdraw(100);
    }
}
