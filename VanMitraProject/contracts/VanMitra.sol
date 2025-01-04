// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VanMitra {

    struct User {
        uint256 plantsPlanted;
        uint256 healthyPlants;
        uint256 survivalRate;
        uint256 VMTs;
    }

    address public owner;
    mapping(address => User) public users;
    address[] public userAddresses;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    function updatePlantData(address user, uint256 plantsPlanted, uint256 healthyPlants) public onlyOwner {
        require(plantsPlanted > 0, "Plants planted must be greater than zero");
        require(healthyPlants <= plantsPlanted, "Healthy plants cannot exceed plants planted");

        User storage u = users[user];
        u.plantsPlanted = plantsPlanted;
        u.healthyPlants = healthyPlants;

        u.survivalRate = (healthyPlants * 100) / plantsPlanted;

        if (u.plantsPlanted == 0) {
            userAddresses.push(user);
        }
    }

    function calculateAndDistributeRewards() public onlyOwner {
        require(userAddresses.length > 0, "No users available");
        _sortUsersBySurvivalRate();

        for (uint256 i = 0; i < userAddresses.length && i < 50; i++) {
            address user = userAddresses[i];
            if (i < 10) {
                users[user].VMTs = 1000 - (i * 50);
            } else {
                users[user].VMTs = 500;
            }
        }
    }

    function _sortUsersBySurvivalRate() internal {
        for (uint256 i = 0; i < userAddresses.length - 1; i++) {
            for (uint256 j = i + 1; j < userAddresses.length; j++) {
                if (users[userAddresses[i]].survivalRate < users[userAddresses[j]].survivalRate) {
                    address temp = userAddresses[i];
                    userAddresses[i] = userAddresses[j];
                    userAddresses[j] = temp;
                }
            }
        }
    }

    function getTop50Users() public view returns (address[] memory, uint256[] memory, uint256[] memory, uint256[] memory, uint256[] memory) {
        uint256 topCount = userAddresses.length > 50 ? 50 : userAddresses.length;
        address[] memory topUsers = new address[](topCount);
        uint256[] memory plantsPlanted = new uint256[](topCount);
        uint256[] memory healthyPlants = new uint256[](topCount);
        uint256[] memory survivalRates = new uint256[](topCount);
        uint256[] memory rankings = new uint256[](topCount);

        for (uint256 i = 0; i < topCount; i++) {
            address user = userAddresses[i];
            topUsers[i] = user;
            plantsPlanted[i] = users[user].plantsPlanted;
            healthyPlants[i] = users[user].healthyPlants;
            survivalRates[i] = users[user].survivalRate;
            rankings[i] = i + 1;
        }
        return (topUsers, plantsPlanted, healthyPlants, survivalRates, rankings);
    }
}
