//SPDX-License-Identifier: MIT


// Ran the samples;
// Interacted with a Chainlink Oracle on test net to get the latest price of ETH/ USD
// Deployed a Chainlink Oracle contract on test net; sent testnet Link and use to query for 
// ETH trading volume in the past 24 hours.

// Gas savings concept: Immutable/ Constant/ Customized Errors
// Immutable variables can be declared and set inside a constructor

pragma solidity ^0.8.0;

import "./PriceConverter.sol";

contract FundMe {
    // the calculation part in terms of 1e18 can be quite confusing
    
    // using library functions
    using PriceConverter for uint256;
    
    uint256 public minimumUSD = 50 * 1e18;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    address public owner;
    
    // constructor gets called whenever a contract is deployed
    constructor() {
        // owner gets set to the address that deploys the contract
        owner = msg.sender;
    } 

    function fund() public payable {

        // msg.value is in wei 
        // needs to convert to USD
        // 18 decimal places in terms of 1 eth
        require(msg.value.getConversionRate() >= minimumUSD, "Didn't send enough!");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;

    }

    // function will run the modifier first, followed by the rest of the code
    function withdraw() public onlyOwner {

        // only owner of the contract can withdraw the fund
        // require(msg.sender == owner, "Sender is not owner!");

        for(uint256 fundIndex = 0; fundIndex < funders.length; fundIndex++) {
            address funder = funders[fundIndex];
            addressToAmountFunded[funder] = 0;
        }

        // new address array with 0 element
        funders = new address[](0);

        // transfer the money
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");        
    }

    // function decorator
    modifier onlyOwner {
        // only owner of the contract can withdraw the fund
        require(msg.sender == owner, "Sender is not owner!");
        _;
    }

    // if someone send ETH to the contract without calling the fund function and without any call data
    receive() external payable {
        // route them to the fund function
        fund();
    }

    // if someone send ETH to the contract without calling the fund function and with call data, e.g. 0x00
    fallback() external payable {
        fund();
    }

}

