'use client';
import { IonIcon } from '@ionic/react';
import { logoFacebook, logoTwitter, logoPinterest, logoDiscord, paperPlaneOutline } from 'ionicons/icons';
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
              Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quis non, fugit totam vel laboriosam vitae.
            </p>

            <ul className="social-list">

              <li>
                <a href="#" className="social-link">
                  <IonIcon icon={logoFacebook}></IonIcon>
                  <IonIcon icon={logoFacebook}></IonIcon>
                </a>
              </li>

              <li>
                <a href="#" className="social-link">
                  <IonIcon icon={logoTwitter}></IonIcon>
                  <IonIcon icon={logoTwitter}></IonIcon>
                </a>
              </li>

              <li>
                <a href="#" className="social-link">
                  <IonIcon icon={logoPinterest}></IonIcon>
                  <IonIcon icon={logoPinterest}></IonIcon>
                </a>
              </li>

              <li>
                <a href="#" className="social-link">
                  <IonIcon icon={logoDiscord}></IonIcon>
                  <IonIcon icon={logoDiscord}></IonIcon>
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
              <a href="#" className="footer-link">Create</a>
            </li>

            <li>
              <a href="#" className="footer-link">Explore</a>
            </li>

            <li>
              <a href="#" className="footer-link">Privacy & Terms</a>
            </li>

          </ul>

          <ul className="footer-list">

            <li>
              <p className="footer-list-title">Community</p>
            </li>

            <li>
              <a href="#" className="footer-link">Help Center</a>
            </li>

            <li>
              <a href="#" className="footer-link">Partners</a>
            </li>

            <li>
              <a href="#" className="footer-link">Suggestions</a>
            </li>

            <li>
              <a href="#" className="footer-link">Blog</a>
            </li>

            <li>
              <a href="#" className="footer-link">Newsletter</a>
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
            &copy; 2024 <a href="#" className="copyright-link">Riiz0</a>. All Rights Reserved
          </p>
        </div>

      </div>
    </footer>
  );
}