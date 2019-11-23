pragma solidity ^0.5.0;
import "./DocumentRequest.sol";

contract Action is DocumentRequest{
    event Accept(uint256 id);
    event Reject(uint256 id);
    function accept(uint256 loanRequestID, uint256 idx) external{
        uint256 n = LRmapping[loanRequestID].length;
        uint256 id = LRmapping[loanRequestID][idx];
        for(uint256 i = 0; i < n; i++){
            if(i != idx){
                uint256 tmp = LRmapping[loanRequestID][i];
                docRequests[tmp].isActive = false;
                _returnFee(docRequests[tmp].bank);
                emit Reject(tmp);
            }
        }
        emit Accept(id);
    }
    function reject(uint256 loanRequestID, uint256 idx) external{
        uint256 id = LRmapping[loanRequestID][idx];
        docRequests[id].isActive = false;
        _returnFee(docRequests[id].bank);
        emit Reject(id);
    }
}

