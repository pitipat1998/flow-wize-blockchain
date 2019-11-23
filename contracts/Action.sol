pragma solidity ^0.5.0;
import "./DocumentRequest.sol";

contract Action is DocumentRequest {
    
    event Accept(uint256 id);
    event Reject(uint256 id);
    event GrantDocumentsAccess(uint256 docRequestId);
    
    function accept(uint256 loanRequestID, uint256 idx) external isRequester isMyRequest(loanRequestID) {
        uint256 n = LRmapping[loanRequestID].length;
        uint256 id = LRmapping[loanRequestID][idx];
        for(uint256 i = 0; i < n; i++){
            if(i != idx){
                uint256 tmp = LRmapping[loanRequestID][i];
                docRequests[tmp].isActive = false;
                docRequests[tmp].status = "rejected";
                _returnFee(docRequests[tmp].bank);
                emit Reject(tmp);
            }
        }
        requests[loanRequestID].isActive = false;
        docRequests[id].status = "accepted";
        emit Accept(id);
    }
    
    function reject(uint256 loanRequestID, uint256 idx) external isRequester isMyRequest(loanRequestID) {
        uint256 id = LRmapping[loanRequestID][idx];
        docRequests[id].isActive = false;
        docRequests[id].status = "rejected";
        _returnFee(docRequests[id].bank);
        emit Reject(id);
    }
    
    function transferDocs(uint256 docRequestId, string calldata links) external isOwner {
        docRequests[docRequestId].links = links;
        emit GrantDocumentsAccess(docRequestId);
    }
}

