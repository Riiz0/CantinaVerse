'use client';
import { IonIcon } from '@ionic/react';
import { rocketOutline, createOutline } from 'ionicons/icons';

export function HeroContainer() {
    return (
        <section className="hero" id="home">

        <div className="container">

          <p className="section-subtitle">Cantina</p>

          <h2 className="h1 hero-title">Explore, Create, and Trade Extraordinary NFTs</h2>

          <p className="hero-text">
          Your gateway to buying, selling, and creating unique digital art on Optimism&apos;s Superchain.
          </p>

          <div className="btn-group">

            <button className="btn">
              <IonIcon icon={rocketOutline} aria-hidden="true"></IonIcon>

              <a href="/explore">Explore</a>
            </button>

            <button className="btn">
              <IonIcon icon={createOutline} aria-hidden="true"></IonIcon>

              <a href="/create">Create</a>
            </button>

          </div>

        </div>

        <svg className="hero-bg-bottom" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 465" version="1.1">
  <linearGradient id="gradient" x1="0%" y1="0%" x2="100%" y2="0%" gradientUnits="userSpaceOnUse">
    <stop offset="0%" stopColor="#00494D" />
    <stop offset="100%" stopColor="#006D77" /> 
  </linearGradient>
  <g id="Page-1" stroke="none" strokeWidth="1" fill="none" fillRule="evenodd">
    <polygon fill="url(#gradient)" points="0,464 1440,464 1440,0 0,0">
      <animate id="wave-animation" xmlns="http://www.w3.org/2000/svg" dur="10s" repeatCount="indefinite"
        attributeName="points"
        values="0,464 0,464 144,464 288,464 432,464 576,464 720,464 864,464 1008,464 1152,464 1296,464 1440,464 1440,464 0,464;
                0,464 0,400 144,300 288,200 432,100 576,50 720,100 864,150 1008,200 1152,250 1296,300 1440,350 1440,464 0,464;
                0,464 0,350 144,300 288,250 432,200 576,150 720,100 864,150 1008,200 1152,250 1296,300 1440,350 1440,464 0,464;
                0,464 0,300 144,250 288,200 432,150 576,100 720,50 864,100 1008,150 1152,200 1296,250 1440,300 1440,464 0,464;
                0,464 0,250 144,200 288,150 432,100 576,50 720,0 864,50 1008,100 1152,150 1296,200 1440,250 1440,464 0,464;
                0,464 0,200 144,150 288,100 432,50 576,0 720,50 864,100 1008,150 1152,200 1296,250 1440,300 1440,464 0,464;
                0,464 0,150 144,100 288,50 432,0 576,50 720,100 864,150 1008,200 1152,250 1296,300 1440,350 1440,464 0,464;
                0,464 0,100 144,50 288,0 432,50 576,100 720,150 864,200 1008,250 1152,300 1296,350 1440,400 1440,464 0,464;
                0,464 0,50 144,0 288,50 432,100 576,150 720,200 864,250 1008,300 1152,350 1296,400 1440,450 1440,464 0,464"
        fill="freeze"></animate>
    </polygon>
  </g>
</svg>

      </section>
    );
  }