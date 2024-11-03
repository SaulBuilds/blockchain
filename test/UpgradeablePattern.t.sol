// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "forge-std/Test.sol";
import "../src/UpgradeablePattern.sol";

contract UpgradeablePatternTest is Test {
    UpgradeablePattern upgradeable;
    address newImplementation = address(0x123);

    function setUp() public {
        upgradeable = new UpgradeablePattern();
    }

    function testUpgradeImplementation() public {
        upgradeable.upgrade(newImplementation);
        assertEq(upgradeable.implementation(), newImplementation, "Upgrade failed");
    }

    function testUpgradeWithInvalidAddress() public {
        vm.expectRevert("Invalid implementation address");
        upgradeable.upgrade(address(0));
    }
}
