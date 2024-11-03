// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "./LoanVault.sol";

/**
 * @title ClientFactory
 * @dev Individual user factory created post-KYC for managing vaults, loans, and credit tools
 */
contract ClientFactory {
    address public owner;
    address public protocol;
    address public client;
    LoanVault public vault;
    mapping(address => bool) public userPermissions;

    modifier onlyProtocol() {
        require(msg.sender == protocol, "Only Protocol can perform this action");
        _;
    }

    modifier onlyAuthorized() {
        require(userPermissions[msg.sender] == true, "User not authorized");
        _;
    }

    constructor(address _client, address _protocol) {
        client = _client;
        protocol = _protocol;
        owner = msg.sender;
        createVault();
    }

    /**
     * @notice Creates a vault for the client, enabling deposits and withdrawals
     */
    function createVault() public onlyProtocol {
        vault = new LoanVault();
    }

    /**
     * @notice Sets permission for a specific user
     * @param user The user address
     * @param isApproved Approval status for user permissions
     */
    function setUserPermissions(address user, bool isApproved) external onlyProtocol {
        userPermissions[user] = isApproved;
    }

    /**
     * @notice Initiates a loan for the client with a specified amount
     * @param amount The amount requested for the loan
     */
    function initiateLoan(uint256 amount) external onlyAuthorized {
        require(address(vault) != address(0), "Vault not created");
        vault.lockCollateral(amount);
    }
}
