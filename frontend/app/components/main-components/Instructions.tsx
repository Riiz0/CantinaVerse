'use client';
import { IonIcon } from '@ionic/react';
import { walletOutline, gridOutline, fileTrayOutline, bagHandleOutline } from 'ionicons/icons';

export function Instructions() {
    return (
      <section className="section instruction" id="instruction">
        <div className="container">

          <p className="section-subtitle">How It Works</p>

          <h2 className="h2 section-title">Create and sell your NFTs</h2>

          <ul className="grid-list">

            <li className="instruction-item">

              <div className="instruction-icon">
                <IonIcon icon={walletOutline}></IonIcon>
              </div>

              <h3 className="instruction-title">Set up your wallet</h3>

              <p className="instruction-text">
                Once you’ve set up your wallet of choice, connect it to OpenSea by clicking the NFT Marketplace in the
                top right corner.
                Learn about the wallets we support.
              </p>

            </li>

            <li className="instruction-item">

              <div className="instruction-icon">
                <IonIcon icon={gridOutline}></IonIcon>
              </div>

              <h3 className="instruction-title">Create your collection</h3>

              <p className="instruction-text">
                Click Create and set up your collection. Add social links, a description, profile & banner images, and
                set a secondary
                sales fee.
              </p>

            </li>

            <li className="instruction-item">

              <div className="instruction-icon">
                <IonIcon icon={fileTrayOutline}></IonIcon>
              </div>

              <h3 className="instruction-title">Add your NFTs</h3>

              <p className="instruction-text">
                Upload your work (image, video, audio, or 3D art), add a title and description, and customize your NFTs
                with properties,
                stats, and unlockable content.
              </p>

            </li>

            <li className="instruction-item">

              <div className="instruction-icon">
                <IonIcon icon={bagHandleOutline}></IonIcon>
              </div>

              <h3 className="instruction-title">List them for sale</h3>

              <p className="instruction-text">
                Choose between auctions, fixed-price listings, and declining-price listings. You choose how you want to
                sell your NFTs!
              </p>
            </li>
          </ul>
        </div>
    </section>
  );
}