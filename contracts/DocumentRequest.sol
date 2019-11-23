pragma solidity ^0.5.0;

import "./LoanRequest.sol";

contract DocumentRequest is LoanRequest {

  event RegisterBank(address indexed bank);
  event RequestDocument(address indexed bank, uint256 docRequestId, uint256 LRid, string requesting);
  event CancelDocumentRequest(address indexed bank, uint256 docRequestId, uint256 LRid, string requesting);

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

  function registerBank() external returns(bool) {
      banks[msg.sender].exists = true;
      emit RegisterBank(msg.sender);
      return true;
  }

  function requestDocument(uint256 LRid, string calldata requesting, string calldata bankName) external isBank returns(uint256) {
      DocRequest memory docRequest = DocRequest(msg.sender, LRid, requesting, bankName, true, now);
      uint256 id = docRequests.push(docRequest) - 1;
      banks[msg.sender].docRequests.push(id);
      LRmapping[LRid].push(id);
      payFee();
      emit RequestDocument(msg.sender, id, LRid, requesting);
      return id;
  }
  function cancelDocumentRequest(uint256 id) external isBank isMyBankRequest(id) returns(bool){
      docRequests[id].isActive = false;
      _returnFee(msg.sender);
      emit CancelDocumentRequest(msg.sender, id, docRequests[id].LRid, docRequests[id].requesting);
      return true;
  }
  function numOfMyBankRequests() external view isBank returns(uint256){
      return banks[msg.sender].docRequests.length;
  }
  function myBankRequestAt(uint256 id) external view isBank returns(uint256, address, uint256, string memory, bool, string memory, uint256){
      uint256 idx = banks[msg.sender].docRequests[id];
      return (idx, docRequests[idx].bank, docRequests[idx].LRid, docRequests[idx].requesting, docRequests[idx].isActive, docRequests[idx].bankName, docRequests[idx].timestamp);
  }
  function numOfAllBankRequests() external view isBank returns(uint256){
      return docRequests.length;
  }
  function bankRequestAt(uint256 id) external view isBank returns(uint256, address, uint256, string memory, bool, string memory, uint256){
      return (id, docRequests[id].bank, docRequests[id].LRid, docRequests[id].requesting, docRequests[id].isActive, docRequests[id].bankName, docRequests[id].timestamp);
  }
  function getDocumentsByLRId(uint256 LRId, uint256 idx) external view returns(uint256, address, uint256, string memory, bool, string memory, uint256){
      uint256 id = LRmapping[LRId][idx];
      return (id, docRequests[id].bank, docRequests[id].LRid, docRequests[id].requesting, docRequests[id].isActive, docRequests[id].bankName, docRequests[id].timestamp);
  }
  function getDocumentsLength(uint256 LRId) external view returns(uint256){
      return LRmapping[LRId].length;
  }
}
