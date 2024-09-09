'use client';
import { IoLogoTwitter } from "react-icons/io";
import { CgWebsite } from "react-icons/cg";
import { IoPaperPlaneOutline } from "react-icons/io5";
import Image from 'next/image';
import Link from 'next/link';

export function Footer() {
  return (
    <footer className="homepage-footer">
      <div className="container">

        <div className="footer-top">

          <div className="footer-brand">

            <a href="#" className="logo">
              <Image src="/assets/logo.svg" width="68" height="48" alt="NFTC Logo" />
            </a>

            <p className="footer-text">
              Our mission is to empower creators, gamers, and investors with unparalleled opportunities for expression, engagement, and financial empowerment.
            </p>

            <ul className="social-list">
              <li>
                <a href="#" className="social-link">
                  <IoLogoTwitter />
                </a>
              </li>

              <li>
                <a href="#" className="social-link">
                  <CgWebsite />
                </a>
              </li>
            </ul>
          </div>

          <ul className="footer-list">
            <li>
              <p className="footer-list-title">Ecosystem</p>
            </li>

            <Link href="/marketplace">
              <li>
                <div className="footer-link">Marketplace</div>
              </li>
            </Link>

            <Link href="/tokencreation">
              <li>
                <div className="footer-link">Token Creation</div>
              </li>
            </Link>

            <Link href="/casinogames">
              <li>
                <div className="footer-link">Gaming</div>
              </li>
            </Link>

            <Link href="/governance">
              <li>
                <div className="footer-link">DAO</div>
              </li>
            </Link>
          </ul>

          <ul className="footer-list">
            <li>
              <p className="footer-list-title">Community</p>
            </li>

            <li>
              <a href="https://app.optimism.io/superchain/" className="footer-link">Superchain</a>
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
            <p className="footer-list-title">Subscribe To Us</p>
            <form action="" className="newsletter-form">
              <input type="email" name="email" required className="newsletter-input" />
              <button type="submit" className="newsletter-btn" aria-label="Submit">
                <IoPaperPlaneOutline />
              </button>
            </form>
          </div>
        </div>
        <div className="footer-bottom">
          <div className="copyright">
            &copy; 2024 <div className="copyright-link">CantinaVerse</div>. All Rights Reserved
          </div>
        </div>
      </div>
    </footer>
  );
}