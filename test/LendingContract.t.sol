// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import { MockERC20 } from "./MockERC20.sol";

contract LendingContractTest is Test {
    MockERC20 token;
    address user = address(0x123);
    address receiver = address(0x456);

    function setUp() public {
        token = new MockERC20(1000 * 10 ** 18); // Providing the initial supply of 1000 tokens
    }

    // 1. Check initial balance of the deployer (should have 1000 tokens)
    function testInitialBalance() public {
        assertEq(token.balanceOf(address(this)), 1000 * 10 ** 18);
    }

    // 2. Transfer tokens to another user and check balances
    function testTransfer() public {
        uint256 amount = 100 * 10 ** 18;

        // Transfer 100 tokens from deployer (address(this)) to user (address(0x123))
        token.transfer(user, amount);

        // Check balances after transfer
        assertEq(token.balanceOf(address(this)), 1000 * 10 ** 18 - amount);
        assertEq(token.balanceOf(user), amount);
    }

    // 3. Test the approve and transferFrom functionality (allowance)
    function testApproveAndTransferFrom() public {
        uint256 amount = 50 * 10 ** 18;

        // Approve the user to spend 50 tokens from the deployer's balance
        token.approve(user, amount);

        // Now, user can transfer 50 tokens on behalf of the deployer
        token.transferFrom(address(this), receiver, amount);

        // Check balances after transfer
        assertEq(token.balanceOf(address(this)), 1000 * 10 ** 18 - amount);
        assertEq(token.balanceOf(receiver), amount);
        assertEq(token.allowance(address(this), user), 0);  // Allowance should be 0 after transfer
    }

    // 4. Transfer tokens to a contract (receiver) and check balance
    function testTransferToContract() public {
        uint256 amount = 200 * 10 ** 18;

        // Transfer tokens to the contract
        token.transfer(receiver, amount);

        // Check balances after transfer
        assertEq(token.balanceOf(address(this)), 1000 * 10 ** 18 - amount);
        assertEq(token.balanceOf(receiver), amount);
    }

    // 5. Test Minting (if available in your contract)
    function testMinting() public {
        // Mint new tokens to the contract
        token.mint(address(this), 500 * 10 ** 18);

        // Verify the new balance after minting
        assertEq(token.balanceOf(address(this)), 1000 * 10 ** 18 + 500 * 10 ** 18);
    }

    // 6. Test Transfer to a user (sender balance decreases)
    function testTransferAndCheckSenderBalance() public {
        uint256 amount = 150 * 10 ** 18;

        // Transfer 150 tokens from deployer (address(this)) to user
        token.transfer(user, amount);

        // Check sender (deployer) balance after transfer
        assertEq(token.balanceOf(address(this)), 1000 * 10 ** 18 - amount);
    }

    // 7. Test Transfer from the user account to another user
    function testTransferFromUser() public {
        uint256 amount = 50 * 10 ** 18;

        // Transfer tokens to user first
        token.transfer(user, amount);

        // Approve the contract to spend tokens from user's balance
        token.approve(address(this), amount);

        // Transfer from user to receiver (contract has been approved to spend)
        token.transferFrom(user, receiver, amount);

        // Check balances after transfer
        assertEq(token.balanceOf(user), 0);  
        assertEq(token.balanceOf(receiver), amount);
    }
}
