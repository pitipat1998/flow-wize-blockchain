pragma solidity ^0.5.0;

import "./DGToken.sol";

contract LoanRequest is DGToken {

  event RegisterRequester(address indexed requester);
  event RequestLoan(address indexed requester, uint256 requestId, string loanType, uint256 amount);
  event CancelRequest(address indexed requester, uint256 requestId, string loanType, uint256 amount);

  struct Requester {
      uint256[] requests;
      bool exists;
  }

  struct LRequest {
        address requester;
        string loanType;
        uint256 amount;
        bool isActive;
        uint256 timestamp;
  }

  modifier isRequester() {
      require(requesters[msg.sender].exists == true);
      _;
  }

  modifier isMyRequest(uint256 id) {
      require(requests[id].requester == msg.sender);
      _;
  }

  mapping(address => Requester) internal requesters;
  LRequest[] internal requests;

  function registerRequester() external returns(bool) {
      requesters[msg.sender].exists = true;
      emit RegisterRequester(msg.sender);
      return true;
  }

  function requestLoan(string calldata loanType, uint256 amount) external isRequester returns(uint256) {
      LRequest memory lRequest = LRequest(msg.sender, loanType, amount , true, now);
      uint256 id = requests.push(lRequest) - 1;
      requesters[msg.sender].requests.push(id);
      emit RequestLoan(msg.sender, id, loanType, amount);
      return id;
  }
  function cancelRequest(uint256 id) external isRequester isMyRequest(id) returns(bool){
      requests[id].isActive = false;
      emit CancelRequest(msg.sender, id, requests[id].loanType, requests[id].amount);
      return true;
  }
  function numOfMyRequests() external view isRequester returns(uint256){
      return requesters[msg.sender].requests.length;
  }
  function myRequestAt(uint256 id) external view returns(uint256, address, string memory, uint256, bool, uint256){
      uint256 idx = requesters[msg.sender].requests[id];
      return (idx, requests[idx].requester, requests[idx].loanType, requests[idx].amount, requests[idx].isActive, requests[idx].timestamp);
  }
  function numOfAllRequests() external view returns(uint256){
      return requests.length;
  }
  function requestAt(uint256 id) external view returns(uint256, address, string memory, uint256, bool, uint256){
      return (id, requests[id].requester, requests[id].loanType, requests[id].amount, requests[id].isActive, requests[id].timestamp);
  }
}
