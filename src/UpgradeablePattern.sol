// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

/**
 * @title UpgradeablePattern
 * @dev Provides upgrade functionality for protocol contracts
 */
contract UpgradeablePattern {
    address public implementation;

    event Upgraded(address indexed newImplementation);

    /**
     * @notice Upgrades contract implementation to a new address
     * @param newImplementation The address of the new contract implementation
     */
    function upgrade(address newImplementation) external {
        require(newImplementation != address(0), "Invalid implementation address");
        implementation = newImplementation;
        emit Upgraded(newImplementation);
    }
}
