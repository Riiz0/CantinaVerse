import { useState } from 'react'
import { abi } from '../abi/FactoryNFTContractABI';
import { useWriteContract } from 'wagmi'

export default function Create() {
    const [name, setName] = useState('')
    const [symbol, setSymbol] = useState('')
    const [baseURI, setBaseURI] = useState('')
    const [maxSupply, setMaxSupply] = useState('')
    const [owner, setOwner] = useState('')
    const [royaltyPercentage, setRoyaltyPercentage] = useState('')
  
    const { writeContract } = useWriteContract()
  
    const createCollection = async () => {
        try {
            const formattedOwner = owner.startsWith('0x') ? owner : `0x${owner}`;
            await writeContract({
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
            <div>
                <input
                    type="text"
                    placeholder="Name"
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
                    type="text"
                    placeholder="Base URI"
                    value={baseURI}
                    onChange={(e) => setBaseURI(e.target.value)}
                />
                <input
                    type="number"
                    placeholder="Max Supply"
                    value={maxSupply}
                    onChange={(e) => setMaxSupply(e.target.value)}
                />
                <input
                    type="text"
                    placeholder="Owner"
                    value={owner}
                    onChange={(e) => setOwner(e.target.value)}
                />
                <input
                    type="number"
                    placeholder="Royalty Percentage"
                    value={royaltyPercentage}
                    onChange={(e) => setRoyaltyPercentage(e.target.value)}
                />
                <button onClick={createCollection}>Create NFT Collection</button>
            </div>
    )
}