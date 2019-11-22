pragma solidity ^0.5.0;
import "./DocumentRequest.sol";

contract Action is DocumentRequest{
    event Accept(uint256 id);
    event Reject(uint256 id);
    function accept(uint256 loanRequestID,uint256 id) external{
        uint256 n = LRmapping[loanRequestID].length;
        for(uint256 i = 0; i < n; i++){
            if(i != id){
                LRmapping[loanRequestID][id].isActive = false;
                emit Accept(id);

            }
        }
    }
    function reject(uint256 loanRequestID,uint256 id) external{
         uint256 n = LRmapping[loanRequestID].length;
        for(uint256 i = 0; i < n; i++){
            if(i == id){
                LRmapping[loanRequestID][id].isActive = false;
                emit Reject(id);
            }
        }
    }
} 
