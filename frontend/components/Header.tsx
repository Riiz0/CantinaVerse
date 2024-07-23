'use client';

import { IoIosCloseCircleOutline } from "react-icons/io";
import { TiThMenuOutline } from "react-icons/ti";
import Image from 'next/image';
import { useNavbarToggle } from './UseNavbarToggle';
import { ConnectButton } from '@rainbow-me/rainbowkit';
import Link from 'next/link';

export default function Header() {
  useNavbarToggle();

    return (
      <header className="header" data-header>
      <div className="container">

        <div className="overlay" data-overlay></div>
        
        <Link href="/">
          <div className="logo">
            <Image src="/assets/CantinaVerse_Transparent.svg" width={68} height={48} alt="NFTC Logo" />
          </div>
        </Link>

        <nav className="navbar" data-navbar>

          <div className="navbar-top">
            <p className="navbar-title">Menu</p>

            <button className="nav-close-btn" aria-label="Close Menu" data-nav-close-btn>
              <IoIosCloseCircleOutline />
            </button>
          </div>

          <ul className="navbar-list">
            <li>
              <Link href="/"><div className="navbar-link" data-navlink>Home</div></Link>
            </li>

            <li>
              <Link href="/create"><div className="navbar-link" data-navlink>Create</div></Link>
            </li>
            
            <li>
              <Link href="/explore"><div className="navbar-link" data-navlink>Explore</div></Link>
            </li>

            <li>
              <Link href="/collections"><div className="navbar-link" data-navlink>Collections</div></Link>
              </li>
              
            <li>
              <Link href="/aboutus"><div className="navbar-link" data-navlink>About Us</div></Link>
            </li>

            <li>
              <Link href="/contact"><div className="navbar-link" data-navlink>Contact</div></Link>
            </li>
          </ul>
        </nav>
  
        <button className="menu-open-btn" aria-label="Open Menu" data-nav-open-btn>
          <TiThMenuOutline />
        </button>
  
        <ConnectButton />
          
      </div>
    </header>
  );
}