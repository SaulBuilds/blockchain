// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "forge-std/Script.sol";
import "../src/Protocol.sol";
import "../src/KYCVerification.sol";
import "../src/Privacy.sol";
import "../src/LoanVault.sol";
import "../src/ClientFactory.sol";
import "../src/CreditReporting.sol";
import "../src/LoanContract.sol";

contract DeployScript is Script {
    Protocol protocol;
    KYCVerification kycVerifier;
    Privacy privacy;
    CreditReporting creditReporting;

    function run() external {
        // Begin recording the deployment transactions
        vm.startBroadcast();

        // 1. Deploy the KYC Verification Contract
        kycVerifier = new KYCVerification();
        console.log("KYC Verification contract deployed at:", address(kycVerifier));

        // 2. Deploy the Protocol Contract, linking it to the KYC Verification contract
        protocol = new Protocol(address(kycVerifier));
        console.log("Protocol contract deployed at:", address(protocol));

        // 3. Deploy the Privacy Contract
        privacy = new Privacy();
        console.log("Privacy contract deployed at:", address(privacy));

        // 4. Deploy the Credit Reporting Contract
        creditReporting = new CreditReporting();
        console.log("Credit Reporting contract deployed at:", address(creditReporting));

        // 5. Mint a Client ID to create a ClientFactory for a test client
        address testClient = address(0x123); // Replace with actual client address in production
        vm.startPrank(protocol.owner());
        bool kycStatus = kycVerifier.verifyKYC(testClient);
        require(kycStatus, "KYC Verification failed for test client");
        
        protocol.mintClientID(testClient);
        address clientFactoryAddress = protocol.clientFactories(testClient);
        require(clientFactoryAddress != address(0), "ClientFactory not created");
        console.log("ClientFactory for test client deployed at:", clientFactoryAddress);

        // 6. Deploy a Loan Vault for the ClientFactory
        ClientFactory clientFactory = ClientFactory(clientFactoryAddress);
        clientFactory.createVault();
        LoanVault vault = clientFactory.vault();
        require(address(vault) != address(0), "LoanVault not created");
        console.log("LoanVault for test client created at:", address(vault));

        // 7. Deploy a Loan Contract for testing
        address lender = address(0x456);
        LoanContract loanContract = new LoanContract(testClient, lender, 100 ether);
        console.log("LoanContract deployed at:", address(loanContract));

        // End recording deployment transactions
        vm.stopBroadcast();

        console.log("Deployment script completed successfully.");
    }
}
