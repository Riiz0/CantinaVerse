'use client';

import { useState, useEffect } from 'react';
import { useWriteContract, useReadContract, useWaitForTransactionReceipt, useAccount } from 'wagmi';
import { parseEther } from 'viem';
import { create } from 'ipfs-http-client';
import axios from 'axios';
import { NFTStorage } from 'nft.storage';
import { Footer } from '../../components/pagesFooter';
import Header from '@/components/nftmarketplace/homepage/marketplaceHeader';
import { factoryNFTContractABI } from '../../ABIs/factoryNFTContractABI';

const FACTORY_CONTRACT_ADDRESS = '0xD6aD186C394699F89C0064528a0299C79b62717e';

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
  const [contractFee, setContractFee] = useState<bigint | undefined>();

  const { writeContract, data: hash, error, isPending } = useWriteContract();
  const { address: connectedAddress } = useAccount();
  const { isLoading: isConfirming, isSuccess: isConfirmed } = useWaitForTransactionReceipt({
    hash,
  });

  const fee = useReadContract({
    address: FACTORY_CONTRACT_ADDRESS,
    abi: factoryNFTContractABI,
    functionName: 'getFee',
  });

  useEffect(() => {
    const fetchContractFee = async () => {
      const feeValue = fee.data as bigint;
      setContractFee(feeValue);
    };
    fetchContractFee();
  }, [fee]);

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

    if (!file || !connectedAddress || !contractFee) return;

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

        // Display a disclaimer for users when using the "No Pinning Service (Temporary Storage)" option
        alert("Important: Your content is temporarily stored on IPFS. To ensure long-term availability, please pin this content using a pinning service or your own IPFS node. Learn more about pinning at https://docs.ipfs.tech/concepts/persistence/.");
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
          connectedAddress,
          BigInt(royaltyPercentage),
          parseEther(mintPrice),
        ],
        value: contractFee,
      });
    } catch (error) {
      console.error("Error uploading to IPFS or pinning service:", error);
    }
  };

  return (
    <main>
      <Header />
      <div className="create-container">
        <div className="create-container-form">
          <h1 className="create-title">Create NFT Collection</h1>
          <form onSubmit={handleSubmit} className="create-form">
            <div className="form-group">
              <label htmlFor="name" className="form-label">Collection Name</label>
              <input type="text" id="name" value={name} onChange={(e) => setName(e.target.value)} className="form-input" />
            </div>
            <div className="form-group">
              <label htmlFor="symbol" className="form-label">Symbol</label>
              <input type="text" id="symbol" value={symbol} onChange={(e) => setSymbol(e.target.value)} className="form-input" />
            </div>
            <div className="form-group">
              <label htmlFor="maxSupply" className="form-label">Max Supply</label>
              <input type="number" id="maxSupply" value={maxSupply} onChange={(e) => setMaxSupply(e.target.value)} className="form-input" />
            </div>
            <div className="form-group">
              <label htmlFor="royaltyPercentage" className="form-label">Royalty Percentage</label>
              <input type="number" id="royaltyPercentage" value={royaltyPercentage} onChange={(e) => setRoyaltyPercentage(e.target.value)} className="form-input" />
            </div>
            <div className="form-group">
              <label htmlFor="mintPrice" className="form-label">Mint Price (ETH)</label>
              <input type="number" id="mintPrice" value={mintPrice} onChange={(e) => setMintPrice(e.target.value)} className="form-input" />
            </div>
            <div className="form-group">
              <label htmlFor="file" className="form-label">Upload Image</label>
              <input type="file" id="file" onChange={(e) => setFile(e.target.files?.[0] || null)} className="form-input" />
            </div>
            <div className="form-group">
              <label htmlFor="pinningService" className="form-label">Pinning Service</label>
              <select id="pinningService" value={pinningService} onChange={(e) => setPinningService(e.target.value as PinningService)} className="form-input">
                <option value="none">No Pinning Service (Temporary Storage)</option>
                <option value="pinata">Pinata</option>
                <option value="nftstorage">NFT.Storage</option>
              </select>
            </div>
            {pinningService !== 'none' && (
              <div className="form-group">
                <label htmlFor="pinningApiKey" className="form-label">{pinningService === 'pinata' ? 'Pinata' : 'NFT.Storage'} API Key</label>
                <input type="text" id="pinningApiKey" value={pinningApiKey} onChange={(e) => setPinningApiKey(e.target.value)} className="form-input" />
              </div>
            )}
            <button type="submit" className="submit-btn" disabled={isPending || isConfirming}>
              {isPending ? 'Preparing...' : isConfirming ? 'Confirming...' : 'Create Collection'}
            </button>
          </form>
          {error && <div className="error-message">Error: {error.message}</div>}
          {isConfirmed && (
            <div className="success-message">
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
        </div>
      </div>
      <Footer />
    </main>
  );
}