// SPDX-License-Identifier: MIT

pragma solidity 0.7.6;

interface Erc20 {
    function balanceOf(address) external view returns (uint);

    function approve(address, uint256) external returns (bool);

    function transfer(address, uint256) external returns (bool);

    function transferFrom(
        address src,
        address dst,
        uint wad
    ) external returns (bool);
}

interface CErc20 {
    function balanceOf(address) external view returns (uint);

    function mint(uint256) external returns (uint256);

    function exchangeRateCurrent() external returns (uint256);

    function supplyRatePerBlock() external returns (uint256);

    function redeem(uint) external returns (uint);

    function redeemUnderlying(uint) external returns (uint);

    function balanceOfUnderlying(address) external returns (uint);
}
