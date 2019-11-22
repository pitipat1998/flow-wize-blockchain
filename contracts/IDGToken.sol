pragma solidity ^0.5.0;

interface IDGToken{
  function myBalance() external view returns(uint256);
  function payFee(uint amount) external returns (bool);
}
