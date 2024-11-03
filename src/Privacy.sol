// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

/**
 * @title Privacy
 * @dev Handles hashing and privacy protections for user data
 */
contract Privacy {
    mapping(bytes32 => bool) private hashes;

    /**
     * @notice Hashes user data for secure storage
     * @param data User data to hash
     * @return Hash of the data
     */
    function hashUserData(bytes memory data) public pure returns (bytes32) {
        return keccak256(data);
    }

    /**
     * @notice Stores the hash of user data on-chain
     * @param data User data to hash and store
     */
    function storeUserDataHash(bytes memory data) external {
        bytes32 hashedData = hashUserData(data);
        hashes[hashedData] = true;
    }

    /**
     * @notice Verifies a hash against stored data
     * @param proof The data hash to verify
     * @return Whether the hash is verified
     */
    function verifyProof(bytes32 proof) external view returns (bool) {
        return hashes[proof];
    }
}
