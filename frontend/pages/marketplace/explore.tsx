'use client';

import { useState, useEffect } from 'react';
import { useReadContract, useAccount, useChainId } from 'wagmi';
import { factoryNFTContractABI } from '../../ABIs/factoryNFTContractABI';
import Header from '@/components/nftmarketplace/homepage/marketplaceHeader';
import Link from 'next/link';
import { Footer } from '../../components/pagesFooter';
import Image from 'next/image';
import { Button } from 'semantic-ui-react';
import { Dialog, DialogContent, DialogTitle, DialogDescription } from '@radix-ui/react-dialog';

type EthereumAddress = `0x${string}`;

interface Collection {
    address: string;
    name: string;
    symbol: string;
    maxSupply: bigint;
    owner: string;
    royaltyPercentage: bigint;
    mintPrice: bigint;
    imageUrl: string;
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
    const [selectedCollection, setSelectedCollection] = useState<Collection | null>(null);
    const [isMinting, setIsMinting] = useState(false);
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

    const handleCollectionClick = (collection: Collection) => {
        setSelectedCollection(collection);
    };

    const handleMint = async () => {
        if (!selectedCollection || !connectedAddress) return;

        setIsMinting(true);
        try {
            // Generate a unique token URI (you might want to implement a more sophisticated method)
            const tokenURI = `${selectedCollection.name}-${Date.now()}`;

            await writeContractAsync({
                address: selectedCollection.address as `0x${string}`,
                abi: nftContractABI,
                functionName: 'safeMint',
                args: [connectedAddress, tokenURI],
                value: selectedCollection.mintPrice
            });

            toast.success('NFT minted successfully!');
        } catch (error) {
            console.error('Minting error:', error);
            toast.error('Failed to mint NFT. Please try again.');
        } finally {
            setIsMinting(false);
        }
    };

    return (
        <main>
            <Header />
            <div className="exploreSection">
                <div className="exploreDiv">
                    <h1 className="collectionsTitle">Explore NFT Collections</h1>
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
                        <div className="grid-list">
                            {filteredCollections.map((collection) => (
                                <div key={collection.address} className="card" onClick={() => handleCollectionClick(collection)}>
                                    <figure className="card-banner">
                                        <Image
                                            src={collection.imageUrl || TEMPORARY_IMAGE_URL}
                                            alt={collection.name}
                                            width={300}
                                            height={300}
                                            className="img-cover"
                                        />
                                    </figure>
                                    <div className="card-content">
                                        <h2 className="card-title">{collection.name}</h2>
                                        <p>Symbol: {collection.symbol}</p>
                                    </div>
                                </div>
                            ))}
                        </div>
                    ) : (
                        <p className="noCollections">No collections found.</p>
                    )}
                </div>
            </div>
            <Footer />
            <Dialog open={!!selectedCollection} onOpenChange={() => setSelectedCollection(null)}>
                <DialogContent>
                    <DialogTitle>{selectedCollection?.name}</DialogTitle>
                    <DialogDescription>
                        <Image
                            src={selectedCollection?.imageUrl || TEMPORARY_IMAGE_URL}
                            alt={selectedCollection?.name || "Collection"}
                            width={300}
                            height={300}
                            className="img-cover"
                        />
                        <p>Symbol: {selectedCollection?.symbol}</p>
                        <p>Contract: {selectedCollection?.address}</p>
                        <p>Owner: {selectedCollection?.owner}</p>
                        <p>Max Supply: {selectedCollection?.maxSupply.toString()}</p>
                        <p>Royalty: {selectedCollection?.royaltyPercentage.toString()}%</p>
                        <p>Mint Price: {selectedCollection?.mintPrice.toString()} wei</p>
                        <div className="button-group">
                            <Button asChild>
                                <Link href={`/mint/${selectedCollection?.address}`}>Go to Mint Page</Link>
                            </Button>
                            <Button asChild>
                                <a href={`https://blockscout.com/address/${selectedCollection?.address}`} target="_blank" rel="noopener noreferrer">View on Blockscout</a>
                            </Button>
                        </div>
                    </DialogDescription>
                </DialogContent>
            </Dialog>
        </main>
    );
}

