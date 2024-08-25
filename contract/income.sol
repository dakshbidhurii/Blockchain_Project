
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IncomeShareAgreement {
    address public student;
    address public funder;
    uint256 public incomeSharePercentage; // Percentage of income to share (e.g., 10% as 10)
    uint256 public totalAmountPaid;
    uint256 public paymentDuration; // Duration in months
    uint256 public startTime;
    bool public isActive;

    event PaymentMade(address indexed student, uint256 amount);
    event ContractTerminated();

    modifier onlyStudent() {
        require(msg.sender == student, "Only the student can call this function");
        _;
    }

    modifier onlyFunder() {
        require(msg.sender == funder, "Only the funder can call this function");
        _;
    }

    modifier contractIsActive() {
        require(isActive, "The contract is not active");
        _;
    }

    constructor(uint256 _incomeSharePercentage, uint256 _paymentDuration) {
        student = 0xB437b1F67724352632d24AaE950c443969c61809;
        funder = msg.sender;
        incomeSharePercentage = _incomeSharePercentage;
        paymentDuration = _paymentDuration;
        startTime = block.timestamp;
        isActive = true;
    }

    // Function to simulate income payment
    function makePayment(uint256 monthlyIncome) public onlyStudent contractIsActive {
        uint256 payment = (monthlyIncome * incomeSharePercentage) / 100;
        totalAmountPaid += payment;
        emit PaymentMade(student, payment);
    }

    // Function to terminate the contract (by the funder)
    function terminateContract() public onlyFunder contractIsActive {
        isActive = false;
        emit ContractTerminated();
    }

    // Function to check if the payment duration has ended
    function checkDuration() public view returns (bool) {
        return (block.timestamp >= startTime + paymentDuration * 30 days);
    }

    // Function to close the contract if the payment duration has ended
    function closeContract() public onlyFunder contractIsActive {
        require(checkDuration(), "Payment duration has not ended");
        isActive = false;
        emit ContractTerminated();
    }
}
