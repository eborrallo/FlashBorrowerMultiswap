pragma solidity  ^0.8.0;

pragma experimental ABIEncoderV2;

interface Loander{
    function flashLoan( address r, address t, uint256 a, bytes calldata data) external;
    function maxFlashLoan(address token)  external view returns(uint256);
    struct ExchangeRoute{
        address exchange;
        address tokenIn;
        address tokenOut;
    }
}

