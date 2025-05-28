// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { JuiceboxPayImmutable } from "./JuiceboxPayImmutable.sol";
import { IJBDirectory } from "@nana-core/interfaces/IJBDirectory.sol";

/**
 * Juicebox v4 `pay` factory contract.
 */
contract JuiceboxPayFactory {
    // =============================================================
    //                          Functions
    // =============================================================

    /**
     * @notice Deploy and initialize contract.
     */
    function deploy(address productsModuleAddress_, uint256 slicerId_, uint256 projectId_)
        external
        returns (address contractAddress)
    {
        contractAddress = address(new JuiceboxPayImmutable(productsModuleAddress_, slicerId_, projectId_));
    }
}
