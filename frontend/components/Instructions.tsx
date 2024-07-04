'use client';

import { IoWalletOutline, IoGridOutline, IoFileTrayOutline, IoBagHandleOutline } from "react-icons/io5";

export function Instructions() {
    return (
      <section className="section instruction" id="instruction">
        <div className="container">

          <p className="section-subtitle">How It Works</p>

          <h2 className="h2 section-title">Buy, Sell or Create your NFTs</h2>

          <ul className="grid-list">

            <li className="instruction-item">

              <div className="instruction-icon">
                <IoWalletOutline />
              </div>

              <h3 className="instruction-title">Set up your wallet</h3>

              <p className="instruction-text">
                Once you’ve set up your wallet of choice, connect it to Cantina by clicking Connect Wallet on the
                top right corner.
                Learn about the wallets we support.
              </p>

            </li>

            <li className="instruction-item">

              <div className="instruction-icon">
                <IoGridOutline />
              </div>

              <h3 className="instruction-title">Create your collection</h3>

              <p className="instruction-text">
                Click Create and set up your collection. Add name, symbol, a max supply, the owner of the collection, and a royalty percentage.
              </p>

            </li>

            <li className="instruction-item">

              <div className="instruction-icon">
                <IoFileTrayOutline />
              </div>

              <h3 className="instruction-title">List your NFTs</h3>

              <p className="instruction-text">
                List your NFT for sale by clicking on the NFT you want to sell and then clicking on the List button. If you want to adjust the listing price, simply delist the nft and relist it with a new price.
              </p>

            </li>

            <li className="instruction-item">

              <div className="instruction-icon">
                <IoBagHandleOutline />
              </div>

              <h3 className="instruction-title">Buy NFTs</h3>

              <p className="instruction-text">
                 Choose between Explore or Collections to find the NFT you want to buy. Once you’ve found the NFT you want to buy, click on it and then click on the Buy button.
              </p>
            </li>
          </ul>
        </div>
    </section>
  );
}