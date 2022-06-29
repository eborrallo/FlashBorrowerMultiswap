# IMPORTANT This is a proof of concept of Flashloans

This project demonstrates a how you can create a flash loand and swap the money in diferents defis in the same transaction

The project comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts. It also comes with a variety of other tools, preconfigured to work with the project code.

The project provide a FlashBorrower of ERC-3156 callback and on it you can you can send a array of the routes do you want to do the swap. The strucure of this array will be array of objects 
```shell
    struct ExchangeRoute{
        address exchange;
        address tokenIn;
        address tokenOut;
    }
```

The exchange address is a contract address with this interface 

```shell
interface Exchange{
    function router() external view returns(address);
    function swap(address _tokenIn, address _tokenOut, address to) external ;
    function getAmountOutMin(address _tokenIn, address _tokenOut, uint256 _amountIn) external view returns (uint256) ;
}
```

```shell

```
# Example

For faster runs of your tests and scripts, consider skipping ts-node's type checking by setting the environment variable `TS_NODE_TRANSPILE_ONLY` to `1` in hardhat's environment. For more details see [the documentation](https://hardhat.org/guides/typescript.html#performance-optimizations).

```shell
contract Playground {

    function play(address borrower, uint amount) external {
        Loander loander= Loander(<ERC-3156 contract>);

        address SushiSwapContractExchnge=<contract address with Exchange of Sushiswap implementation>;
        address QuickSwapContractExchnge=<contract address with Exchange of Quickswao implementation>;
        address UniSwapV3ContractExchnge=<contract address with Exchange of Uniswapv3 implementation>;

        address USDT = 0xc2132D05D31c914a87C6611C10748AEb04B58e8F;
        address DAI = 0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063;
        address WETH = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
        address USDC = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
        address LINK = 0x53E0bca35eC356BD5ddDFebbD1Fc0fD03FaBad39;

         Loander.ExchangeRoute[] memory route=new  Loander.ExchangeRoute[](2);
        route[0]=Loander.ExchangeRoute(UniSwapV3ContractExchnge,WETH,DAI);
        route[1]=Loander.ExchangeRoute(QuickSwapContractExchnge,DAI,WETH);

          bytes memory data= abi.encode(route);
        loander.flashLoan(borrower,<token addres to loan>,amount,data);
    }
 }
```


