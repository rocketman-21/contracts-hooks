// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { JuiceboxPayClone } from "./JuiceboxPayClone.sol";
import { Clones } from "@openzeppelin/contracts/proxy/Clones.sol";

/**
 * Juicebox v4 `pay` clone factory contract.
 */
contract JuiceboxPayCloner {
    /// ============= Storage =============

    address private immutable implementation;

    /// ========== Constructor ==========

    /**
     * @notice Initializes the contract and deploys the clone implementation.
     */
    constructor() {
        implementation = address(new JuiceboxPayClone());
    }

    /// ============ Functions ============

    /**
     * @notice Deploy and initialize proxy clone.
     *
     * @param productsModuleAddress_ {ProductsModule} address
     * @param slicerId_ ID of the slicer linked to this contract
     * @param projectId_ ID of the project to pay
     */
    function clone(address productsModuleAddress_, uint256 slicerId_, uint256 projectId_)
        external
        returns (address contractAddress)
    {
        // Deploys proxy clone
        contractAddress = Clones.clone(implementation);

        // Initialize proxy
        JuiceboxPayClone(contractAddress).initialize(productsModuleAddress_, slicerId_, projectId_);
    }
}
