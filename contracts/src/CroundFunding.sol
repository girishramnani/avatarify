// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Crowdfunding {

    enum State { Ongoing, Failed, Succeded, PaidOut }

    event CampaignFinished(
        address addr,
        uint totalCollected,
        bool succeeded
    );

    string public name;
    uint public targetAmount;
    uint public fundingDeadline;
    address payable public beneficiary;
    State public state;
    mapping(address => uint) public amounts;
    bool public collected;

    modifier inState(State expectedState) {
        require(state == expectedState,  "Incorrect crowdfunding state");
        _;
    }

    constructor(
        string memory campaignName,
        uint targetAmountEth,
        uint durationInMin,
        address payable beneficiaryAddress
    )
    {
        name = campaignName;
        targetAmount = targetAmountEth * 1 ether;
        fundingDeadline = currentTime() + durationInMin * 1 minutes;
        beneficiary = beneficiaryAddress;
        state = State.Ongoing;
    }

    receive() external payable inState(State.Ongoing) {
        require(beforeDeadline(), "Deadline has passed");
        amounts[msg.sender] += msg.value;

        if (totalCollected() >= targetAmount) {
            collected = true;
        }
    }

    function totalCollected() public view returns(uint) {
        return address(this).balance;
    }

    function finishCrowdfunding() public inState(State.Ongoing) {
        require(afterDeadline(), "Deadline has not passed");

        if (!collected) {
            state = State.Failed;
        } else {
            state = State.Succeded;
        }
        emit CampaignFinished(address(this), totalCollected(), collected);
    }

    function collect() inState(State.Succeded) public {
        if (beneficiary.send(totalCollected())) {
            state = State.PaidOut;
        } else {
            state = State.Failed;
        }
    }

    function withdraw() public inState(State.Failed) {
        require(amounts[msg.sender] > 0, "No funds for account");
        uint contributed = amounts[msg.sender];
        amounts[msg.sender] = 0;

        payable(msg.sender).transfer(contributed);
    }

    function beforeDeadline() public view returns(bool) {
        return currentTime() < fundingDeadline;
    }

    function afterDeadline() internal view returns(bool) {
        return !beforeDeadline();
    }

    function currentTime() private view returns(uint) {
        return block.timestamp;
    }
}