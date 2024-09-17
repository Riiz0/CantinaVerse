'use client';

import { useState, useEffect, useCallback } from 'react';
import { useReadContract, useAccount, useChainId } from 'wagmi';
import { factoryNFTContractABI } from '../../ABIs/factoryNFTContractABI';
import Link from 'next/link';
import Header from '@/components/nftmarketplace/homepage/marketplaceHeader';

type EthereumAddress = `0x${string}`;

const contractAddresses: Record<number, EthereumAddress> = {
    5: '0xAEdF68cA921Fe00f09A9b358A613C60B76C88285',  // Sepolia Testnet
    84532: '0xA999DC0749657e77AC3216d8fA6bE16874F8e50c', // Base Testnet
    11155420: '0xd19fD90fd1e0E0E4399D341DeaeFE18DE5565BFD', // OP Testnet
    // Add other network contract addresses here
};

const Explore = () => {
    const [collections, setCollections] = useState<EthereumAddress[]>([]);
    const [search, setSearch] = useState('');
    const [filteredCollections, setFilteredCollections] = useState<EthereumAddress[]>([]);
    const chainId = useChainId();
    const { address: userAddress } = useAccount();
    const FACTORY_CONTRACT_ADDRESS = contractAddresses[chainId as keyof typeof contractAddresses] as `0x${string}`;

    // Fetch NFT Collections
    const { data: nftCollections } = useReadContract({
        address: FACTORY_CONTRACT_ADDRESS,
        abi: factoryNFTContractABI,
        functionName: 'getCollections',
    });

    // Update collections state when fetched
    useEffect(() => {
        if (nftCollections) {
            setCollections(nftCollections as EthereumAddress[]);
            setFilteredCollections(nftCollections as EthereumAddress[]);
        }
    }, [nftCollections]);

    // Filter collections based on search input
    const handleSearch = useCallback(() => {
        if (search === '') {
            setFilteredCollections(collections);
            return;
        }

        const lowerSearch = search.toLowerCase();
        const filtered = collections.filter((collection) =>
            collection.toLowerCase() === lowerSearch ||
            userAddress?.toLowerCase() === lowerSearch
        );
        setFilteredCollections(filtered);
    }, [search, collections, userAddress]);

    return (
        <main>
            <Header />
            <section className="exploreSection">
                <div className="exploreDiv">
                    <h1 className="exploreTitle">Explore NFT Collections</h1>
                    <div className="searchWrapper">
                        <input
                            type="text"
                            placeholder="Search by collection address or user address"
                            value={search}
                            onChange={(e) => setSearch(e.target.value)}
                            className="searchInput"
                        />
                        <button onClick={handleSearch} className="searchButton" >Search</button>
                    </div>

                    <h2>Collections</h2>
                    <div className="collections-list">
                        {filteredCollections.length > 0 ? (
                            filteredCollections.map((collection, index) => (
                                <div key={index} className="collection-item">
                                </div>
                            ))
                        ) : (
                            <p>No collections found</p>
                        )}
                    </div>
                </div>
            </section>
        </main>
    );
};

export default Explore;
