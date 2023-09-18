// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InsuranceContract {
    // Variables
    address public owner;
    uint256 public premiumAmount;
    uint256 public totalPremiums;
    uint256 public totalClaims;
    bool public contractActive = true;

    // Mapping to track insured farmers and consumers
    mapping(address => bool) public insuredFarmers;
    mapping(address => bool) public insuredConsumers;

    // Events
    event PremiumPaid(address indexed payer, uint256 amount);
    event ClaimSubmitted(address indexed claimant, uint256 amount);
    event ClaimPaid(address indexed claimant, uint256 amount);

    // Modifier to ensure only the contract owner can perform certain actions
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    // Constructor to initialize contract parameters
    constructor(uint256 _premiumAmount) {
        owner = msg.sender;
        premiumAmount = _premiumAmount;
    }

    // Function for farmers and consumers to purchase insurance
    function purchaseInsurance() external payable {
        require(contractActive, "Contract is not active");
        require(msg.value >= premiumAmount, "Insufficient premium amount");

        if (msg.sender == owner) {
            insuredFarmers[msg.sender] = true;
        } else {
            insuredConsumers[msg.sender] = true;
        }

        totalPremiums += msg.value;

        emit PremiumPaid(msg.sender, msg.value);
    }

    // Function for insured parties to submit insurance claims
    function submitClaim(uint256 amount) external {
        require(contractActive, "Contract is not active");
        require(insuredFarmers[msg.sender] || insuredConsumers[msg.sender], "Not insured");
        require(amount > 0, "Claim amount must be greater than 0");

        // You can add additional validation here, such as verifying the claim amount against specific criteria.

        // Calculate the maximum claim amount based on total premiums
        uint256 maxClaimAmount = (totalPremiums * 2) / 3; // Example: 2/3 of total premiums

        require(amount <= maxClaimAmount, "Claim amount exceeds maximum limit");

        totalClaims += amount;

        // Transfer the claim amount to the claimant
        payable(msg.sender).transfer(amount);

        emit ClaimPaid(msg.sender, amount);
    }

    // Function to deactivate the insurance contract (only available to the owner)
    function deactivateContract() external onlyOwner {
        contractActive = false;
    }

    // Function to withdraw funds from the contract (only available to the owner)
    function withdrawFunds() external onlyOwner {
        require(!contractActive, "Contract is still active");
        uint256 contractBalance = address(this).balance;
        payable(owner).transfer(contractBalance);
    }
}
