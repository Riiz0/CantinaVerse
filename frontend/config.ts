require('dotenv').config()
import { getDefaultConfig } from '@rainbow-me/rainbowkit';
import { http } from 'wagmi'
import { optimism, mode, base, optimismSepolia, modeTestnet, baseSepolia } from 'wagmi/chains'

export const config = getDefaultConfig({
    appName: 'NFT Marketplace',
    projectId: '16956586d2d3a2a7372f4b57330c2896',
    chains: [optimism, mode, base, optimismSepolia, modeTestnet, baseSepolia],
    transports: {
        [optimism.id]: http(process.env.OPTIMISM_RPC_URL),
        [optimismSepolia.id]: http(process.env.OPTIMISM_SEPOLIA_RPC_URL),
        [mode.id]: http(process.env.MODE_RPC_URL),
        [modeTestnet.id]: http(process.env.MODE_TESTNET_RPC_URL),
        [base.id]: http(process.env.BASE_RPC_URL),
        [baseSepolia.id]: http(process.env.BASE_SEPOLIA_RPC_URL),
    },
});

