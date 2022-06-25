pragma solidity 0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

interface IUniswapV2Router {
  function getAmountsOut(uint256 amountIn, address[] calldata path)
  external
  view
  returns (uint256[] memory amounts);

  function WETH() external pure returns (address);

  function swapExactETHForTokens(
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline)
  external payable  returns (uint[] memory amounts);

  function swapExactTokensForETH(

  //amount of tokens we are sending in
    uint256 amountIn,
  //the minimum amount of tokens we want out of the trade
    uint256 amountOutMin,
  //list of token addresses we are going to trade in.  this is necessary to calculate amounts
    address[] calldata path,
  //this is the address we are going to send the output tokens to
    address to,
  //the last time that the trade is valid for
    uint256 deadline
  ) external returns (uint256[] memory amounts);


  function swapExactTokensForTokens(

  //amount of tokens we are sending in
    uint256 amountIn,
  //the minimum amount of tokens we want out of the trade
    uint256 amountOutMin,
  //list of token addresses we are going to trade in.  this is necessary to calculate amounts
    address[] calldata path,
  //this is the address we are going to send the output tokens to
    address to,
  //the last time that the trade is valid for
    uint256 deadline
  ) external returns (uint256[] memory amounts);
}

contract UniswapV2Exchange{
  //POLYGON :
  // sushi: 0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506
  // quick: 0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff
  // mesh: 0x10f4A785F458Bc144e3706575924889954946639
  //ETH: 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
  address public constant ROUTER = 0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff;

  function router() external view returns(address){
    return ROUTER;
  }

  function swap(address _tokenIn, address _tokenOut, address to) public  {
    IERC20 tokenIn=IERC20(_tokenIn);

    uint256 _amountIn= tokenIn.balanceOf(address(msg.sender));

    tokenIn.transferFrom(address(msg.sender),address(this),_amountIn);

    uint256 amountIn= tokenIn.balanceOf(address(this));

    tokenIn.approve(ROUTER, amountIn);

    address[] memory path;

    path = new address[](2);
    path[0] = _tokenIn;
    path[1] = _tokenOut;

    IUniswapV2Router(ROUTER).swapExactTokensForTokens(amountIn, 0, path, address(to), block.timestamp);
  }
  function getAmountOutMin(address _tokenIn, address _tokenOut, uint256 _amountIn) external view returns (uint256) {

    //path is an array of addresses.
    //this path array will have 3 addresses [tokenIn, WETH, tokenOut]
    //the if statement below takes into account if token in or token out is WETH.  then the path is only 2 addresses
    address[] memory path;

    path = new address[](2);
    path[0] = _tokenIn;
    path[1] = _tokenOut;


    uint256[] memory amountOutMins = IUniswapV2Router(ROUTER).getAmountsOut(_amountIn, path);
    return amountOutMins[1];
  }
}
