// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.1;

import "@openzeppelin/contracts/utils/escrow/ConditionalEscrow.sol";

contract EscrowPayment is ConditionalEscrow {
    mapping(address => bool) public withdrawStatus;

    function allowWithdrawal(address _payee) external onlyOwner {
        require(_payee != address(0), "Zero address is not allowed");
        require(_payee != address(this), "Current contract cannot be payee");
        withdrawStatus[_payee] = true;
    }

    function withdrawalAllowed(address _payee)
        public
        view
        virtual
        override(ConditionalEscrow)
        returns (bool)
    {
        return withdrawStatus[_payee];
    }

    function withdraw(address payable _payee)
        public
        virtual
        override(ConditionalEscrow)
    {
        super.withdraw(_payee);
        withdrawStatus[_payee] = false;
    }
}
