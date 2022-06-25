pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "./Withdrawable.sol";
import "./Loander.sol";
import "./exchanges/Exchange.sol";


contract FlashBorrower is Withdrawable {
    uint256 MAX_INT = 115792089237316195423570985008687907853269984665640564039457584007913129639935;

    function swap(address exchange, address inToken, address outToken) private {
        IERC20 tokenRC20 = IERC20(inToken);
        tokenRC20.approve(exchange, MAX_INT);

        Exchange(exchange).swap(inToken, outToken, address(this));
    }

    // @dev ERC-3156 Flash loan callback
    function onFlashLoan(
        address initiator,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata data
    ) external returns (bytes32) {

        // Set the allowance to payback the flash loan
        IERC20(token).approve(msg.sender, MAX_INT);
        (Loander.ExchangeRoute[] memory route) = abi.decode(data, (Loander.ExchangeRoute[]));

        uint arrayLength = route.length;
        for (uint i = 0; i < arrayLength; i++) {
            swap(route[i].exchange, route[i].tokenIn, route[i].tokenOut);
        }
        uint balance = IERC20(token).balanceOf(address(this));
        require(balance > amount+fee, string(abi.encodePacked("Error ", uint2str(balance), " lower than ", uint2str(amount+fee))));

        // Return success to the lender, he will transfer get the funds back if allowance is set accordingly
        return keccak256("ERC3156FlashBorrower.onFlashLoan");
    }

    function uint2str(uint256 _i) internal pure returns (string memory str) {
        if (_i == 0)
        {
            return "0";
        }
        uint256 j = _i;
        uint256 length;
        while (j != 0)
        {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint256 k = length;
        j = _i;
        while (j != 0)
        {
            bstr[--k] = bytes1(uint8(48 + j % 10));
            j /= 10;
        }
        str = string(bstr);
    }

}
