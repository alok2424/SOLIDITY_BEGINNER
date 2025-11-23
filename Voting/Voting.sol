// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Vote {
    // ----------------------------
    // STRUCT DEFINITIONS
    // ----------------------------
    struct Voter {
        string name;
        uint age;
        uint voterId;
        Gender gender;
        uint voteCandidateId; // candidate ID voted for
        address voterAddress; // EOA of the voter
    }

    struct Candidate {
        string name;
        string party;
        uint age;
        Gender gender;
        uint candidateId;
        address candidateAddress; // candidate EOA
        uint votes; // number of votes
    }

    // ----------------------------
    // STATE VARIABLES
    // ----------------------------
    address public electionCommission;
    address public winner;

    uint public nextVoterId = 1;
    uint public nextCandidateId = 1;

    uint public startTime;
    uint public endTime;
    bool public stopVoting;

    mapping(uint => Voter) public voterDetails;
    mapping(uint => Candidate) public candidateDetails;

    enum VotingStatus { NotStarted, InProgress, Ended }
    enum Gender { NotSpecified, Male, Female, Other }

    // ----------------------------
    // MODIFIERS
    // ----------------------------
    modifier isVotingActive() {
        require(block.timestamp >= startTime, "Voting has not started yet");
        require(block.timestamp <= endTime && !stopVoting, "Voting time is over");
        _;
    }

    modifier onlyCommissioner() {
        require(msg.sender == electionCommission, "Not authorized");
        _;
    }

    modifier isValidAge(uint _age) {
        require(_age >= 18, "Not eligible for voting");
        _;
    }

    // ----------------------------
    // CONSTRUCTOR
    // ----------------------------
    constructor() {
        electionCommission = msg.sender;
    }

    // ----------------------------
    // REGISTRATION FUNCTIONS
    // ----------------------------
    function registerCandidate(
        string calldata _name,
        string calldata _party,
        uint _age,
        Gender _gender
    ) external isValidAge(_age) {
        require(isCandidateNotRegistered(msg.sender), "You are already registered");
        require(nextCandidateId <= 3, "Candidate registration full");
        require(msg.sender != electionCommission, "Commission cannot register");

        candidateDetails[nextCandidateId] = Candidate({
            name: _name,
            party: _party,
            age: _age,
            gender: _gender,
            candidateId: nextCandidateId,
            candidateAddress: msg.sender,
            votes: 0
        });

        nextCandidateId++;
    }

    function registerVoter(
        string calldata _name,
        uint _age,
        Gender _gender
    ) external isValidAge(_age) {
        require(isVoterNotRegistered(msg.sender), "You are already registered");

        voterDetails[nextVoterId] = Voter({
            name: _name,
            age: _age,
            voterId: nextVoterId,
            gender: _gender,
            voteCandidateId: 0,
            voterAddress: msg.sender
        });

        nextVoterId++;
    }

    // ----------------------------
    // INTERNAL HELPERS
    // ----------------------------
    function isCandidateNotRegistered(address _person) internal view returns (bool) {
        for (uint i = 1; i < nextCandidateId; i++) {
            if (candidateDetails[i].candidateAddress == _person) {
                return false;
            }
        }
        return true;
    }

    function isVoterNotRegistered(address _person) internal view returns (bool) {
        for (uint i = 1; i < nextVoterId; i++) {
            if (voterDetails[i].voterAddress == _person) {
                return false;
            }
        }
        return true;
    }

    // ----------------------------
    // VOTING FUNCTIONS
    // ----------------------------
    function setVotingPeriod(uint _startDelay, uint _duration) external onlyCommissioner {
        startTime = block.timestamp + _startDelay;
        endTime = startTime + _duration;
    }

    function getVotingStatus() public view returns (VotingStatus) {
        if (startTime == 0) {
            return VotingStatus.NotStarted;
        } else if (block.timestamp >= startTime && block.timestamp <= endTime && !stopVoting) {
            return VotingStatus.InProgress;
        } else {
            return VotingStatus.Ended;
        }
    }

    function castVote(uint _voterId, uint _candidateId) external isVotingActive {
        require(voterDetails[_voterId].voteCandidateId == 0, "You have already voted");
        require(voterDetails[_voterId].voterAddress == msg.sender, "Not authorized");
        require(_candidateId >= 1 && _candidateId < nextCandidateId, "Invalid candidate ID");

        voterDetails[_voterId].voteCandidateId = _candidateId;
        candidateDetails[_candidateId].votes++;
    }

    // ----------------------------
    // RESULT FUNCTION
    // ----------------------------
    function announceVotingResult() external onlyCommissioner {
        require(block.timestamp > endTime, "Voting has not ended yet");

        uint maxVote = 0;
        for (uint i = 1; i < nextCandidateId; i++) {
            if (candidateDetails[i].votes > maxVote) {
                maxVote = candidateDetails[i].votes;
                winner = candidateDetails[i].candidateAddress;
            }
        }
    }

    // ----------------------------
    // VIEW FUNCTIONS
    // ----------------------------
    function getVoterList() public view returns (Voter[] memory) {
        Voter[] memory voterList = new Voter[](nextVoterId - 1);
        for (uint i = 0; i < voterList.length; i++) {
            voterList[i] = voterDetails[i + 1];
        }
        return voterList;
    }

    function getCandidateList() public view returns (Candidate[] memory) {
        Candidate[] memory candidateList = new Candidate[](nextCandidateId - 1);
        for (uint i = 0; i < candidateList.length; i++) {
            candidateList[i] = candidateDetails[i + 1];
        }
        return candidateList;
    }
    
}
