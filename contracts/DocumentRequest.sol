pragma solidity ^0.5.0;

import "./LoanRequest.sol";

contract DocumentRequest is LoanRequest {

  event RegisterBank(address indexed bank);
  event RequestDocument(address indexed bank, string bankName, uint256 docRequestId, uint256 LRid, string requesting, uint256 timestamp);
  event CancelDocumentRequest(address indexed bank, string bankName, uint256 docRequestId, uint256 LRid, string requesting, uint256 timestamp);

  struct Bank {
      uint256[] docRequests;
      bool exists;
  }

  struct DocRequest {
        address bank;
        uint256 LRid;
        string requesting;
        string bankName;
        bool isActive;
        uint256 timestamp;
        string status;
        string links;
  }

  modifier isBank() {
      require(banks[msg.sender].exists == true);
      _;
  }

  modifier isMyBankRequest(uint256 id) {
      require(docRequests[id].bank == msg.sender);
      _;
  }

  mapping(address => Bank) internal banks;
  mapping(uint256 => uint256[]) internal LRmapping;
  DocRequest[] internal docRequests;

  function registerBank(address bank) external isOwner returns(bool) {
      banks[bank].exists = true;
      emit RegisterBank(bank);
      return true;
  }
  
  function requestDocument(uint256 LRid, string calldata requesting, string calldata bankName) external isBank returns(uint256) {
      DocRequest memory docRequest = DocRequest(msg.sender, LRid, requesting, bankName, true, now, "pending", "");
      uint256 id = docRequests.push(docRequest) - 1;
      banks[msg.sender].docRequests.push(id);
      LRmapping[LRid].push(id);
      payFee();
      emit RequestDocument(msg.sender, bankName, id, LRid, requesting, now);
      return id;
  }
  
  function cancelDocumentRequest(uint256 id) external isBank isMyBankRequest(id) returns(bool){
      docRequests[id].isActive = false;
      _returnFee(msg.sender);
      docRequests[id].status = "canceled";
      emit CancelDocumentRequest(msg.sender, docRequests[id].bankName, id, docRequests[id].LRid, docRequests[id].requesting, now);
      return true;
  }
  
  function numOfMyBankRequests() external view isBank returns(uint256){
      return banks[msg.sender].docRequests.length;
  }
  
  function myBankRequestAt(uint256 id) external view isBank returns( 
    uint256, 
    address, 
    uint256, 
    string memory, 
    bool, 
    string memory, 
    uint256, 
    string memory,
    string memory){
      uint256 idx = banks[msg.sender].docRequests[id];
      DocRequest memory dr = docRequests[idx];
      return (
          idx, 
          dr.bank, 
          dr.LRid, 
          dr.requesting, 
          dr.isActive, 
          dr.bankName, 
          dr.timestamp, 
          dr.status,
          dr.links
      );
  }
  
  function numOfAllBankRequests() external view returns(uint256){
      return docRequests.length;
  }
  
  function bankRequestAt(uint256 id) external view returns(
    uint256, 
    address, 
    uint256, 
    string memory, 
    bool, 
    string memory, 
    uint256, 
    string memory){
      DocRequest memory dr = docRequests[id];
      return (
          id, 
          dr.bank, 
          dr.LRid, 
          dr.requesting, 
          dr.isActive, 
          dr.bankName, 
          dr.timestamp, 
          dr.status
      );
  }
  
  function getDocumentsByLRId(uint256 LRId, uint256 idx) external isMyRequest(LRId) view returns (
    uint256, 
    address, 
    uint256, 
    string memory, 
    bool, 
    string memory, 
    uint256, 
    string memory){
      uint256 id = LRmapping[LRId][idx];
      DocRequest memory dr = docRequests[id];
      return (
          id, 
          dr.bank, 
          dr.LRid, 
          dr.requesting, 
          dr.isActive, 
          dr.bankName, 
          dr.timestamp, 
          dr.status
      );
  }
  
  function getDocumentsLength(uint256 LRId) external view isMyRequest(LRId) returns(uint256){
      return LRmapping[LRId].length;
  }
  
}
