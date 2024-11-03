// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

/**
 * @title LoanVault
 * @dev Manages client vaults, handling deposits, withdrawals, and locking collateral for loans
 */
contract LoanVault {
    address public owner;
    uint256 public lockedCollateral;
    mapping(address => uint256) public balances;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /**
     * @notice Deposits specified amount into the vault
     * @param amount The amount to be deposited
     */
    function deposit(uint256 amount) external onlyOwner {
        require(amount > 0, "Amount must be greater than zero");
        balances[owner] += amount;
    }

    /**
     * @notice Withdraws a specified amount from the vault
     * @param amount The amount to be withdrawn
     */
    function withdraw(uint256 amount) external onlyOwner {
        require(balances[owner] >= amount + lockedCollateral, "Insufficient balance");
        balances[owner] -= amount;
    }

    /**
     * @notice Locks specified collateral for loan use
     * @param amount The amount of collateral to lock
     */
    function lockCollateral(uint256 amount) external onlyOwner {
        require(balances[owner] >= amount, "Insufficient balance to lock");
        lockedCollateral += amount;
    }

    /**
     * @notice Releases locked collateral after loan repayment
     * @param amount The amount of collateral to release
     */
    function releaseCollateral(uint256 amount) external onlyOwner {
        require(lockedCollateral >= amount, "Amount exceeds locked collateral");
        lockedCollateral -= amount;
    }
}
