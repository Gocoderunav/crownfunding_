pragma solidity ^0.8.0;

contract Crowdfunding {
    address public owner;
    uint public goal;
    uint public deadline;
    uint public totalRaised;

    mapping(address => uint) public contributions;

    constructor(uint _goal, uint _durationInDays) {
        owner = msg.sender;
        goal = _goal;
        deadline = block.timestamp + (_durationInDays * 1 days);
    }
// Allows users to contribute Ether to the campaign before the deadline
    function contribute() external payable {
        require(block.timestamp < deadline, "Campaign ended");
        require(msg.value > 0, "Contribution must be greater than zero");

        contributions[msg.sender] += msg.value;
        totalRaised += msg.value;
    }
// change with draw
    function withdrawFunds() external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(block.timestamp >= deadline, "Campaign still ongoing");
        require(totalRaised >= goal, "Funding goal not reached");
       // Transfer all raised funds to the campaign owner if goal is met and deadline is passed
        payable(owner).transfer(address(this).balance);
    }
// refund handle function
    function refund() external {
        require(block.timestamp >= deadline, "Campaign still ongoing");
        require(totalRaised < goal, "Goal met, no refunds");

        uint amount = contributions[msg.sender];
        require(amount > 0, "No contributions to refund");

        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
}