'use client';
import { IonIcon } from '@ionic/react';
import { closeCircleOutline, menuOutline, walletOutline } from 'ionicons/icons';
import Image from 'next/image';
import { useNavbarToggle } from './hook/UseNavbarToggle';
import { ConnectButton } from '@rainbow-me/rainbowkit';

export function Header() {
  useNavbarToggle();

    return (
      <header className="header" data-header>
      <div className="container">
  
        <div className="overlay" data-overlay></div>
        
        <a href="#" className="logo">
            <Image src="/assets/logo.svg" width={68} height={48} alt="NFTC Logo" />
        </a>
  
        <nav className="navbar" data-navbar>
  
          <div className="navbar-top">
            <p className="navbar-title">Menu</p>
  
            <button className="nav-close-btn" aria-label="Close Menu" data-nav-close-btn>
              <IonIcon  icon={closeCircleOutline}></IonIcon >
            </button>
          </div>
  
          <ul className="navbar-list">
  
            <li>
              <a href="#home" className="navbar-link" data-navlink>Home</a>
            </li>
  
            <li>
              <a href="#explore" className="navbar-link" data-navlink>Explore</a>
            </li>
  
            <li>
              <a href="#top-seller" className="navbar-link" data-navlink>Top Seller</a>
            </li>
  
            <li>
              <a href="#collection" className="navbar-link" data-navlink>Collection</a>
            </li>
  
            <li>
              <a href="#instruction" className="navbar-link" data-navlink>Instruction</a>
            </li>
  
            <li>
              <a href="#" className="navbar-link" data-navlink>Contact</a>
            </li>
          </ul>
        </nav>
  
        <button className="menu-open-btn" aria-label="Open Menu" data-nav-open-btn>
            <IonIcon icon={menuOutline}></IonIcon >
        </button>
  
        <ConnectButton />
          
      </div>
    </header>
  );
}