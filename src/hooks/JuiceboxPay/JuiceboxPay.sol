// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../extensions/Purchasable/SlicerPurchasable.sol";
import { IJBDirectory } from "@nana-core/interfaces/IJBDirectory.sol";
import { IJBTerminal } from "@nana-core/interfaces/IJBTerminal.sol";

/**
 * Juicebox v4 `pay` purchase hook.
 */
abstract contract JuiceboxPay is SlicerPurchasable {

    // ===========================================================
    //                           Events
    //  ============================================================
    
    event JuiceboxPayContractCreated(address contractAddress, address productsModuleAddress, uint256 slicerId, uint256 projectId);

    event JuiceboxSlicerPayment(address contractAddress, address productsModuleAddress, uint256 slicerId, uint256 projectId, address beneficiary, uint256 paidAmount, uint256 beneficiaryTokenCount);

    // =============================================================
    //                           Storage
    // =============================================================

    address public constant ETH = 0x000000000000000000000000000000000000EEEe;

    IJBDirectory public constant directory = IJBDirectory(0x0bC9F153DEe4d3D474ce0903775b9b2AAae9AA41);

    uint256 public projectId;

    // =============================================================
    //                           Errors
    // =============================================================
    
    error TerminalNotFound();

    // =============================================================
    //                          Functions
    // =============================================================

    /**
     * @notice Describe purchase requirements
     *
     * @dev Anyone can buy this product
     */
    function isPurchaseAllowed(uint256, uint256, address, uint256, bytes memory, bytes memory)
        public
        view
        virtual
        override
        returns (bool isAllowed)
    {
        isAllowed = true;
    }

    /**
     * @notice Pay the JBTerminal for the project with ETH
     *
     * @dev Overridable function to handle external calls on product purchases from slicers. See {ISlicerPurchasable}
     */
    function onProductPurchase(
        uint256 slicerId,
        uint256 productId,
        address account,
        uint256 quantity,
        bytes memory slicerCustomData,
        bytes memory buyerCustomData
    ) public payable override onlyOnPurchaseFrom(slicerId) {
        // Check whether the account is allowed to buy a product.
        if (!isPurchaseAllowed(slicerId, productId, account, quantity, slicerCustomData, buyerCustomData)) {
            revert NotAllowed();
        }

        // Get the primary terminal for the project, assume payment in ETH.
        IJBTerminal terminal = _getPrimaryTerminal(projectId, ETH);

        if (address(terminal) == address(0)) {
            revert TerminalNotFound();
        }

        // Pay the terminal with the ETH sent with the transaction
        uint256 beneficiaryTokenCount = terminal.pay{value: msg.value}(
            projectId,
            ETH, // ETH token address
            msg.value, // Amount of ETH being paid
            account, // Beneficiary receives the project tokens
            0, // No minimum returned tokens required
            "Order via slice.so", // Memo for the payment
            "" // No additional metadata
        );

        // Emit event
        emit JuiceboxSlicerPayment(address(this), _productsModuleAddress, slicerId, projectId, account, msg.value, beneficiaryTokenCount);
    }

    /**
     * @notice Get the primary terminal for a project and token
     *
     * @param _projectId The ID of the project
     * @param token The address of the token
     * @return terminal The primary terminal for the project and token
     */
    function _getPrimaryTerminal(uint256 _projectId, address token) internal view returns (IJBTerminal terminal) {
        terminal = directory.primaryTerminalOf(_projectId, token);
    }
}
