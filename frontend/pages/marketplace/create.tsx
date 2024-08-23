'use client';

import { useState, useRef, useEffect } from 'react';
import { useWriteContract, useReadContract, useWaitForTransactionReceipt, useAccount, useWatchContractEvent } from 'wagmi';
import { parseEther } from 'viem';
import { pinata } from "@/utils/config"
import { Footer } from '../../components/pagesFooter';
import Header from '@/components/nftmarketplace/homepage/marketplaceHeader';
import { factoryNFTContractABI } from '../../ABIs/factoryNFTContractABI';
import Link from 'next/link';

const FACTORY_CONTRACT_ADDRESS = '0x669517ea44DE33d9172C52e24Cb0a4889f588986';

export default function Create() {
  // Collection details
  const [name, setName] = useState('');
  const [symbol, setSymbol] = useState('');
  const [maxSupply, setMaxSupply] = useState('');
  const [royaltyPercentage, setRoyaltyPercentage] = useState('');
  const [mintPrice, setMintPrice] = useState('');
  const [contractFee, setContractFee] = useState<bigint | undefined>();
  const [contractBaseURI, setContractBaseURI] = useState('');
  const [collectionCreated, setCollectionCreated] = useState(false);
  const [currentStep, setCurrentStep] = useState(1);

  // Image and metadata
  const [file, setFile] = useState<File | null>(null);
  const [imageCid, setImageCid] = useState("");
  const [metadataCid, setMetadataCid] = useState("");
  const [imageUploading, setImageUploading] = useState(false);
  const inputFile = useRef<HTMLInputElement>(null);

  // Metadata fields
  const [description, setDescription] = useState('');
  const [attributes, setAttributes] = useState<{ trait_type: string; value: string }[]>([]);

  // New state for completed NFT view
  const [isNFTCreated, setIsNFTCreated] = useState(false);

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

  const baseURI = useReadContract({
    address: FACTORY_CONTRACT_ADDRESS,
    abi: factoryNFTContractABI,
    functionName: 'getBaseURI',
  });

  useWatchContractEvent({
    address: FACTORY_CONTRACT_ADDRESS,
    abi: factoryNFTContractABI,
    eventName: 'CollectionCreated',
    onLogs(logs) {
      console.log('New logs!', logs)
      setCollectionCreated(true);
      setCurrentStep(2);
    },
  })

  useEffect(() => {
    const fetchContractFee = async () => {
      const feeValue = fee.data as bigint;
      setContractFee(feeValue);
    };
    fetchContractFee();
  }, [fee]);

  useEffect(() => {
    const fetchBaseURI = async () => {
      const baseURIValue = baseURI.data as string;
      setContractBaseURI(baseURIValue);
    };
    fetchBaseURI();
  }, [baseURI]);

  useEffect(() => {
    if (isConfirmed) {
      setCollectionCreated(true);
      setCurrentStep(2);
    }
  }, [isConfirmed]);

  const handleCreateCollection = async () => {
    if (!name || !symbol || !maxSupply || !royaltyPercentage || !mintPrice) {
      alert('Please fill in all collection details.');
      return;
    }

    try {
      writeContract({
        address: FACTORY_CONTRACT_ADDRESS,
        abi: factoryNFTContractABI,
        functionName: 'createCollection',
        args: [
          name,
          symbol,
          BigInt(maxSupply),
          connectedAddress,
          BigInt(royaltyPercentage),
          parseEther(mintPrice),
        ],
        value: contractFee,
      });
    } catch (error) {
      const typedError = error as Error;
      console.error("Error creating collection:", typedError);
      alert(`Error creating collection: ${typedError.message}`);
    }
  };

  const uploadImage = async () => {
    if (!file) return;
    setImageUploading(true);
    try {
      const keyRequest = await fetch("/api/key", { method: "GET" });
      const keyData = await keyRequest.json();
      const upload = await pinata.upload
        .file(file)
        .key(keyData.JWT);

      setImageCid(`${upload.IpfsHash}`);
      setCurrentStep(3);
    } catch (e) {
      console.error(e);
      alert("Trouble uploading file");
    } finally {
      setImageUploading(false);
    }
  };

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files.length > 0) {
      const selectedFile = e.target.files[0];
      if (selectedFile.type.startsWith('')) {
        setFile(selectedFile);
      } else {
        alert('Please select an image file.');
        e.target.value = '';
      }
    }
  };

  const addAttribute = () => {
    setAttributes([...attributes, { trait_type: '', value: '' }]);
  };

  const updateAttribute = (index: number, field: 'trait_type' | 'value', value: string) => {
    const newAttributes = [...attributes];
    newAttributes[index][field] = value;
    setAttributes(newAttributes);
  };

  const uploadMetadata = async () => {
    try {
      const metadata = {
        name,
        description,
        image: `https://${process.env.NEXT_PUBLIC_GATEWAY_URL}/ipfs/${imageCid}`,
        attributes
      };
      const keyRequest = await fetch("/api/key", { method: "GET" });
      const keyData = await keyRequest.json();
      const upload = await pinata.upload
        .json(metadata)
        .key(keyData.JWT);
      setIsNFTCreated(true);
      setMetadataCid(upload.IpfsHash);
      return `${upload.IpfsHash}`;
    } catch (e) {
      console.error(e);
      alert("Trouble uploading metadata");
    }
  };

  const resetCreationProcess = () => {
    setName('');
    setSymbol('');
    setMaxSupply('');
    setRoyaltyPercentage('');
    setMintPrice('');
    setFile(null);
    setImageCid('');
    setMetadataCid('');
    setDescription('');
    setAttributes([]);
    setCurrentStep(1);
    setIsNFTCreated(false);
    setCollectionCreated(false);
  };

  if (isNFTCreated) {
    return (
      <main>
        <Header />
        <div className="create-container">
          <div className="create-container-form">
            <h1 className="create-title">NFT Created Successfully</h1>
            <div className="nft-display">
              <img
                src={`https://${process.env.NEXT_PUBLIC_GATEWAY_URL}/ipfs/${imageCid}`}
                alt="Created NFT"
                style={{ maxWidth: '300px', margin: '20px 0' }}
              />
              <div className="nft-info">
                <p><strong>Name:</strong> {name}</p>
                <p><strong>Description:</strong> {description}</p>
                <p><strong>Image CID:</strong> {imageCid}</p>
                <p><strong>Metadata CID:</strong> {metadataCid}</p>
              </div>
            </div>
            <div className="action-buttons">
              <button className="create-button" onClick={resetCreationProcess}>Create New Collection</button>
              <Link href="/explorer">
                <button className="create-button">Go to Explorer</button>
              </Link>
              <Link href="/mint">
                <button className="create-button">Go to Mint</button>
              </Link>
            </div>
          </div>
        </div>
        <Footer />
      </main>
    );
  }

  return (
    <main>
      <Header />
      <div className="create-container">
        <div className="create-container-form">
          <h1 className="create-title">Create NFT Collection</h1>

          {/* Progress Indicator */}
          <div className="progress-indicator">
            <span className={`step ${currentStep === 1 ? 'active' : ''}`}>Step 1: Fill Collection Details</span>
            <span className={`step ${currentStep === 2 ? 'active' : ''}`}>Step 2: Upload Image</span>
            <span className={`step ${currentStep === 3 ? 'active' : ''}`}>Step 3: Input Metadata</span>
          </div>

          {currentStep === 1 && (
            <div className="collection-setup-section">
              <input
                type="text"
                placeholder="Collection Name"
                value={name}
                onChange={(e) => setName(e.target.value)}
              />
              <input
                type="text"
                placeholder="Symbol"
                value={symbol}
                onChange={(e) => setSymbol(e.target.value)}
              />
              <input
                type="number"
                placeholder="Max Supply"
                value={maxSupply}
                onChange={(e) => setMaxSupply(e.target.value)}
              />
              <input
                type="number"
                placeholder="Royalty Percentage"
                value={royaltyPercentage}
                onChange={(e) => setRoyaltyPercentage(e.target.value)}
              />
              <input
                type="text"
                placeholder="Mint Price (in ETH)"
                value={mintPrice}
                onChange={(e) => setMintPrice(e.target.value)}
              />
              <button className="create-button" onClick={handleCreateCollection} disabled={isPending || isConfirming}>
                {isPending || isConfirming ? "Creating Collection..." : "Create Collection"}
              </button>
              {isConfirmed && <p>Collection created successfully!</p>}
              {error && <p>Error: {error.message}</p>}
            </div>
          )}

          {currentStep === 2 && (
            <div className="image-upload-section">
              <input
                type="file"
                accept="image/*"
                onChange={handleFileChange}
                ref={inputFile}
              />
              <button className="create-button" onClick={uploadImage} disabled={imageUploading || !file}>
                {imageUploading ? "Uploading..." : "Upload Image"}
              </button>
              {imageCid && (
                <img
                  src={`https://${process.env.NEXT_PUBLIC_GATEWAY_URL}/ipfs/${imageCid}`}
                  alt="Uploaded NFT"
                  style={{ maxWidth: '200px', marginTop: '10px' }}
                />
              )}
            </div>
          )}

          {currentStep === 3 && (
            <div className="metadata-section">
              <textarea
                placeholder="Description"
                value={description}
                onChange={(e) => setDescription(e.target.value)}
              />
              <div className="attributes-section">
                <h3>Attributes</h3>
                {attributes.map((attr, index) => (
                  <div key={index} className="attribute-input">
                    <input
                      type="text"
                      placeholder="Trait Type"
                      value={attr.trait_type}
                      onChange={(e) => updateAttribute(index, 'trait_type', e.target.value)}
                    />
                    <input
                      type="text"
                      placeholder="Value"
                      value={attr.value}
                      onChange={(e) => updateAttribute(index, 'value', e.target.value)}
                    />
                  </div>
                ))}
                <button className="create-button" onClick={addAttribute}>Add Attribute</button>
              </div>
              <button className="create-button" onClick={uploadMetadata}>Finalize NFT Creation</button>
            </div>
          )}
        </div>
      </div>
      <Footer />
    </main>
  );
}