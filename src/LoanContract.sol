// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

/**
 * @title LoanContract
 * @dev Manages loans with a three-signature process, requiring borrower, lender, and protocol agent authorization
 */
contract LoanContract {
    address public borrower;
    address public lender;
    address public protocolAgent;
    uint256 public loanAmount;
    bool public borrowerSigned;
    bool public lenderSigned;
    bool public agentSigned;

    enum LoanState { Pending, Active, Completed, Terminated }
    LoanState public state;

    constructor(address _borrower, address _lender, uint256 _loanAmount) {
        borrower = _borrower;
        lender = _lender;
        loanAmount = _loanAmount;
        state = LoanState.Pending;
    }

    /**
     * @notice Collects required signatures to activate the loan
     * @param signer Address of the signing party
     */
    function signLoan(address signer) external {
        require(signer == borrower || signer == lender || signer == protocolAgent, "Invalid signer");
        if (signer == borrower) borrowerSigned = true;
        if (signer == lender) lenderSigned = true;
        if (signer == protocolAgent) agentSigned = true;

        if (allSignaturesCollected()) {
            state = LoanState.Active;
        }
    }

    /**
     * @notice Allows repayment of the loan amount
     * @param amount The amount to be repaid
     */
    function repayLoan(uint256 amount) external {
        require(state == LoanState.Active, "Loan not active");
        require(amount <= loanAmount, "Repayment exceeds loan amount");
        loanAmount -= amount;
        if (loanAmount == 0) {
            state = LoanState.Completed;
        }
    }

    /**
     * @notice Terminates the loan if a breach of terms occurs
     */
    function terminateLoan() external {
        require(msg.sender == lender || msg.sender == protocolAgent, "Unauthorized");
        require(state == LoanState.Active, "Loan not active");
        state = LoanState.Terminated;
    }

    /**
     * @notice Checks if all required signatures are collected
     * @return Boolean indicating if all signatures are collected
     */
    function allSignaturesCollected() private view returns (bool) {
        return borrowerSigned && lenderSigned && agentSigned;
    }
}
