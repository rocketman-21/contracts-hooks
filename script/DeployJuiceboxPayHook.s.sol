// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "forge-std/Script.sol";
import {JuiceboxPayCloner} from "../src/hooks/JuiceboxPay/clones/JuiceboxPayCloner.sol";
import {JuiceboxPayFactory} from "../src/hooks/JuiceboxPay/immutable/JuiceboxPayFactory.sol";

contract DeployJuiceboxPayHook is Script {
    address deployer = vm.rememberKey(vm.envUint("PRIVATE_KEY"));

    function run() public returns (JuiceboxPayCloner cloner, JuiceboxPayFactory factory) {
        vm.startBroadcast(deployer);

        cloner = new JuiceboxPayCloner();
        factory = new JuiceboxPayFactory();

        vm.stopBroadcast();
    }
}
