'use client';

import { useState, useRef, useEffect, useCallback } from 'react';
import { useWriteContract, useReadContract, useWaitForTransactionReceipt, useAccount, useWatchContractEvent } from 'wagmi';
import { parseEther } from 'viem';
import { pinata } from "@/utils/config"
import { Footer } from '../../components/pagesFooter';
import Header from '@/components/nftmarketplace/homepage/marketplaceHeader';
import { factoryNFTContractABI } from '../../ABIs/factoryNFTContractABI';
import Link from 'next/link';

const FACTORY_CONTRACT_ADDRESS = '0xAEdF68cA921Fe00f09A9b358A613C60B76C88285';

export default function Create() {
  const [name, setName] = useState('');
  const [symbol, setSymbol] = useState('');
  const [maxSupply, setMaxSupply] = useState('');
  const [royaltyPercentage, setRoyaltyPercentage] = useState('');
  const [mintPrice, setMintPrice] = useState('');
  const [contractFee, setContractFee] = useState<bigint | undefined>();
  const [file, setFile] = useState<File | null>(null);
  const [description, setDescription] = useState('');
  const [attributes, setAttributes] = useState<{ trait_type: string; value: string }[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [isNFTCreated, setIsNFTCreated] = useState(false);
  const [localImageUrl, setLocalImageUrl] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  const [step, setStep] = useState(1);
  const [imageCid, setImageCid] = useState<string | null>(null);
  const [metadataCid, setMetadataCid] = useState<string | null>(null);

  const inputFile = useRef<HTMLInputElement>(null);

  const { address: connectedAddress } = useAccount();
  const { writeContract, data: hash, error: contractError, isPending } = useWriteContract();
  const { isLoading: isConfirming, isSuccess: isConfirmed } = useWaitForTransactionReceipt({
    hash,
  });

  const fee = useReadContract({
    address: FACTORY_CONTRACT_ADDRESS,
    abi: factoryNFTContractABI,
    functionName: 'getFee',
  });

  useWatchContractEvent({
    address: FACTORY_CONTRACT_ADDRESS,
    abi: factoryNFTContractABI,
    eventName: 'CollectionCreated',
    onLogs(logs) {
      console.log('New logs!', logs)
      setIsNFTCreated(true);
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
    if (contractError) {
      setError(`Contract interaction failed: ${contractError.message}`);
      setIsLoading(false);
    }
  }, [contractError]);

  useEffect(() => {
    if (isConfirmed) {
      setIsNFTCreated(true);
      setIsLoading(false);
    }
  }, [isConfirmed]);

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files.length > 0) {
      const selectedFile = e.target.files[0];
      if (selectedFile.type.startsWith('')) {
        setFile(selectedFile);
        const imageUrl = URL.createObjectURL(selectedFile);
        setLocalImageUrl(imageUrl);
      } else {
        setError('Please select an image file.');
        e.target.value = '';
      }
    }
  };

  const uploadImage = async () => {
    if (!file) {
      setError('Please select an image file.');
      return null;
    }
    setIsLoading(true);
    try {
      const keyRequest = await fetch("/api/key", { method: "GET" });
      const keyData = await keyRequest.json();
      const upload = await pinata.upload.file(file).key(keyData.JWT);
      setImageCid(upload.IpfsHash);
      return upload.IpfsHash;
    } catch (e) {
      console.error(e);
      setError("Trouble uploading file");
      return null;
    } finally {
      setIsLoading(false);
    }
  };

  const uploadMetadata = async () => {
    if (!imageCid || !description) {
      setError('Image must be uploaded first.');
      return null;
    }
    const metadata = {
      name: name,
      description,
      image: `https://silver-selective-kite-794.mypinata.cloud/ipfs/${imageCid}`,
      attributes: attributes.filter(attr => attr.trait_type && attr.value)
    };

    try {
      const keyRequest = await fetch("/api/key", { method: "GET" });
      const keyData = await keyRequest.json();
      const upload = await pinata.upload.json(metadata).key(keyData.JWT);
      setMetadataCid(upload.IpfsHash);
      return upload.IpfsHash;
    } catch (e) {
      console.error(e);
      setError("Trouble uploading metadata");
      return null;
    }
  };

  const handleCreateCollection = useCallback(async () => {
    if (!name || !symbol || !maxSupply || !royaltyPercentage || !mintPrice || !metadataCid) {
      setError('Please complete all previous steps before creating the collection.');
      return;
    }

    setIsLoading(true);
    setError(null);

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
          parseEther(mintPrice)
        ],
        value: contractFee,
      });
    } catch (error) {
      const typedError = error as Error;
      console.error("Error creating collection:", typedError);
      setError(`Error creating collection: ${typedError.message}`);
      setIsLoading(false);
    }
  }, [name, symbol, maxSupply, royaltyPercentage, mintPrice, metadataCid, contractFee, writeContract, connectedAddress]);

  const handleNext = async () => {
    if (step === 1 && (!name || !symbol || !maxSupply || !royaltyPercentage || !mintPrice)) {
      setError('Please fill in all collection details.');
      return;
    }
    if (step === 2 && !file) {
      setError('Please select an image file.');
      return;
    }
    if (step === 3 && (!description)) {
      setError('Please fill in the name and description.');
      return;
    }

    setError(null);

    if (step === 1) {
      // Move to step 2 without any async operation
      setStep(2);
    }
    if (step === 2) {
      const uploadedImageCid = await uploadImage();
      if (uploadedImageCid) {
        setStep(3);
      }
    } else if (step === 3) {
      const uploadedMetadataCid = await uploadMetadata();
      if (uploadedMetadataCid) {
        setStep(4);
      }
    }
    if (step === 4) {
      await handleCreateCollection();
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

  const resetCreationProcess = () => {
    setName('');
    setSymbol('');
    setMaxSupply('');
    setRoyaltyPercentage('');
    setMintPrice('');
    setFile(null);
    setDescription('');
    setAttributes([]);
    setStep(1); // Reset the step to 1
    setIsNFTCreated(false);
    setLocalImageUrl(null);
    setError(null);
    setIsLoading(false);
    setImageCid(null); // Reset image CID
    setMetadataCid(null); // Reset metadata CID
  };

  return (
    <main>
      <Header />
      <div className="formbold-main-wrapper">
        <div className="formbold-form-wrapper">
          <form onSubmit={(e) => e.preventDefault()}>
            <div className="formbold-steps">
              <ul>
                <li className={`formbold-step-menu1 ${step === 1 ? 'active' : ''}`}>
                  <span>1</span>
                  Upload Image
                </li>
                <li className={`formbold-step-menu2 ${step === 2 ? 'active' : ''}`}>
                  <span>2</span>
                  Add Metadata
                </li>
                <li className={`formbold-step-menu3 ${step === 3 ? 'active' : ''}`}>
                  <span>3</span>
                  Collection Details
                </li>
              </ul>
            </div>

            {/* Step 1: Upload Image */}
            {step === 1 && (
              <div className="formbold-form-step-1 active">
                <div className="formbold-input-flex">
                  <div>
                    <label htmlFor="name" className="formbold-form-label">Name</label>
                    <input
                      type="text"
                      id="name"
                      placeholder="Name"
                      className="formbold-form-input"
                      value={name}
                      onChange={(e) => setName(e.target.value)}
                      required
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
                      required
                    />
                  </div>
                  <div>
                    <label htmlFor="maxSupply" className="formbold-form-label">Max Supply</label>
                    <input
                      type="number"
                      id="maxSupply"
                      placeholder="Max Supply"
                      className="formbold-form-input"
                      value={maxSupply}
                      onChange={(e) => setMaxSupply(e.target.value)}
                      required
                    />
                  </div>
                </div>
                <div className="formbold-input-flex">
                  <div>
                    <label htmlFor="royaltyPercentage" className="formbold-form-label">Royalty Percentage</label>
                    <input
                      type="number"
                      id="royaltyPercentage"
                      placeholder="Royalty Percentage"
                      className="formbold-form-input"
                      value={royaltyPercentage}
                      onChange={(e) => setRoyaltyPercentage(e.target.value)}
                      required
                    />
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
                      required
                    />
                  </div>
                </div>
              </div>
            )}

            {/* Step 2: Add Metadata */}
            {step === 2 && (
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
                    required
                  />
                </div>
                {localImageUrl && (
                  <div className="formbold-image-preview">
                    <img src={localImageUrl} alt="Selected" />
                  </div>
                )}
              </div>
            )}

            {/* Step 3: Collection Details */}
            {step === 3 && (
              <div className="formbold-form-step-3 active">
                <div>
                  <label htmlFor="description" className="formbold-form-label">Description</label>
                  <textarea
                    id="description"
                    placeholder="Description"
                    className="formbold-form-input"
                    value={description}
                    onChange={(e) => setDescription(e.target.value)}
                    required
                  ></textarea>
                </div>
                <div className="formbold-attributes-section">
                  <h3 className="formbold-form-label">Attributes (Optional)</h3>
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

            {/* Navigation buttons */}
            <div className="formbold-form-btn-wrapper">
              {step > 1 && !isNFTCreated && (
                <button
                  type="button"
                  className="formbold-back-btn"
                  onClick={() => setStep(step - 1)}
                  disabled={isLoading || isPending || isConfirming}
                >
                  Back
                </button>
              )}
              {step < 4 && !isNFTCreated && (
                <button
                  type="button"
                  className="formbold-btn"
                  onClick={handleNext}
                  disabled={isLoading || isPending || isConfirming}
                >
                  Next
                </button>
              )}
              {step === 4 && !isNFTCreated && (
                <button
                  type="button"
                  className="formbold-btn"
                  onClick={handleCreateCollection}
                  disabled={isLoading || isPending || isConfirming}
                >
                  {isLoading || isPending || isConfirming ? 'Creating...' : 'Create Collection'}
                </button>
              )}
            </div>

            {/* Success message */}
            {isNFTCreated && (
              <div className="formbold-success-message">
                <h2>NFT Collection Created Successfully!</h2>
                <p>Your NFT collection has been created and is now live on the blockchain.</p>
                <Link href="/marketplace" className="formbold-btn">
                  Go to Marketplace
                </Link>
                <button type="button" className="formbold-btn" onClick={resetCreationProcess}>
                  Create Another Collection
                </button>
              </div>
            )}

            {/* Error message */}
            {error && <p className="error-message">{error}</p>}
          </form>
        </div>
      </div>
      <Footer />
    </main>
  );
}