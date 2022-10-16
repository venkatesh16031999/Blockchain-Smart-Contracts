// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.7.6;
import "./interfaces/ICompound.sol";

contract Compound {
    Erc20 token;
    CErc20 cToken;

    constructor(address _token, address _cToken) {
        token = Erc20(_token);
        cToken = CErc20(_cToken);
    }

    function supply(uint _amount) external {
        token.transferFrom(msg.sender, address(this), _amount);
        token.approve(address(cToken), _amount);
        require(cToken.mint(_amount) == 0, "Supply failed");
    }

    function balanceOfCToken() external view returns (uint) {
        return cToken.balanceOf(address(this));
    }

    function balanceOfUnderlying() external returns (uint) {
        return cToken.balanceOfUnderlying(address(this));
    }

    function redeem(uint _cTokenAmount) external {
        require(cToken.redeem(_cTokenAmount) == 0, "redeem failed");
        // cToken.redeemUnderlying(underlying amount);
    }
}
