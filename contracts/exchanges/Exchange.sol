pragma solidity  ^0.8.0;

pragma experimental ABIEncoderV2;

interface Exchange{
    function router() external view returns(address);
    function swap(address _tokenIn, address _tokenOut, address to) external ;
    function getAmountOutMin(address _tokenIn, address _tokenOut, uint256 _amountIn) external view returns (uint256) ;
}
