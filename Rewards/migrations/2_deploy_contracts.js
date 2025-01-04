const VMTReward = artifacts.require("VMTReward");

module.exports = function (deployer) {
  deployer.deploy(VMTReward);
};
