// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "forge-std/Test.sol";
import "../src/CreditReporting.sol";

contract CreditReportingTest is Test {
    CreditReporting reporting;
    address client = address(0x456);

    function setUp() public {
        reporting = new CreditReporting();
    }

    function testEmitMonthlyReport() public {
        reporting.emitMonthlyReport(client);
    }

    function testOnlyOwnerCanEmitReport() public {
        vm.prank(address(0x123));
        vm.expectRevert("Only owner can perform this action");
        reporting.emitMonthlyReport(client);
    }
}
