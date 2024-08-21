'use client';

import { useState, useRef, useEffect } from 'react';
import { useWriteContract, useReadContract, useWaitForTransactionReceipt, useAccount } from 'wagmi';
import { parseEther } from 'viem';
import { pinata } from "@/utils/config"
import { Footer } from '../../components/pagesFooter';
import Header from '@/components/nftmarketplace/homepage/marketplaceHeader';
import { factoryNFTContractABI } from '../../ABIs/factoryNFTContractABI';

const FACTORY_CONTRACT_ADDRESS = '0xD6aD186C394699F89C0064528a0299C79b62717e';

export default function Create() {
  const [name, setName] = useState('');
  const [symbol, setSymbol] = useState('');
  const [maxSupply, setMaxSupply] = useState('');
  const [royaltyPercentage, setRoyaltyPercentage] = useState('');
  const [mintPrice, setMintPrice] = useState('');
  const [contractFee, setContractFee] = useState<bigint | undefined>();

  const [file, setFile]: any = useState();
  const [cid, setCid] = useState("");
  const [uploading, setUploading] = useState(false);
  const inputFile = useRef(null);

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

  const uploadImageFolder = async () => {
    try {
      setUploading(true);
      const keyRequest = await fetch("/api/key", {
        method: "GET",
      });
      const keyData = await keyRequest.json();
      const upload = await pinata.upload
        .file(file)
        .key(keyData.JWT)
      setCid(upload.IpfsHash);
      setUploading(false);
    } catch (e) {
      console.log(e);
      setUploading(false);
      alert("Trouble uploading file");
    }
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files.length > 0) {
      setFile(e.target.files[0]);
    }
  };

  const uploadMetadataFolder = async () => {
    await uploadImageFolder();

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
  };

  return (
    <main>
      <Header />
      <div className="create-container">
        <div className="create-container-form">
          <h1 className="create-title">Create NFT Collection</h1>
          <div className="w-full min-h-screen m-auto flex flex-col justify-center items-center">
            <input type="file" id="file" ref={inputFile} onChange={handleChange} />
            <button disabled={uploading} onClick={uploadImageFolder}>
              {uploading ? "Uploading..." : "Upload"}
            </button>
            {cid && (
              <img
                src={`https://${process.env.NEXT_PUBLIC_GATEWAY_URL}/ipfs/${cid}`}
                alt="Image from IPFS"
              />
            )}
          </div>
        </div>
      </div>
      <Footer />
    </main>
  );
}