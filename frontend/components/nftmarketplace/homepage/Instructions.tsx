'use client';

import { IoWalletOutline, IoGridOutline, IoFileTrayOutline, IoBagHandleOutline } from "react-icons/io5";

export function Instructions() {
  return (
    <section className="section instruction" id="instruction">
      <div className="container">

        <p className="section-subtitle">How It Works</p>

        <h2 className="h2 section-title">Buy, Sell, Create and Mint NFTs</h2>

        <ul className="grid-list">

          <li className="instruction-item">

            <div className="instruction-icon">
              <IoWalletOutline />
            </div>


            <h3 className="instruction-title">Buy NFTs</h3>

            <p className="instruction-text">
              Choose between Listings or Auctions to find the NFT you want to buy. Once you’ve found the NFT you want to buy, click on it and then click on the Buy or Bid button.
            </p>

          </li>

          <li className="instruction-item">

            <div className="instruction-icon">
              <IoGridOutline />
            </div>

            <h3 className="instruction-title">Sell NFTs</h3>

            <p className="instruction-text">
              List or Auction out your NFT for sale by clicking on the NFT you want to sell and then clicking on the List or Auction button.
            </p>


          </li>

          <li className="instruction-item">

            <div className="instruction-icon">
              <IoFileTrayOutline />
            </div>

            <h3 className="instruction-title">Create Collections</h3>

            <p className="instruction-text">
              Click the Create tab and set up your collection. Add name, symbol, a max supply, the owner of the collection, and a royalty percentage.
            </p>

          </li>

          <li className="instruction-item">

            <div className="instruction-icon">
              <IoBagHandleOutline />
            </div>

            <h3 className="instruction-title">Mint NFTs</h3>

            <p className="instruction-text">
              Click the Mint tab and select from any of the collections created in CantinaVerse to mint. Depending on the collection some may require a fee to mint.
            </p>
          </li>
        </ul>
      </div>
    </section>
  );
}