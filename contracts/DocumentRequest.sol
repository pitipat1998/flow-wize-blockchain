pragma solidity ^0.5.0;

contract DocumentRequest {

  event RegisterBank(address indexed requester);
  event RequestDocument(address indexed requester, uint256 requestId, uint256 LRid, string requesting);
  event CancelDocumentRequest(address indexed requester, uint256 requestId, uint256 LRid, string requesting);

  struct Bank {
      uint256[] requests;
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
      require(requests[id].bank == msg.sender);
      _;
  }
  
  mapping(address => Bank) internal banks;
  mapping(uint256 => DocRequest[]) internal LRmapping;
  DocRequest[] internal requests;
  
  function registerBank() external returns(bool) {
      banks[msg.sender].exists = true;
      emit RegisterBank(msg.sender);
      return true;
  }
  
  function requestDocument(uint256 LRid, string calldata requesting, string calldata bankName) external isBank returns(uint256) {
      DocRequest memory docRequest = DocRequest(msg.sender, LRid, requesting, bankName, true, now);
      uint256 id = requests.push(docRequest) - 1;
      banks[msg.sender].requests.push(id);
      LRmapping[LRid].push(docRequest);
      emit RequestDocument(msg.sender, id, LRid, requesting);
      return id;
  }
  function cancelDocumentRequest(uint256 id) external isBank isMyBankRequest(id) returns(bool){
      requests[id].isActive = false;
      emit CancelDocumentRequest(msg.sender, id, requests[id].LRid, requests[id].requesting);
      return true;
  }
  function numOfMyBankRequests() external view isBank returns(uint256){
      return banks[msg.sender].requests.length;
  }
  function myBankRequestAt(uint256 id) external view returns(uint256, address, uint256, string memory, bool, string memory, uint256){
      uint256 idx = banks[msg.sender].requests[id];
      return (idx, requests[idx].bank, requests[idx].LRid, requests[idx].requesting, requests[idx].isActive, requests[idx].bankName, requests[idx].timestamp);
  }
  function numOfAllBankRequests() external view returns(uint256){
      return requests.length;
  }
  function bankRequestAt(uint256 id) external view returns(address, uint256, string memory, bool, string memory, uint256){
      return (requests[id].bank, requests[id].LRid, requests[id].requesting, requests[id].isActive, requests[id].bankName, requests[id].timestamp);
  }
  function getDocumentsByLRid(uint256 LRId, uint256 idx) external view returns(address, uint256, string memory, bool, string memory, uint256){
      return (LRmapping[LRId][idx].bank, LRmapping[LRId][idx].LRid, LRmapping[LRId][idx].requesting, LRmapping[LRId][idx].isActive, LRmapping[LRId][idx].bankName, LRmapping[LRId][idx].timestamp);
  }
  function getDocumentsLength(uint256 LRId) external view returns(uint256){
      return LRmapping[LRId].length;
  }
}
