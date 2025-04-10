// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LendingContract {
    IERC20 public token;
    mapping(address => uint256) public deposits;

    constructor(address _token) {
        token = IERC20(_token);
    }

    // Deposit function
    function deposit(uint256 amount) external {
        require(token.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        deposits[msg.sender] += amount;
    }

    // Borrow function
    function borrow(uint256 amount) external {
        require(deposits[msg.sender] >= amount, "Insufficient deposit");
        require(token.transfer(msg.sender, amount), "Borrow transfer failed");
    }

    // Function to check the deposit balance
    function checkDeposit() external view returns (uint256) {
        return deposits[msg.sender];
    }
}
