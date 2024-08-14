'use client';

import { useState } from 'react';
import { useWriteContract, useWaitForTransactionReceipt } from 'wagmi';
import { parseEther } from 'viem';
import { create } from 'ipfs-http-client';
import axios from 'axios';
import { NFTStorage } from 'nft.storage';
import { Footer } from '@/components/Footer';
import Header from '@/components/nftmarketplace/homepage/marketplaceHeader';
import { factoryNFTContractABI } from './factoryNFTContractABI';

const FACTORY_CONTRACT_ADDRESS = '0x...'; // Your deployed FactoryNFTContract address

// IPFS client setup
const ipfs = create({ host: 'ipfs.infura.io', port: 5001, protocol: 'https' });

type PinningService = 'none' | 'pinata' | 'nftstorage';

export default function Create() {
  const [name, setName] = useState('');
  const [symbol, setSymbol] = useState('');
  const [maxSupply, setMaxSupply] = useState('');
  const [royaltyPercentage, setRoyaltyPercentage] = useState('');
  const [mintPrice, setMintPrice] = useState('');
  const [file, setFile] = useState<File | null>(null);
  const [ipfsHash, setIpfsHash] = useState('');
  const [pinningService, setPinningService] = useState<PinningService>('none');
  const [pinningApiKey, setPinningApiKey] = useState('');

  const { writeContract, data: hash, error, isPending } = useWriteContract();

  const { isLoading: isConfirming, isSuccess: isConfirmed } = useWaitForTransactionReceipt({
    hash,
  });

  const uploadToPinata = async (file: File, metadata: any) => {
    const formData = new FormData();
    formData.append('file', file);

    const fileRes = await axios.post("https://api.pinata.cloud/pinning/pinFileToIPFS", formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
        'pinata_api_key': pinningApiKey,
        'pinata_secret_api_key': pinningApiKey,
      }
    });

    const metadataRes = await axios.post("https://api.pinata.cloud/pinning/pinJSONToIPFS", {
      ...metadata,
      image: `ipfs://${fileRes.data.IpfsHash}`
    }, {
      headers: {
        'Content-Type': 'application/json',
        'pinata_api_key': pinningApiKey,
        'pinata_secret_api_key': pinningApiKey,
      }
    });

    return `ipfs://${metadataRes.data.IpfsHash}`;
  };

  const uploadToNFTStorage = async (file: File, metadata: any) => {
    const client = new NFTStorage({ token: pinningApiKey });
    const result = await client.store({
      ...metadata,
      image: file,
    });
    return result.url;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!file) return;

    try {
      let baseURI;

      if (pinningService === 'none') {
        // Upload file to IPFS without pinning
        const fileAdded = await ipfs.add(file);
        const imageURI = `https://ipfs.io/ipfs/${fileAdded.path}`;

        // Create and upload metadata
        const metadata = JSON.stringify({
          name,
          description: `${name} collection`,
          image: imageURI,
        });
        const metadataAdded = await ipfs.add(metadata);
        baseURI = `https://ipfs.io/ipfs/${metadataAdded.path}`;
        setIpfsHash(metadataAdded.path);
      } else if (pinningService === 'pinata') {
        baseURI = await uploadToPinata(file, { name, description: `${name} collection` });
      } else if (pinningService === 'nftstorage') {
        baseURI = await uploadToNFTStorage(file, { name, description: `${name} collection` });
      }

      // Call the contract function
      writeContract({
        address: FACTORY_CONTRACT_ADDRESS,
        abi: factoryNFTContractABI,
        functionName: 'createCollection',
        args: [
          name,
          symbol,
          baseURI,
          BigInt(maxSupply),
          '0x...', // owner address (you might want to get this from the connected wallet)
          BigInt(royaltyPercentage),
          parseEther(mintPrice),
        ],
        value: parseEther('0.1'), // Assuming a 0.1 ETH fee, adjust as needed
      });
    } catch (error) {
      console.error("Error uploading to IPFS or pinning service:", error);
    }
  };

  return (
    <main>
      <Header />
      <form onSubmit={handleSubmit}>
        <input type="text" value={name} onChange={(e) => setName(e.target.value)} placeholder="Collection Name" />
        <input type="text" value={symbol} onChange={(e) => setSymbol(e.target.value)} placeholder="Symbol" />
        <input type="number" value={maxSupply} onChange={(e) => setMaxSupply(e.target.value)} placeholder="Max Supply" />
        <input type="number" value={royaltyPercentage} onChange={(e) => setRoyaltyPercentage(e.target.value)} placeholder="Royalty Percentage" />
        <input type="number" value={mintPrice} onChange={(e) => setMintPrice(e.target.value)} placeholder="Mint Price (ETH)" />
        <input type="file" onChange={(e) => setFile(e.target.files?.[0] || null)} />

        <select value={pinningService} onChange={(e) => setPinningService(e.target.value as PinningService)}>
          <option value="none">No Pinning Service (Temporary Storage)</option>
          <option value="pinata">Pinata</option>
          <option value="nftstorage">NFT.Storage</option>
        </select>

        {pinningService !== 'none' && (
          <input
            type="text"
            value={pinningApiKey}
            onChange={(e) => setPinningApiKey(e.target.value)}
            placeholder={`${pinningService === 'pinata' ? 'Pinata' : 'NFT.Storage'} API Key`}
          />
        )}

        <button type="submit" disabled={isPending || isConfirming}>
          {isPending ? 'Preparing...' : isConfirming ? 'Confirming...' : 'Create Collection'}
        </button>
      </form>
      {error && <div>Error: {error.message}</div>}
      {isConfirmed && (
        <div>
          <p>Collection created successfully!</p>
          {pinningService === 'none' && (
            <>
              <p>IPFS Hash: {ipfsHash}</p>
              <p>
                Important: Your content is temporarily stored on IPFS. To ensure long-term availability,
                please pin this content using a pinning service or your own IPFS node.
                Learn more about pinning <a href="https://docs.ipfs.tech/concepts/persistence/" target="_blank" rel="noopener noreferrer">here</a>.
              </p>
            </>
          )}
          {pinningService !== 'none' && (
            <p>Your content has been pinned using {pinningService === 'pinata' ? 'Pinata' : 'NFT.Storage'}.</p>
          )}
        </div>
      )}
      <Footer />
    </main>
  );
}