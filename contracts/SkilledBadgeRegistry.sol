// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SkillBadgeRegistry {
    address public admin;

    struct Badge {
        string studentName;
        string skillName;
        string issueDate;
        bytes32 credentialHash;
        bool isValid;
    }

    mapping(bytes32 => Badge) public badges;
    mapping(address => bytes32[]) public studentBadges;

    event BadgeIssued(bytes32 indexed credentialHash, address indexed student, string skillName);
    event BadgeRevoked(bytes32 indexed credentialHash);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only institution admin can issue badges");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function issueBadge(
        address student,
        string memory studentName,
        string memory skillName,
        string memory issueDate,
        string memory uniqueSalt
    ) public onlyAdmin returns (bytes32) {
        bytes32 credentialHash = keccak256(
            abi.encodePacked(student, studentName, skillName, issueDate, uniqueSalt)
        );

        require(!badges[credentialHash].isValid, "Badge already exists");

        badges[credentialHash] = Badge({
            studentName: studentName,
            skillName: skillName,
            issueDate: issueDate,
            credentialHash: credentialHash,
            isValid: true
        });

        studentBadges[student].push(credentialHash);

        emit BadgeIssued(credentialHash, student, skillName);
        return credentialHash;
    }

    function verifyBadge(bytes32 credentialHash) public view returns (
        bool isValid,
        string memory studentName,
        string memory skillName,
        string memory issueDate
    ) {
        Badge memory b = badges[credentialHash];
        require(b.isValid, "Invalid or non-existent credential hash");
        return (b.isValid, b.studentName, b.skillName, b.issueDate);
    }
}