import { useState, useCallback } from 'react';
import { useReadContract, useWriteContract, useWaitForTransactionReceipt, useAccount } from 'wagmi';
import { nftContractABI } from '../../ABIs/nftContractABI';
import { Footer } from '../../components/pagesFooter';
import Header from '@/components/nftmarketplace/homepage/marketplaceHeader';

type EthereumAddress = `0x${string}`;

export default function MintNFT() {

    return (
        <main>
            <Header />
            <div>
                <h1>Mint Your First NFT</h1>
            </div>
            <Footer />
        </main>
    );
}
