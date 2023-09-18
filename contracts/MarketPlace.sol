// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import ERC20 interface if you're using a stablecoin.
// import "./ERC20.sol";

contract AgriculturalContract {
    // Variables
    address public owner;
    string public produceName;
    uint256 public expectedYield;
    uint256 public plantingSeason;
    uint256 public pricePerUnit; // Price per unit of produce in stablecoin
    uint256 public totalInvestment; // Total investment made by consumers
    uint256 public totalDelivered; // Total produce delivered by farmers
    bool public contractActive = true;

    // Mapping to track consumer investments
    mapping(address => uint256) public consumerInvestments;

    // Events
    event ProduceListed(address indexed farmer, string produceName, uint256 expectedYield, uint256 plantingSeason, uint256 pricePerUnit);
    event InvestmentMade(address indexed consumer, uint256 amount);
    event ProduceDelivered(address indexed farmer, uint256 quantity);

    // Modifier to ensure only the contract owner can perform certain actions
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    // Constructor to initialize contract parameters
    constructor(
        string memory _produceName,
        uint256 _expectedYield,
        uint256 _plantingSeason,
        uint256 _pricePerUnit
    ) {
        owner = msg.sender;
        produceName = _produceName;
        expectedYield = _expectedYield;
        plantingSeason = _plantingSeason;
        pricePerUnit = _pricePerUnit;
    }

    // Function for consumers to invest in the agricultural project
    function invest() external payable {
        require(contractActive, "Contract is not active");
        require(block.timestamp < plantingSeason, "Planting season has passed");
        require(msg.value > 0, "Investment amount must be greater than 0");

        consumerInvestments[msg.sender] += msg.value;
        totalInvestment += msg.value;

        emit InvestmentMade(msg.sender, msg.value);
    }

    // Function for farmers to deliver produce
    function deliverProduce(uint256 quantity) external onlyOwner {
        require(contractActive, "Contract is not active");
        require(block.timestamp >= plantingSeason, "Planting season has not started yet");
        require(quantity <= expectedYield - totalDelivered, "Quantity exceeds expected yield");

        totalDelivered += quantity;

        // You can transfer stablecoins to the farmer here if needed.

        emit ProduceDelivered(msg.sender, quantity);

        // If the expected yield has been reached, deactivate the contract
        if (totalDelivered == expectedYield) {
            contractActive = false;
        }
    }

    // Function to retrieve the contract's balance
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // Function to withdraw funds from the contract (only available to the owner)
    function withdrawFunds() external onlyOwner {
        require(!contractActive, "Contract is still active");
        uint256 contractBalance = address(this).balance;
        payable(owner).transfer(contractBalance);
    }
}
