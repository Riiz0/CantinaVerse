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
        address initialGelatoAddress;
    }

    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    uint256 constant ETH_MAINNET_CHAIN_ID = 1;
    uint256 constant ETH_SEPOLIA_CHAIN_ID = 11_155_111;

    uint256 constant ZKSYNC_MAINNET_CHAIN_ID = 324;
    uint256 constant ZKSYNC_SEPOLIA_CHAIN_ID = 300;

    uint256 constant POLYGON_MAINNET_CHAIN_ID = 137;
    uint256 constant POLYGON_MUMBAI_CHAIN_ID = 80_001;

    uint256 constant MODE_MAINNET_CHAIN_ID = 34_443;
    uint256 constant MODE_SEPOLIA_CHAIN_ID = 919;

    uint256 constant OP_MAINNET_CHAIN_ID = 10;
    uint256 constant OP_SEPOLIA_CHAIN_ID = 11_155_420;

    uint256 constant BASE_MAINNET_CHAIN_ID = 8453;
    uint256 constant BASE_SEPOLIA_CHAIN_ID = 84_532;

    // Local network state variables
    NetworkConfig public localNetworkConfig;
    mapping(uint256 chainId => NetworkConfig) public networkConfigs;

    /*//////////////////////////////////////////////////////////////
                               FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    constructor() {
        networkConfigs[ETH_MAINNET_CHAIN_ID] = getEthMainnetConfig();
        networkConfigs[ETH_SEPOLIA_CHAIN_ID] = getSepoliaConfig();
        networkConfigs[ZKSYNC_MAINNET_CHAIN_ID] = getZkSyncConfig();
        networkConfigs[ZKSYNC_SEPOLIA_CHAIN_ID] = getZkSyncSepoliaConfig();
        networkConfigs[POLYGON_MAINNET_CHAIN_ID] = getPolygonMainnetConfig();
        networkConfigs[POLYGON_MUMBAI_CHAIN_ID] = getPolygonMumbaiConfig();
        networkConfigs[MODE_MAINNET_CHAIN_ID] = getModeMainnetConfig();
        networkConfigs[MODE_SEPOLIA_CHAIN_ID] = getModeSepoliaConfig();
        networkConfigs[OP_MAINNET_CHAIN_ID] = getOpMainnetConfig();
        networkConfigs[OP_SEPOLIA_CHAIN_ID] = getOpSepoliaConfig();
        networkConfigs[BASE_MAINNET_CHAIN_ID] = getBaseMainnetConfig();
        networkConfigs[BASE_SEPOLIA_CHAIN_ID] = getBaseSepoliaConfig();
    }

    function getConfigByChainId(uint256 chainId) public returns (NetworkConfig memory) {
        if (networkConfigs[chainId].initialOwner != address(0)) {
            return networkConfigs[chainId];
        } else {
            return getOrCreateAnvilEthConfig();
        }
    }

    function getActiveNetworkConfig() public returns (NetworkConfig memory) {
        return getConfigByChainId(block.chainid);
    }

    /*//////////////////////////////////////////////////////////////
                                CONFIGS
    //////////////////////////////////////////////////////////////*/
    function getEthMainnetConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({ initialOwner: address(1), initialGelatoAddress: address(2) });
    }

    function getSepoliaConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({
            initialOwner: address(0xfe63Ba8189215E5C975e73643b96066B6aD41A45),
            initialGelatoAddress: address(0x823F9f50f6A6E52CC4073Ff1493D4a8482D8Aba4)
        });
    }

    function getZkSyncConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({ initialOwner: address(1), initialGelatoAddress: address(2) });
    }

    function getZkSyncSepoliaConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({ initialOwner: address(1), initialGelatoAddress: address(2) });
    }

    function getPolygonMainnetConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({ initialOwner: address(1), initialGelatoAddress: address(2) });
    }

    function getPolygonMumbaiConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({ initialOwner: address(1), initialGelatoAddress: address(2) });
    }

    function getModeMainnetConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({ initialOwner: address(1), initialGelatoAddress: address(2) });
    }

    function getModeSepoliaConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({ initialOwner: address(1), initialGelatoAddress: address(2) });
    }

    function getOpMainnetConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({ initialOwner: address(1), initialGelatoAddress: address(2) });
    }

    function getOpSepoliaConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({ initialOwner: address(1), initialGelatoAddress: address(2) });
    }

    function getBaseMainnetConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({ initialOwner: address(1), initialGelatoAddress: address(2) });
    }

    function getBaseSepoliaConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({ initialOwner: address(1), initialGelatoAddress: address(2) });
    }

    /*//////////////////////////////////////////////////////////////
                              LOCAL CONFIG
    //////////////////////////////////////////////////////////////*/
    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (localNetworkConfig.initialOwner != address(0)) {
            return localNetworkConfig;
        }
        console2.log(unicode"⚠️ You have deployed a mock conract!");
        console2.log("Make sure this was intentional");

        _deployMocks();

        localNetworkConfig = NetworkConfig({ initialOwner: address(1), initialGelatoAddress: address(2) });
        return localNetworkConfig;
    }

    /*
     * Add mocks, deploy and return them here for local anvil network
     */
    function _deployMocks() internal { }
}
