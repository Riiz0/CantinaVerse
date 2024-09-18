'use client';

import { IoRocketOutline, IoCreateOutline } from "react-icons/io5";
import Link from 'next/link';

export function HeroContainer() {
  return (
    <section className="hero" id="home">
      <video autoPlay loop muted playsInline className="hero-video">
        <source src="/assets/Test4.mp4" type="video/mp4" />
      </video>
      <div className="container text-content">
        <p className="section-subtitle">Marketplace</p>
        <h2 className="h1 hero-title">Explore, Create, and Trade Extraordinary NFTs</h2>
        <p className="hero-text">
          Your gateway to buying, selling, and creating unique digital art on Optimism&apos;s Superchain.
        </p>
        <div className="btn-group">
          <button className="btn">
            <IoRocketOutline aria-hidden="true" />
            <Link href="/marketplace/explore">Explore</Link>
          </button>
          <button className="btn">
            <IoCreateOutline aria-hidden="true" />
            <Link href="/marketplace/create">Create</Link>
          </button>
        </div>
      </div>
    </section>
  );
}

