// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { JuiceboxPay } from "../JuiceboxPay.sol";

/**
 * Juicebox v4 `pay` purchase hook.
 */
contract JuiceboxPayImmutable is JuiceboxPay {
    // =============================================================
    //                         Constructor
    // =============================================================

    /**
     * @notice Initializes the contract.
     *
     * @param productsModuleAddress_ {ProductsModule} address
     * @param slicerId_ ID of the slicer linked to this contract
     * @param projectId_ ID of the project to pay
     */
    constructor(address productsModuleAddress_, uint256 slicerId_, uint256 projectId_) {
        _productsModuleAddress = productsModuleAddress_;
        _slicerId = slicerId_;

        // Set the project ID
        projectId = projectId_;

        // Emit event
        emit JuiceboxPayContractCreated(address(this), productsModuleAddress_, slicerId_, projectId_);
    }
}
