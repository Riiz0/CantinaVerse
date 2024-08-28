'use client';

import { useState, useRef, useEffect, useCallback } from 'react';
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

  /* eslint-disable */
  const [contractBaseURI, setContractBaseURI] = useState('');
  /* eslint-disable */
  const [collectionCreated, setCollectionCreated] = useState(false);
  const [currentStep, setCurrentStep] = useState(1);

  // Image and metadata
  const [file, setFile] = useState<File | null>(null);
  const [imageCid, setImageCid] = useState("");
  const [metadataCid, setMetadataCid] = useState("");
  const [imageUploading, setImageUploading] = useState(false);
  const [localImageUrl, setLocalImageUrl] = useState<string | null>(null);
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

  const handleCreateCollection = useCallback(async () => {
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
  }, [name, symbol, maxSupply, royaltyPercentage, mintPrice, contractFee, writeContract]); // Dependencies array

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
      if (selectedFile.type.startsWith('image/')) {
        setFile(selectedFile);
        // Generate a blob URL for the selected file and update the localImageUrl state
        const imageUrl = URL.createObjectURL(selectedFile);
        setLocalImageUrl(imageUrl);
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

  return (
    <main>
      <Header />
      <div className="formbold-main-wrapper">
        <div className="formbold-form-wrapper">
          <form>
            <div className="formbold-steps">
              <ul>
                <li className={`formbold-step-menu1 ${currentStep === 1 ? 'active' : ''}`}>
                  <span>1</span>
                  Collection Details
                </li>
                <li className={`formbold-step-menu2 ${currentStep === 2 ? 'active' : ''}`}>
                  <span>2</span>
                  Upload Image
                </li>
                <li className={`formbold-step-menu3 ${currentStep === 3 ? 'active' : ''}`}>
                  <span>3</span>
                  Metadata
                </li>
              </ul>
            </div>

            {currentStep === 1 && (
              <div className="formbold-form-step-1 active">
                <div className="formbold-input-flex">
                  <div>
                    <label htmlFor="name" className="formbold-form-label">Collection Name</label>
                    <input
                      type="text"
                      id="name"
                      placeholder="Collection Name"
                      className="formbold-form-input"
                      value={name}
                      onChange={(e) => setName(e.target.value)}
                    />
                  </div>
                  <div>
                    <label htmlFor="symbol" className="formbold-form-label">Symbol</label>
                    <input
                      type="text"
                      id="symbol"
                      placeholder="Symbol"
                      className="formbold-form-input"
                      value={symbol}
                      onChange={(e) => setSymbol(e.target.value)}
                    />
                  </div>
                </div>
                <div className="formbold-input-flex">
                  <div>
                    <label htmlFor="maxSupply" className="formbold-form-label">Max Supply</label>
                    <input
                      type="number"
                      id="maxSupply"
                      placeholder="Max Supply"
                      className="formbold-form-input"
                      value={maxSupply}
                      onChange={(e) => setMaxSupply(e.target.value)}
                    />
                  </div>
                  <div>
                    <label htmlFor="royaltyPercentage" className="formbold-form-label">Royalty Percentage</label>
                    <input
                      type="number"
                      id="royaltyPercentage"
                      placeholder="Royalty Percentage"
                      className="formbold-form-input"
                      value={royaltyPercentage}
                      onChange={(e) => setRoyaltyPercentage(e.target.value)}
                    />
                  </div>
                </div>
                <div>
                  <label htmlFor="mintPrice" className="formbold-form-label">Mint Price (in ETH)</label>
                  <input
                    type="text"
                    id="mintPrice"
                    placeholder="Mint Price (in ETH)"
                    className="formbold-form-input"
                    value={mintPrice}
                    onChange={(e) => setMintPrice(e.target.value)}
                  />
                </div>
              </div>
            )}

            {currentStep === 2 && (
              <div className="formbold-form-step-2 active">
                <div>
                  <label htmlFor="file" className="formbold-form-label">Upload Image</label>
                  <input
                    type="file"
                    id="file"
                    accept="image/*"
                    onChange={handleFileChange}
                    ref={inputFile}
                    className="formbold-form-input"
                  />
                </div>
                {/* Display local image preview if available */}
                {localImageUrl && (
                  <div className="formbold-image-preview">
                    <img src={localImageUrl} alt="Selected" />
                  </div>
                )}
                {/* Once imageCid is obtained, display the image from Pinata */}
                {imageCid && (
                  <div className="formbold-image-preview">
                    <img
                      src={`https://${process.env.NEXT_PUBLIC_GATEWAY_URL}/ipfs/${imageCid}`}
                      alt="Uploaded NFT"
                    />
                  </div>
                )}
              </div>
            )}

            {currentStep === 3 && (
              <div className="formbold-form-step-3 active">
                <div>
                  <label htmlFor="description" className="formbold-form-label">Description</label>
                  <textarea
                    id="description"
                    placeholder="Description"
                    className="formbold-form-input"
                    value={description}
                    onChange={(e) => setDescription(e.target.value)}
                  ></textarea>
                </div>
                <div className="formbold-attributes-section">
                  <h3 className="formbold-form-label">Attributes</h3>
                  {attributes.map((attr, index) => (
                    <div key={index} className="formbold-input-flex">
                      <input
                        type="text"
                        placeholder="Trait Type"
                        className="formbold-form-input"
                        value={attr.trait_type}
                        onChange={(e) => updateAttribute(index, 'trait_type', e.target.value)}
                      />
                      <input
                        type="text"
                        placeholder="Value"
                        className="formbold-form-input"
                        value={attr.value}
                        onChange={(e) => updateAttribute(index, 'value', e.target.value)}
                      />
                    </div>
                  ))}
                  <button type="button" className="formbold-btn" onClick={addAttribute}>Add Attribute</button>
                </div>
              </div>
            )}

            <div className="formbold-form-btn-wrapper">
              {currentStep > 1 && (
                <button type="button" className="formbold-back-btn" style={{ alignSelf: 'flex-start' }} onClick={() => setCurrentStep(currentStep - 1)}>
                  Back
                </button>
              )}
              {currentStep < 3 ? (
                <button type="button" className="formbold-btn" style={{ alignSelf: 'flex-end' }} onClick={() => setCurrentStep(currentStep + 1)}>
                  Next Step
                  <svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <g clipPath="url(#clip0_1675_1807)">
                      <path d="M10.7814 7.33312L7.20541 3.75712L8.14808 2.81445L13.3334 7.99979L8.14808 13.1851L7.20541 12.2425L10.7814 8.66645H2.66675V7.33312H10.7814Z" fill="white" />
                    </g>
                    <defs>
                      <clipPath id="clip0_1675_1807">
                        <rect width="16" height="16" fill="white" />
                      </clipPath>
                    </defs>
                  </svg>
                </button>
              ) : (
                <button type="button" className="formbold-btn" style={{ alignSelf: 'flex-end' }} onClick={handleCreateCollection} disabled={isPending || isConfirming}>
                  {isPending || isConfirming ? "Creating Collection..." : "Create Collection"}
                </button>
              )}
            </div>
          </form>

          {isNFTCreated && (
            <div className="formbold-form-confirm">
              <h2 className="formbold-form-label">NFT Created Successfully</h2>
              <div className="formbold-image-preview">
                <img
                  src={`https://${process.env.NEXT_PUBLIC_GATEWAY_URL}/ipfs/${imageCid}`}
                  alt="Created NFT"
                />
              </div>
              <div className="formbold-nft-info">
                <p><strong>Name:</strong> {name}</p>
                <p><strong>Description:</strong> {description}</p>
                <p><strong>Image CID:</strong> {imageCid}</p>
                <p><strong>Metadata CID:</strong> {metadataCid}</p>
              </div>
              <div className="formbold-form-btn-wrapper">
                <button className="formbold-btn" onClick={resetCreationProcess}>Create New Collection</button>
                <Link href="/explorer">
                  <button className="formbold-btn">Go to Explorer</button>
                </Link>
                <Link href="/mint">
                  <button className="formbold-btn">Go to Mint</button>
                </Link>
              </div>
            </div>
          )}
        </div>
      </div>
      <Footer />
    </main>
  );
}