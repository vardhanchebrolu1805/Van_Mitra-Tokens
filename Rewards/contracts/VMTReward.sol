// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract TokenRewards {

    struct User {
        uint256 plantsPlanted;
        uint256 tokens;
        bool isEligible;
    }

    mapping(address => User) public users;

    constructor() {
        // Initialize with some users
        users[0x2A04d34a4373AfbF92d74fF0df4B386F14234D9c] = User({plantsPlanted: 1000, tokens: 1000, isEligible: true});
        users[0xD854779Ad6FE2569E269EE4eaAcf2C6EE4F51253] = User({plantsPlanted: 500, tokens: 500, isEligible: false});
    }

    // Function to check eligibility and redeem tokens
    function redeemTokens(uint256 tokensToRedeem) public returns (string memory, uint256, uint256) {
        User storage user = users[msg.sender]; // Use the caller's address as the key

        // Check eligibility: plants planted should be exactly 1000
        if (user.plantsPlanted != 1000) {
            return ("Not Eligible", 0, user.tokens);
        }

        // Check if the user has enough tokens to redeem
        if (tokensToRedeem > user.tokens) {
            return ("Insufficient Tokens", 0, user.tokens);
        }

        // Calculate saplings based on token redemption (1 sapling per 10 tokens)
        uint256 saplings = tokensToRedeem / 10;
        user.tokens -= tokensToRedeem; // Deduct redeemed tokens

        // Return the result
        return (string(abi.encodePacked("Redeemed ", uint2str(saplings), " saplings")), saplings, user.tokens);
    }

    // Helper function to convert uint to string
    function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len - 1;
        while (_i != 0) {
            bstr[k--] = bytes1(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }
}
