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
    function getEthMainnetConfig() public view returns (NetworkConfig memory) {
        NetworkConfig memory EthMainnetConfig = NetworkConfig({
            initialOwner: msg.sender,
            GelatoDedicatedMsgSender: 0x823F9f50f6A6E52CC4073Ff1493D4a8482D8Aba4,
            serviceFee: 0
        });
        return EthMainnetConfig;
    }

    function getSepoliaConfig() public view returns (NetworkConfig memory) {
        NetworkConfig memory SepoliaConfig = NetworkConfig({
            initialOwner: msg.sender,
            GelatoDedicatedMsgSender: 0x823F9f50f6A6E52CC4073Ff1493D4a8482D8Aba4,
            serviceFee: 0
        });
        return SepoliaConfig;
    }

    function getModeMainnetConfig() public view returns (NetworkConfig memory) {
        return NetworkConfig({
            initialOwner: msg.sender,
            GelatoDedicatedMsgSender: 0x823F9f50f6A6E52CC4073Ff1493D4a8482D8Aba4,
            serviceFee: 0
        });
    }

    function getOpMainnetConfig() public view returns (NetworkConfig memory) {
        return NetworkConfig({
            initialOwner: msg.sender,
            GelatoDedicatedMsgSender: 0x823F9f50f6A6E52CC4073Ff1493D4a8482D8Aba4,
            serviceFee: 0
        });
    }

    function getOPSepoliaConfig() public view returns (NetworkConfig memory) {
        return NetworkConfig({
            initialOwner: msg.sender,
            GelatoDedicatedMsgSender: 0x823F9f50f6A6E52CC4073Ff1493D4a8482D8Aba4,
            serviceFee: 0
        });
    }

    function getBaseMainnetConfig() public view returns (NetworkConfig memory) {
        return NetworkConfig({
            initialOwner: msg.sender,
            GelatoDedicatedMsgSender: 0x823F9f50f6A6E52CC4073Ff1493D4a8482D8Aba4,
            serviceFee: 0
        });
    }

    function getBaseSepoliaConfig() public view returns (NetworkConfig memory) {
        return NetworkConfig({
            initialOwner: msg.sender,
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
