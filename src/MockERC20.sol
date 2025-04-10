// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20 {
    constructor() ERC20("Mock Token", "MTK") {}

    // Mint function to simulate token creation
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}
