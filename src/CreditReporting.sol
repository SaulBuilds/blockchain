// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

/**
 * @title CreditReporting
 * @dev Manages and emits monthly credit reports for each client
 */
contract CreditReporting {
    address public owner;

    event MonthlyCreditReport(address indexed client, string reportData);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /**
     * @notice Generates and emits a monthly credit report for a client
     * @param client The client address for reporting
     */
    function emitMonthlyReport(address client) external onlyOwner {
        string memory reportData = generateReport();
        emit MonthlyCreditReport(client, reportData);
    }

    /**
     * @notice Generates a standard credit report
     * @return A string representing the credit report data
     */
    function generateReport() private pure returns (string memory) {
        return "Positive credit report";
    }
}
