import { useState, useEffect, useCallback } from 'react';
import { useWriteContract, useWaitForTransactionReceipt, useReadContract, useAccount, useChainId } from 'wagmi';
import { factoryNFTContractABI } from '../../ABIs/factoryNFTContractABI';
import { nftContractABI } from '../../ABIs/nftContractABI';
import Header from '@/components/nftmarketplace/homepage/marketplaceHeader';
import Link from 'next/link';
import { Footer } from '../../components/pagesFooter';
import { Button } from 'semantic-ui-react';
import { Dialog, DialogContent, DialogTitle, DialogDescription } from '@radix-ui/react-dialog';
import { ToastContainer } from 'react-toastify';

type EthereumAddress = `0x${string}`;

interface NFTCollection {
    address: string;
    name: string;
    symbol: string;
    maxSupply: number;
    owner: string;
    royaltyPercentage: number;
    mintPrice: number;
}

const contractAddresses: Record<number, EthereumAddress> = {
    5: '0xAEdF68cA921Fe00f09A9b358A613C60B76C88285',  // Sepolia Testnet
    84532: '0x879772088438A0e181448A945D350Eb8A93B5449', // Base Testnet
    11155420: '0xd19fD90fd1e0E0E4399D341DeaeFE18DE5565BFD', // OP Testnet
    // Add other network contract addresses here
};

export default function Explore() {
    const [collections, setCollections] = useState([] as { address: string; name: string; owner: string; symbol: string; mintPrice: number; maxSupply: number; royaltyPercentage: number; imageUrl: string; tempImageUrl: string }[]);
    const [selectedCollection, setSelectedCollection] = useState<{ address: string; name: string; owner: string; symbol: string; mintPrice: number; maxSupply: number; royaltyPercentage: number; imageUrl: string; tempImageUrl: string } | null>(null);
    const [filteredCollections, setFilteredCollections] = useState<{ address: string; name: string; owner: string; symbol: string; mintPrice: number; maxSupply: number; royaltyPercentage: number; imageUrl: string; tempImageUrl: string }[]>([]);
    const [searchTerm, setSearchTerm] = useState('');
    const chainId = useChainId();
    const FACTORY_CONTRACT_ADDRESS = contractAddresses[chainId as keyof typeof contractAddresses];
    const TEMPORARY_IMAGE_URL = 'https://silver-selective-kite-794.mypinata.cloud/ipfs/QmNQq33D3Y1LhftVkHbVJZziuFLQuNLvFmSExwtEcKXcJx';

    // Fetch all collections from the contract
    const { data: collectionsData } = useReadContract({
        address: FACTORY_CONTRACT_ADDRESS,
        abi: factoryNFTContractABI,
        functionName: 'getAllCollections',
    }) as { data: NFTCollection[] | undefined };

    useEffect(() => {
        if (collectionsData) {
            const parsedCollections = collectionsData.map((collection: NFTCollection) => ({
                address: collection.address,
                name: collection.name,
                symbol: collection.symbol,
                maxSupply: Number(collection.maxSupply), // Convert BigInt to number if necessary
                owner: collection.owner,
                royaltyPercentage: Number(collection.royaltyPercentage),
                mintPrice: Number(collection.mintPrice),
                imageUrl: TEMPORARY_IMAGE_URL,  // You can add logic to handle the image URL
                tempImageUrl: TEMPORARY_IMAGE_URL,
            }));
            setCollections(parsedCollections);
        }
    }, [collectionsData]);

    const handleSearch = useCallback(() => {
        const lowercasedTerm = searchTerm.toLowerCase();
        const filtered = collections.filter((collection) =>
            (collection.name && collection.name.toLowerCase().includes(lowercasedTerm)) ||
            (collection.symbol && collection.symbol.toLowerCase().includes(lowercasedTerm)) ||
            (collection.owner && collection.owner.toLowerCase().includes(lowercasedTerm)) ||
            (collection.address && collection.address.toLowerCase().includes(lowercasedTerm))
        );
        setFilteredCollections(filtered);
    }, [searchTerm, collections]);

    useEffect(() => {
        handleSearch();
    }, [searchTerm, collections, handleSearch]);

    const handleCollectionClick = (collection: { address: string; name: string; owner: string; symbol: string; mintPrice: number; maxSupply: number; royaltyPercentage: number; imageUrl: string; tempImageUrl: string }) => {
        setSelectedCollection(collection);
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
                            {filteredCollections.map((collection, index) => (
                                <div key={`${collection.address}-${index}`} className="card" onClick={() => handleCollectionClick(collection)}>
                                    <figure className="card-banner">
                                        <img
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
                        <img
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
                            <Button>
                                <Link href={`/mint/${selectedCollection?.address}`}>
                                    Go to Mint Page
                                </Link>
                            </Button>
                            <Button>
                                <a href={`https://blockscout.com/address/${selectedCollection?.address}`} target="_blank" rel="noopener noreferrer">
                                    View on Blockscout
                                </a>
                            </Button>
                        </div>
                    </DialogDescription>
                </DialogContent>
            </Dialog>
            <ToastContainer />
        </main>
    );
}