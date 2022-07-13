//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FallbackExample {
    uint256 public result;

    // when you transact without the call data
    receive() external payable {
        result = 1;
    }

    // when you transact with the call data
    fallback() external payable {
        result = 2;
    }

}