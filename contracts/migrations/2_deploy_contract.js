var TheRealEstate = artifacts.require("TheRealEstate");

module.exports = function(deployer) {
  // Arguments are: contract
  deployer.deploy(TheRealEstate);
};