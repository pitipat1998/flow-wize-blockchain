pragma solidity ^0.5.0;
import "./DocumentRequest.sol";

contract Action is DocumentRequest{
    
    event Accept(uint256 id);
    event Reject(uint256 id);
    
    function accept(uint256 loanRequestID,uint256 index){
        uint256 n = LRmapping[loanRequestID].length;
        for(uint256 i=0;i<n;i++){
            if(i != index){
                LRmapping[loanRequestID][index].isActive = false;
                emit Accept(index);

            }
        }
    }
    
    function reject(loanRequestID, index){
         uint256 n = LRmapping[loanRequestID].length;
        for(uint256 i=0;i<n;i++){
            if(i == index){
                LRmapping[loanRequestID][index].isActive = false;
                emit Reject(index);
            }
        }
    }
} 
