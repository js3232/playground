//SPDX-License-Identifier: MIT


// Ran the samples;
// Interacted with a Chainlink Oracle on test net to get the latest price of ETH/ USD
// Deployed a Chainlink Oracle contract on test net; sent testnet Link and use to query for 
// ETH trading volume in the past 24 hours.
pragma solidity ^0.8.0;

import "./PriceConverter.sol";

contract FundMe {
    // the calculation part in terms of 1e18 can be quite confusing
    
    // using library functions
    using PriceConverter for uint256;
    
    uint256 public minimumUSD = 50 * 1e18;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    function fund() public payable {

        // msg.value is in wei 
        // needs to convert to USD
        // 18 decimal places in terms of 1 eth
        require(msg.value.getConversionRate() >= minimumUSD, "Didn't send enough!");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;

    }

    function withdraw() public {
        
    }
}

