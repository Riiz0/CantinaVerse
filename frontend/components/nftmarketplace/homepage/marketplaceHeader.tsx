'use client';

import { IoIosCloseCircleOutline } from "react-icons/io";
import { TiThMenuOutline } from "react-icons/ti";
import Image from 'next/image';
import { useNavbarToggle } from '../../UseNavbarToggle';
import { ConnectButton } from '@rainbow-me/rainbowkit';
import Link from 'next/link';

export default function Header() {
  useNavbarToggle();

  return (
    <header className="header" data-header>
      <div className="container">

        <div className="overlay" data-overlay></div>
        <Link href="/">
          <div className="logo-wrapper">
            <div className="logo">
              <Image src="/assets/logo_title.svg" width={275} height={275} alt="NFTC Logo" />
            </div>
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
              <Link href="/marketplace"><div className="navbar-link" data-navlink>Home</div></Link>
            </li>
            <li>
              <Link href="/marketplace/explore"><div className="navbar-link" data-navlink>Explore</div></Link>
            </li>
            <li>
              <Link href="/marketplace/create"><div className="navbar-link" data-navlink>Create</div></Link>
            </li>

            <li>
              <Link href="/marketplace/mint"><div className="navbar-link" data-navlink>Mint</div></Link>
            </li>
            <li>
              <Link href="/marketplace/trade"><div className="navbar-link" data-navlink>Trade</div></Link>
            </li>

            <li>
              <Link href="/marketplace/auction"><div className="navbar-link" data-navlink>Auction</div></Link>
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
