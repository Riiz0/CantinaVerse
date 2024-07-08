'use client';

import { useState } from 'react'
import { abi } from '../abi/FactoryNFTContractABI';
import { useWriteContract } from 'wagmi';
import Header from '@/components/Header';

export default function Create() {
    const [name, setName] = useState('')
    const [symbol, setSymbol] = useState('')
    const [baseURI, setBaseURI] = useState('')
    const [maxSupply, setMaxSupply] = useState('')
    const [owner, setOwner] = useState('')
    const [royaltyPercentage, setRoyaltyPercentage] = useState('')
    const [coverImage, setCoverImage] = useState<File | string>('');
    const [description, setDescription] = useState('')

    const { writeContract } = useWriteContract()

    const createCollection = async (event: React.FormEvent<HTMLFormElement>) => {
        event.preventDefault();
        try {
            const formattedOwner = owner.startsWith('0x') ? owner : `0x${owner}`;
            writeContract({
                abi,
                address: '0xdaE97900D4B184c5D2012dcdB658c008966466DD',
                functionName: 'createCollection',
                args: [
                    name,
                    symbol,
                    baseURI,
                    BigInt(parseInt(maxSupply)),
                    formattedOwner as any,
                    BigInt(parseInt(royaltyPercentage)),
                ],
            })
            console.log('NFT collection creation transaction sent.')
        } catch (error) {
            console.error('Error creating NFT collection:', error)
        }
    }

    return (
      <>
        <Header />
        <div className="create-container">
          <h1 className="create-title">Create NFT Collection</h1>
              <form className="create-form" onSubmit={createCollection}>
              <div className="create-form-row">
                <label htmlFor="coverImage">Cover Image:</label>
                <input
                  id="coverImage"
                  className="create-input"
                  type="file"
                  accept="image/*"
                  onChange={(e) => {
                      if (e.target.files && e.target.files[0]) {
                        setCoverImage(e.target.files[0]);
                      }
                    }}
                />
              </div>
              <div className="create-form-row">
                <label htmlFor="description">Description:</label>
                <textarea
                  id="description"
                  className="create-textarea"
                  placeholder="Enter description here..."
                  value={description}
                  onChange={(e) => setDescription(e.target.value)}
                ></textarea>
              </div>
            <div className="create-form-row">
              <label htmlFor="name">Name:</label>
              <input
                id="name"
                className="create-input"
                type="text"
                placeholder="Name"
                value={name}
                onChange={(e) => setName(e.target.value)}
              />
            </div>
            <div className="create-form-row">
              <label htmlFor="symbol">Symbol:</label>
              <input
                id="symbol"
                className="create-input"
                type="text"
                placeholder="Symbol"
                value={symbol}
                onChange={(e) => setSymbol(e.target.value)}
              />
            </div>
            <div className="create-form-row">
              <label htmlFor="baseURI">Base URI:</label>
              <input
                id="baseURI"
                className="create-input"
                type="text"
                placeholder="Base URI"
                value={baseURI}
                onChange={(e) => setBaseURI(e.target.value)}
              />
            </div>
            <div className="create-form-row">
              <label htmlFor="maxSupply">Max Supply:</label>
              <input
                id="maxSupply"
                className="create-input"
                type="number"
                placeholder="Max Supply"
                value={maxSupply}
                onChange={(e) => setMaxSupply(e.target.value)}
              />
              </div>
                <div className="create-form-row">
                <label htmlFor="owner">Owner:</label>
              <input
              className="create-input"
              type="text"
              placeholder="Owner"
              value={owner}
              onChange={(e) => setOwner(e.target.value)}
              />
              </div>
              <div className="create-form-row">
              <label htmlFor="royaltyPercentage">Royalty Percentage:</label>
              <input
              className="create-input"
              type="number"
              placeholder="Royalty Percentage"
              value={royaltyPercentage}
              onChange={(e) => setRoyaltyPercentage(e.target.value)}
              />
              </div>
                  <button className="create-button" type="submit">
                      Create NFT Collection
                  </button>
              </form>
          </div>
      </>
  )
}