// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "./ClientFactory.sol";
import "./KYCVerification.sol";
import "./UpgradeablePattern.sol";

/**
 * @title Protocol
 * @dev Main factory contract for managing system rules, creating client factories, and enforcing security controls
 */
contract Protocol is UpgradeablePattern {
    address public owner;
    mapping(address => address) public clientFactories;
    mapping(address => bool) public approvedCreditTools;

    KYCVerification public kycVerifier;

    event ClientFactoryCreated(address indexed client, address factoryAddress);
    event CreditToolApproved(address toolAddress);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor(address _kycVerifier) {
        owner = msg.sender;
        kycVerifier = KYCVerification(_kycVerifier);
    }

    /**
     * @notice Creates a new client factory for a user after KYC verification
     * @param _client The address of the client
     */
    function mintClientID(address _client) external onlyOwner {
        require(kycVerifier.verifyKYC(_client), "KYC verification failed");
        ClientFactory factory = new ClientFactory(_client, address(this));
        clientFactories[_client] = address(factory);
        emit ClientFactoryCreated(_client, address(factory));
    }

    /**
     * @notice Adds an approved credit tool to the protocol, allowing clients to use it
     * @param toolAddress The address of the credit tool contract
     */
    function addCreditTool(address toolAddress) external onlyOwner {
        approvedCreditTools[toolAddress] = true;
        emit CreditToolApproved(toolAddress);
    }

    /**
     * @notice Sets permissions for a specific user on a client factory
     * @param factory The factory address
     * @param user The user address
     * @param isApproved Approval status for user permissions
     */
    function setPermissions(address factory, address user, bool isApproved) external onlyOwner {
        ClientFactory(factory).setUserPermissions(user, isApproved);
    }
}
