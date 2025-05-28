// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { JuiceboxPay } from "../JuiceboxPay.sol";
import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/**
 * Juicebox v4 `pay` clone purchase hook.
 */
contract JuiceboxPayClone is JuiceboxPay, Initializable {
    // =============================================================
    //                         Initializer
    // =============================================================

    /**
     * @notice Initializes the contract.
     *
     * @param productsModuleAddress_ {ProductsModule} address
     * @param slicerId_ ID of the slicer linked to this contract
     * @param projectId_ ID of the project to pay
     */
    function initialize(address productsModuleAddress_, uint256 slicerId_, uint256 projectId_) external initializer {
        _productsModuleAddress = productsModuleAddress_;
        _slicerId = slicerId_;

        // Set the project ID
        projectId = projectId_;

        // Emit event
        emit JuiceboxPayContractCreated(address(this), productsModuleAddress_, slicerId_, projectId_);
    }
}
