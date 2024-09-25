import { useState, useEffect, useCallback } from 'react';
import { useReadContract, useChainId } from 'wagmi';
import { factoryNFTContractABI } from '../../ABIs/factoryNFTContractABI';
import Header from '@/components/nftmarketplace/homepage/marketplaceHeader';
import Link from 'next/link';
import { Footer } from '../../components/pagesFooter';
import { Button } from 'semantic-ui-react';

type EthereumAddress = `0x${string}`;

interface NFTCollection {
    collectionAddress: string;
    name: string;
    symbol: string;
    maxSupply: number;
    owner: string;
    royaltyPercentage: number;
    mintPrice: number;
    imageUrl: string;
    tempImageUrl: string;
}

const contractAddresses: Record<number, EthereumAddress> = {
    5: '0xAEdF68cA921Fe00f09A9b358A613C60B76C88285',  // Sepolia Testnet
    84532: '0x407A99d44aE3AB58075BB2efd8Af7d174AFAe8cA', // Base Testnet
    11155420: '0xf802c833FE8864EAF41c512D66B7C56f5B85d710', // OP Testnet
    // Add other network contract addresses here
};

const TEMPORARY_IMAGE_URL = 'https://silver-selective-kite-794.mypinata.cloud/ipfs/QmNQq33D3Y1LhftVkHbVJZziuFLQuNLvFmSExwtEcKXcJx';

interface CustomModalProps {
    isOpen: boolean;
    onClose: () => void;
    collection: NFTCollection | null;
}

const CustomModal: React.FC<CustomModalProps> = ({ isOpen, onClose, collection }) => {
    if (!isOpen || !collection) return null;

    return (
        <div className="modal-overlay" onClick={onClose}>
            <div className="modal-content" onClick={e => e.stopPropagation()}>
                <h2>{collection.name}</h2>
                <img src={collection.imageUrl || TEMPORARY_IMAGE_URL} alt={collection.name} className="modal-image" />
                <div className="modal-details">
                    <p><span>Symbol:</span> <span>{collection.symbol}</span></p>
                    <p><span>Contract:</span> <span>{collection.collectionAddress}</span></p>
                    <p><span>Owner:</span> <span>{collection.owner}</span></p>
                    <p><span>Max Supply:</span> <span>{collection.maxSupply.toString()}</span></p>
                    <p><span>Royalty:</span> <span>{collection.royaltyPercentage.toString()}%</span></p>
                    <p><span>Mint Price:</span> <span>{collection.mintPrice.toString()} ETH</span></p>
                </div>
                <div className="button-group">
                    <button className="mint-button" onClick={() => alert(`Minting ${collection.name}`)}>
                        Mint NFT
                    </button>
                    <button className="close-button" onClick={onClose}>Close</button>
                </div>
            </div>
        </div>
    );
};

export default function Explore() {
    const [collections, setCollections] = useState<NFTCollection[]>([]);
    const [selectedCollection, setSelectedCollection] = useState<NFTCollection | null>(null);
    const [filteredCollections, setFilteredCollections] = useState<NFTCollection[]>([]);
    const [searchTerm, setSearchTerm] = useState('');
    const chainId = useChainId();
    const FACTORY_CONTRACT_ADDRESS = contractAddresses[chainId as keyof typeof contractAddresses];

    // Fetch all collections from the contract
    const { data: collectionsData } = useReadContract({
        address: FACTORY_CONTRACT_ADDRESS,
        abi: factoryNFTContractABI,
        functionName: 'getAllCollections',
    }) as { data: NFTCollection[] | undefined };

    useEffect(() => {
        if (collectionsData) {
            const parsedCollections = collectionsData.map((collection: NFTCollection) => ({
                collectionAddress: collection.collectionAddress,
                name: collection.name,
                symbol: collection.symbol,
                maxSupply: Number(collection.maxSupply),
                owner: collection.owner,
                royaltyPercentage: Number(collection.royaltyPercentage),
                mintPrice: Number(collection.mintPrice),
                imageUrl: TEMPORARY_IMAGE_URL,
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
            (collection.collectionAddress && collection.collectionAddress.toLowerCase().includes(lowercasedTerm))
        );
        setFilteredCollections(filtered);
    }, [searchTerm, collections]);

    useEffect(() => {
        handleSearch();
    }, [searchTerm, collections, handleSearch]);

    const handleCollectionClick = (collection: NFTCollection) => {
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
                                <div key={`${collection.collectionAddress}-${index}`}
                                    className="card-explore"
                                    onClick={() => handleCollectionClick(collection)}>
                                    <figure className="card-banner">
                                        <img
                                            className="img-cover"
                                            width="600" height="600"
                                            loading="lazy"
                                            src={collection.imageUrl || TEMPORARY_IMAGE_URL}
                                            alt={collection.name}
                                        />
                                    </figure>
                                    <div className="card-content">
                                        <h2 className="h3 card-title margin-top">{collection.name}</h2>
                                        <div className="wrapper">
                                            <div className="wrapper-item gray-text-card-content">
                                                Symbol: <span className="white-text-user-wallet">{collection.symbol}</span>
                                            </div>
                                            <div className="wrapper-item price-line">
                                                <span className="white-text-user-wallet">{collection.mintPrice} ETH</span>
                                                <span className="white-text-user-wallet">{collection.royaltyPercentage}%</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            ))}
                        </div>
                    ) : (
                        <div className="noCollections">No collections found.</div>
                    )}
                </div>
            </div>
            <Footer />

            <CustomModal
                isOpen={!!selectedCollection}
                onClose={() => setSelectedCollection(null)}
                collection={selectedCollection}
            />
        </main>
    );
}