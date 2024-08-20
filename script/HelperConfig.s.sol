// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { Script, console2 } from "forge-std/Script.sol";

contract HelperConfig is Script {
    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/
    error HelperConfig__InvalidChainId();

    /*//////////////////////////////////////////////////////////////
                                 TYPES
    //////////////////////////////////////////////////////////////*/
    struct NetworkConfig {
        address initialOwner;
        address GelatoDedicatedMsgSender;
        uint256 serviceFee;
    }

    /*//////////////////////////////////////////////////////////////
                                CONFIGS
    //////////////////////////////////////////////////////////////*/
    function getEthMainnetConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory EthMainnetConfig = NetworkConfig({
            initialOwner: 0xfe63Ba8189215E5C975e73643b96066B6aD41A45,
            GelatoDedicatedMsgSender: 0x823F9f50f6A6E52CC4073Ff1493D4a8482D8Aba4,
            serviceFee: 0
        });
        return EthMainnetConfig;
    }

    function getSepoliaConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory SepoliaConfig = NetworkConfig({
            initialOwner: 0xfe63Ba8189215E5C975e73643b96066B6aD41A45,
            GelatoDedicatedMsgSender: 0x823F9f50f6A6E52CC4073Ff1493D4a8482D8Aba4,
            serviceFee: 0
        });
        return SepoliaConfig;
    }

    function getModeMainnetConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({
            initialOwner: 0xfe63Ba8189215E5C975e73643b96066B6aD41A45,
            GelatoDedicatedMsgSender: 0x823F9f50f6A6E52CC4073Ff1493D4a8482D8Aba4,
            serviceFee: 0
        });
    }

    function getOpMainnetConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({
            initialOwner: 0xfe63Ba8189215E5C975e73643b96066B6aD41A45,
            GelatoDedicatedMsgSender: 0x823F9f50f6A6E52CC4073Ff1493D4a8482D8Aba4,
            serviceFee: 0
        });
    }

    function getBaseMainnetConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({
            initialOwner: 0xfe63Ba8189215E5C975e73643b96066B6aD41A45,
            GelatoDedicatedMsgSender: 0x823F9f50f6A6E52CC4073Ff1493D4a8482D8Aba4,
            serviceFee: 0
        });
    }

    /*//////////////////////////////////////////////////////////////
                              LOCAL CONFIG
    //////////////////////////////////////////////////////////////*/
    function getAnvilConfig() public pure returns (NetworkConfig memory) {
        console2.log("Testing On Anvil Network");
        NetworkConfig memory AnvilConfig =
            NetworkConfig({ initialOwner: address(1), GelatoDedicatedMsgSender: address(2), serviceFee: 0 });
        return AnvilConfig;
    }
}
