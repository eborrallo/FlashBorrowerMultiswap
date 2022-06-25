pragma solidity 0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


interface IUniswapV3Router {
  struct ExactInputSingleParams {
    address tokenIn;
    address tokenOut;
    uint24 fee;
    address recipient;
    uint256 deadline;
    uint256 amountIn;
    uint256 amountOutMinimum;
    uint160 sqrtPriceLimitX96;
  }

  function exactInputSingle(ExactInputSingleParams calldata params) external payable returns (uint256 amountOut);
}

contract UniswapV3Exchange{
    //POLYGON : 0x1F98431c8aD98523631AE4a59f267346ea31F984
  //ETH: 0xE592427A0AEce92De3Edee1F18E0157C05861564
  address public constant ROUTER = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
  uint256 private constant approve_amount = 115792089237316195423570985008687907853269984665640564039457584007913129639935;

  function router() external view returns(address){
    return ROUTER;
  }

  function swap(address _tokenIn, address _tokenOut, address to) public  {

    IERC20 tokenInERC20=IERC20(_tokenIn);

    uint256 amountIn = tokenInERC20.balanceOf(address(msg.sender));

    tokenInERC20.transferFrom(address(msg.sender),address(this),amountIn);
    tokenInERC20.approve(ROUTER, approve_amount);

    uint24  poolFee = 3000;

    IUniswapV3Router.ExactInputSingleParams memory params =
    IUniswapV3Router.ExactInputSingleParams({
    tokenIn: _tokenIn,
    tokenOut: _tokenOut,
    fee: poolFee,
    recipient: to,
    deadline: block.timestamp,
    amountIn: amountIn,
    amountOutMinimum: 0,
    sqrtPriceLimitX96: 0
    });

    IUniswapV3Router(ROUTER).exactInputSingle(params);
  }

}
