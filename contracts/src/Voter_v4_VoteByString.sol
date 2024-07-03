// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Voter {

    struct OptionPos {
        uint pos;
        bool exists;
    }

    uint[] public votes;
    mapping (address => bool) hasVoted;
    string[] public options;
    mapping (string => OptionPos) posOfOption;

    constructor(string[] memory _options) {
        options = _options;
        votes = new uint[](_options.length);

        for (uint i = 0; i < options.length; i++) {
            OptionPos memory option = OptionPos(i, true);
            posOfOption[options[i]] = option;
        }
    }
    function vote(uint option) public {
        require(0 <= option && option < options.length, "Invalid option");
        require(!hasVoted[msg.sender], "Already voted");

        recordVote(option);
    }

    function recordVote(uint option) private {
        hasVoted[msg.sender] = true;
        votes[option] = votes[option] + 1;
    }

    function vote(string memory option) public {
        require(!hasVoted[msg.sender], "Already voted");
        OptionPos memory pos = posOfOption[option];
        require(pos.exists, "Invalid option");

        recordVote(pos.pos);
    }

    function getOptions() public view returns (string[] memory) {
        return options;
    }

    function getVotes() public view returns (uint[] memory) {
        return votes;
    }
}