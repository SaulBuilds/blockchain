// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "forge-std/Test.sol";
import "../src/LoanContract.sol";

contract LoanContractTest is Test {
    LoanContract loan;
    address borrower = address(0x123);
    address lender = address(0x456);
    address protocolAgent = address(this);

    function setUp() public {
        loan = new LoanContract(borrower, lender, 100 ether);
    }

    function testLoanActivationWithSignatures() public {
        // Simulate borrower, lender, and protocol agent signing the loan
        vm.prank(borrower);
        loan.signLoan(borrower);

        vm.prank(lender);
        loan.signLoan(lender);

        vm.prank(protocolAgent);
        loan.signLoan(protocolAgent);

        assertEq(uint(loan.state()), uint(LoanContract.LoanState.Active), "Loan not activated");
    }

    function testRepayment() public {
        // Activate the loan
        vm.prank(borrower);
        loan.signLoan(borrower);

        vm.prank(lender);
        loan.signLoan(lender);

        vm.prank(protocolAgent);
        loan.signLoan(protocolAgent);

        // Repay the loan partially and fully
        vm.prank(borrower);
        loan.repayLoan(50 ether);
        assertEq(loan.loanAmount(), 50 ether, "Partial repayment failed");

        vm.prank(borrower);
        loan.repayLoan(50 ether);
        assertEq(uint(loan.state()), uint(LoanContract.LoanState.Completed), "Loan should be completed after full repayment");
    }

    function testTerminateLoan() public {
        // Activate the loan
        vm.prank(borrower);
        loan.signLoan(borrower);

        vm.prank(lender);
        loan.signLoan(lender);

        vm.prank(protocolAgent);
        loan.signLoan(protocolAgent);

        // Terminate the loan by protocol agent
        vm.prank(protocolAgent);
        loan.terminateLoan();
        assertEq(uint(loan.state()), uint(LoanContract.LoanState.Terminated), "Loan was not terminated");
    }
}
