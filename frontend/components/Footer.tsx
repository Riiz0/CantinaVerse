'use client';

import { IoLogoTwitter } from "react-icons/io";
import { CgWebsite } from "react-icons/cg";
import { IoPaperPlaneOutline } from "react-icons/io5";
import Image from 'next/image';
import Link from 'next/link';

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
                  <IoLogoTwitter />
                  <IoLogoTwitter />
                </a>
              </li>

              <li>
                <a href="#" className="social-link">
                  <CgWebsite />
                  <CgWebsite />
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

            <Link href="/create">
            <li>
              <div className="footer-link">Create</div>
            </li>
            </Link>

            <Link href="/explore">
            <li>
              <div className="footer-link">Explore</div>
            </li>
            </Link>

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
                  <IoPaperPlaneOutline />
                </button>
            </form>
          </div>
        </div>
        <div className="footer-bottom">
          <div className="copyright">
            &copy; 2023 <div className="copyright-link">Cantina</div>. All Rights Reserved
          </div>
        </div>

      </div>
    </footer>
  );
}