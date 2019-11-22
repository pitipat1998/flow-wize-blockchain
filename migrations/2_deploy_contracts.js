var DGToken = artifacts.require("DGToken");
var LoanRequest = artifacts.require("LoanRequest");

module.exports = function(deployer) {
    deployer.deploy(DGToken);
    deployer.deploy(LoanRequest);
};
