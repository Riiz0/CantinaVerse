// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { Test, console2 } from "forge-std/Test.sol";
import { HelperConfig } from "../../script/HelperConfig.s.sol";

contract HelperConfigTest is Test {
    HelperConfig public helperConfig;

    function setUp() public {
        helperConfig = new HelperConfig();
    }

    function testGetAnvilConfig() public view {
        HelperConfig.NetworkConfig memory config = helperConfig.getAnvilConfig();
        assertEq(config.initialOwner, address(1));
        assertEq(config.GelatoDedicatedMsgSender, address(2));
        assertEq(config.serviceFee, 0);
    }

    function testGetEthMainnetConfig() public view {
        HelperConfig.NetworkConfig memory config = helperConfig.getEthMainnetConfig();
        assertEq(config.initialOwner, 0xfe63Ba8189215E5C975e73643b96066B6aD41A45);
        assertEq(config.GelatoDedicatedMsgSender, 0x823F9f50f6A6E52CC4073Ff1493D4a8482D8Aba4);
        assertEq(config.serviceFee, 0);
    }

    function testGetSepoliaConfig() public view {
        HelperConfig.NetworkConfig memory config = helperConfig.getSepoliaConfig();
        assertEq(config.initialOwner, 0xfe63Ba8189215E5C975e73643b96066B6aD41A45);
        assertEq(config.GelatoDedicatedMsgSender, 0x823F9f50f6A6E52CC4073Ff1493D4a8482D8Aba4);
        assertEq(config.serviceFee, 0);
    }

    function testGetModeMainnetConfig() public view {
        HelperConfig.NetworkConfig memory config = helperConfig.getModeMainnetConfig();
        assertEq(config.initialOwner, 0xfe63Ba8189215E5C975e73643b96066B6aD41A45);
        assertEq(config.GelatoDedicatedMsgSender, 0x823F9f50f6A6E52CC4073Ff1493D4a8482D8Aba4);
        assertEq(config.serviceFee, 0);
    }

    function testGetOpMainnetConfig() public view {
        HelperConfig.NetworkConfig memory config = helperConfig.getOpMainnetConfig();
        assertEq(config.initialOwner, 0xfe63Ba8189215E5C975e73643b96066B6aD41A45);
        assertEq(config.GelatoDedicatedMsgSender, 0x823F9f50f6A6E52CC4073Ff1493D4a8482D8Aba4);
        assertEq(config.serviceFee, 0);
    }

    function testGetBaseMainnetConfig() public view {
        HelperConfig.NetworkConfig memory config = helperConfig.getBaseMainnetConfig();
        assertEq(config.initialOwner, 0xfe63Ba8189215E5C975e73643b96066B6aD41A45);
        assertEq(config.GelatoDedicatedMsgSender, 0x823F9f50f6A6E52CC4073Ff1493D4a8482D8Aba4);
        assertEq(config.serviceFee, 0);
    }

    function testDeploymentScriptNetworkSelection() public {
        vm.chainId(31_337);
        HelperConfig.NetworkConfig memory config = helperConfig.getAnvilConfig();
        assertEq(config.initialOwner, address(1));

        vm.chainId(11_155_111);
        config = helperConfig.getSepoliaConfig();
        assertEq(config.initialOwner, 0xfe63Ba8189215E5C975e73643b96066B6aD41A45);

        vm.chainId(8453);
        config = helperConfig.getBaseMainnetConfig();
        assertEq(config.initialOwner, 0xfe63Ba8189215E5C975e73643b96066B6aD41A45);

        vm.chainId(10);
        config = helperConfig.getOpMainnetConfig();
        assertEq(config.initialOwner, 0xfe63Ba8189215E5C975e73643b96066B6aD41A45);

        vm.chainId(34_443);
        config = helperConfig.getModeMainnetConfig();
        assertEq(config.initialOwner, 0xfe63Ba8189215E5C975e73643b96066B6aD41A45);
    }

    function testUnsupportedNetwork() public {
        vm.chainId(1); // Ethereum mainnet, which is not explicitly supported in your deployment script
        vm.expectRevert("Unsupported network");
        this.simulateDeploymentScript();
    }

    function simulateDeploymentScript() public view {
        HelperConfig.NetworkConfig memory config;

        if (block.chainid == 31_337) {
            config = helperConfig.getAnvilConfig();
        } else if (block.chainid == 11_155_111) {
            config = helperConfig.getSepoliaConfig();
        } else if (block.chainid == 8453) {
            config = helperConfig.getBaseMainnetConfig();
        } else if (block.chainid == 10) {
            config = helperConfig.getOpMainnetConfig();
        } else if (block.chainid == 34_443) {
            config = helperConfig.getModeMainnetConfig();
        } else {
            revert("Unsupported network");
        }
    }
}
