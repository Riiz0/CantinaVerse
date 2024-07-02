'use client';
import { IonIcon } from '@ionic/react';
import { logoTwitter, paperPlaneOutline, globeOutline } from 'ionicons/icons';
import Image from 'next/image';

export function Footer() {
  return (
    <footer className="footer">
      <div className="container">

        <div className="footer-top">

          <div className="footer-brand">

            <a href="#" className="logo">
              <Image src="/assets/logo.svg" width="68" height="48" alt="NFTC Logo" />
            </a>

            <p className="footer-text">
            Explore, Create, and Trade Extraordinary NFTs on Cantina, the premier marketplace for digital art and collectibles. Your journey into the world of NFTs begins here.
            </p>

            <ul className="social-list">
              <li>
                <a href="#" className="social-link">
                  <IonIcon icon={logoTwitter}></IonIcon>
                  <IonIcon icon={logoTwitter}></IonIcon>
                </a>
              </li>

              <li>
                <a href="#" className="social-link">
                  <IonIcon icon={globeOutline}></IonIcon>
                  <IonIcon icon={globeOutline}></IonIcon>
                </a>
              </li>
            </ul>
          </div>

          <ul className="footer-list">

            <li>
              <p className="footer-list-title">Useful Links</p>
            </li>

            <li>
              <a href="#" className="footer-link">All NFTs</a>
            </li>

            <li>
              <a href="#" className="footer-link">How It Works</a>
            </li>

            <li>
              <a href="/create" className="footer-link">Create</a>
            </li>

            <li>
              <a href="/explore" className="footer-link">Explore</a>
            </li>

          </ul>

          <ul className="footer-list">

            <li>
              <p className="footer-list-title">Community</p>
            </li>

            <li>
              <a href="https://app.optimism.io/superchain/" className="footer-link">Superchain Docs</a>
            </li>

            <li>
              <a href="#" className="footer-link">Partners</a>
            </li>

            <li>
              <a href="#" className="footer-link">Privacy & Terms</a>
            </li>

            <li>
              <a href="#" className="footer-link">Whitepaper</a>
            </li>

          </ul>

          <div className="footer-list">
            <p className="footer-list-title">Subscribe Us</p>
            <form action="" className="newsletter-form">
              <input type="email" name="email" placeholder="info@yourmail.com" required className="newsletter-input" />
                <button type="submit" className="newsletter-btn" aria-label="Submit">
                  <IonIcon icon={paperPlaneOutline}></IonIcon>
                </button>
            </form>
          </div>
        </div>
        <div className="footer-bottom">
          <p className="copyright">
            &copy; 2023 <div className="copyright-link">Cantina</div>. All Rights Reserved
          </p>
        </div>

      </div>
    </footer>
  );
}