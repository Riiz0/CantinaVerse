'use client';

import { useState, useEffect } from 'react';
import { useReadContract, useAccount, useChainId } from 'wagmi';
import { factoryNFTContractABI } from '../../ABIs/factoryNFTContractABI';
import Header from '@/components/nftmarketplace/homepage/marketplaceHeader';
import Link from 'next/link';
import { Footer } from '../../components/pagesFooter';
import Image from 'next/image';

type EthereumAddress = `0x${string}`;

interface Collection {
    address: string;
    name: string;
    symbol: string;
    maxSupply: bigint;
    owner: string;
    royaltyPercentage: bigint;
    mintPrice: bigint;
}

const contractAddresses: Record<number, EthereumAddress> = {
    5: '0xAEdF68cA921Fe00f09A9b358A613C60B76C88285',  // Sepolia Testnet
    84532: '0x346BffBd42D024D64455210Bd67Dd9d0dd9D0294', // Base Testnet
    11155420: '0xd19fD90fd1e0E0E4399D341DeaeFE18DE5565BFD', // OP Testnet
    // Add other network contract addresses here
};

type ABIOutput = {
    name: string;
    symbol: string;
    maxSupply: bigint;
    owner: string;
    royaltyPercentage: bigint;
    mintPrice: bigint;
    imageUrl: string;
};

const TEMPORARY_IMAGE_URL = '/path/to/your/temporary/image.png';

export default function Explore() {
    const [collections, setCollections] = useState<Collection[]>([]);
    const [searchTerm, setSearchTerm] = useState('');
    const [filteredCollections, setFilteredCollections] = useState<Collection[]>([]);
    const { address: connectedAddress } = useAccount();
    const chainId = useChainId();
    const FACTORY_CONTRACT_ADDRESS = contractAddresses[chainId as keyof typeof contractAddresses] as `0x${string}`;

    const { data: collectionAddresses } = useReadContract({
        address: FACTORY_CONTRACT_ADDRESS,
        abi: factoryNFTContractABI,
        functionName: 'getCollections',
    });

    const fetchTokenURI = async (collectionAddress: string) => {
        try {
            const result = await useReadContract({
                address: collectionAddress as `0x${string}`,
                abi: factoryNFTContractABI,
                functionName: 'tokenURI',
                args: [BigInt(0)],  // tokenId 0
            });

            if (typeof result === 'string') {
                const response = await fetch(result);
                const metadata = await response.json();
                return metadata.image;
            }
        } catch (error) {
            console.error(`Error fetching tokenURI for collection ${collectionAddress}:`, error);
        }
        return TEMPORARY_IMAGE_URL;
    };

    useEffect(() => {
        const fetchCollectionDetails = async () => {
            if (collectionAddresses && Array.isArray(collectionAddresses)) {
                const detailsPromises = collectionAddresses.map(async (address) => {
                    try {
                        const result = await useReadContract({
                            address: FACTORY_CONTRACT_ADDRESS,
                            abi: factoryNFTContractABI,
                            functionName: 'getCollectionDetails',
                            args: [address],
                        });

                        // Check if result is an array and has at least 6 elements
                        if (Array.isArray(result) && result.length >= 6) {
                            return {
                                address,
                                name: result[0] as ABIOutput['name'],
                                symbol: result[1] as ABIOutput['symbol'],
                                maxSupply: BigInt(result[2]) as bigint,
                                owner: result[3] as ABIOutput['owner'],
                                royaltyPercentage: BigInt(result[4]) as bigint,
                                mintPrice: BigInt(result[5]) as bigint,
                            };
                        }
                        throw new Error('Invalid result structure');
                    } catch (error) {
                        console.error(`Error fetching collection details for ${address}:`, error);
                        return null;
                    }
                });

                const fetchedCollections = (await Promise.all(detailsPromises)).filter((c): c is Collection => c !== null);
                setCollections(fetchedCollections);
                setFilteredCollections(fetchedCollections);
            }
        };

        fetchCollectionDetails();
    }, [collectionAddresses, FACTORY_CONTRACT_ADDRESS]);

    useEffect(() => {
        const filtered = collections.filter(
            (collection) =>
                collection.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                collection.symbol.toLowerCase().includes(searchTerm.toLowerCase()) ||
                collection.address.toLowerCase().includes(searchTerm.toLowerCase()) ||
                collection.owner.toLowerCase().includes(searchTerm.toLowerCase())
        );
        setFilteredCollections(filtered);
    }, [searchTerm, collections]);

    return (
        <main>
            <Header />
            <div className="exploreSection">
                <div className="exploreDiv">
                    <h1 className="exploreTitle">Explore NFT Collections</h1>
                    <div className="searchWrapper">
                        <input
                            type="text"
                            placeholder="Search by name, symbol, contract address, or owner"
                            value={searchTerm}
                            onChange={(e) => setSearchTerm(e.target.value)}
                            className="searchInput"
                        />
                        <button className="searchButton">Search</button>
                    </div>
                    {filteredCollections.length > 0 ? (
                        <div className="collectionsList">
                            {filteredCollections.map((collection) => (
                                <Link href={`/collection/${collection.address}`} key={collection.address}>
                                    <div className="collectionItem">
                                        <h2>{collection.name}</h2>
                                        <p>Symbol: {collection.symbol}</p>
                                        <p>Contract Address: {collection.address.slice(0, 6)}...{collection.address.slice(-4)}</p>
                                        <p>Owner: {collection.owner.slice(0, 6)}...{collection.owner.slice(-4)}</p>
                                        <p>Max Supply: {collection.maxSupply.toString()}</p>
                                        <p>Royalty: {collection.royaltyPercentage.toString()}%</p>
                                        <p>Mint Price: {collection.mintPrice.toString()} wei</p>
                                    </div>
                                </Link>
                            ))}
                        </div>
                    ) : (
                        <p className="noCollections">No collections found.</p>
                    )}
                </div>
            </div>
            <Footer />
        </main>
    );
}

