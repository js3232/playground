//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import from github
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


// create a library
// functions in a library makes available to objects to get called similar to Python's method;
// all functions must be "internal" instead of public;

library PriceConverter {
    // returns the price of eth in terms of USD, 18 decimal places
    function getPrice() internal view returns (uint256) {
        // interacts with another contract:-
        // needs ABI & contract address on Rinkeby test net: 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (     
            ,
            int256 price,
            ,
            ,
            ) = priceFeed.latestRoundData();

        // standardize the decimal places as msg.value
        return uint256(price * 1e10);
    }

    // check the number of decimals in the returned price data
    // returns: 8
    function getDecimal() internal view returns (uint8) {
        return AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e).decimals();
    }
    
    
    function getVersion() internal view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();

    }

    function getConversionRate(uint256 ethAmount) internal view returns (uint256) {

        // sample calculation as follows, assuming ETH prices at USD 3287 at the moment:
        // 1) the oracle will return something like : 3287_12345678 (_ is just a separator) as part of the function call
        // 2) multipliy (1) by 1e10 yields 3287_12345678_0000000000;
        // 3) say, we have 1.5eth (1_5000000000000000000);
        // 4) then getConversionRate returns 4.930e21 (with 18 dp corrected for eth price)

        uint256 ethPrice = getPrice();

        // ethAmount/1e18 = x amount of ETH
        uint256 ethAmountInUSD = (ethPrice * ethAmount) / 1e18; 
        return ethAmountInUSD;
    }
}