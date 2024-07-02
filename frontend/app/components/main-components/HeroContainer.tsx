'use client';
import { IonIcon } from '@ionic/react';
import { rocketOutline, createOutline } from 'ionicons/icons';

export function HeroContainer() {
    return (
        <section className="hero" id="home">

        <div className="container">

          <p className="section-subtitle">Cantina</p>

          <h2 className="h1 hero-title">Discover, collect, and sell extraordinary NFTs</h2>

          <p className="hero-text">
            Explore on the world&apos;s best & largest NFT marketplace
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
            <stop offset="0%" stopColor="#F8F8F8" />
            <stop offset="100%" stopColor="#EFEFEF" />
            </linearGradient>
          <g id="Page-1" stroke="none" strokeWidth="1" fill="none" fillRule="evenodd">
            <polygon points="" fill="url(#linearGradient-1)">
              <animate id="graph-animation" xmlns="http://www.w3.org/2000/svg" dur="2s" repeatCount=""
                attributeName="points"
                values="0,464 0,464 111.6,464 282.5,464 457.4,464 613.4,464 762.3,464 912.3,464 1068.2,464 1191.2,464 1328.1,464 1440.1,464 1440.1,464 0,464; 0,464 0,367 111.6,323.3 282.5,373 457.4,423.8 613.4,464 762.3,464 912.3,464 1068.2,464 1191.2,464 1328.1,464 1440.1,464 1440.1,464 0,464; 0,464 0,367 111.6,263 282.5,336.6 457.4,363.5 613.4,414.4 762.3,464 912.3,464 1068.2,464 1191.2,464 1328.1,464 1440.1,464 1440.1,464 0,464; 0,464 0,367 111.6,263 282.5,282 457.4,323.3 613.4,340 762.3,425.6 912.3,464 1068.2,464 1191.2,464 1328.1,464 1440.1,464 1440.1,464 0,464; 0,464 0,367 111.6,263 282.5,282 457.4,263 613.4,290.4 762.3,368 912.3,446.4 1068.2,464 1191.2,464 1328.1,464 1440.1,464 1440.1,464 0,464; 0,464 0,367 111.6,263 282.5,282 457.4,263 613.4,216 762.3,329.6 912.3,420 1068.2,427.6 1191.2,464 1328.1,464 1440.1,464 1440.1,464 0,464; 0,464 0,367 111.6,263 282.5,282 457.4,263 613.4,216 762.3,272 912.3,402.4 1068.2,373 1191.2,412 1328.1,464 1440.1,464 1440.1,464 0,464; 0,464 0,367 111.6,263 282.5,282 457.4,263 613.4,216 762.3,272 912.3,376 1068.2,336.6 1191.2,334 1328.1,404 1440.1,464 1440.1,464 0,464; 0,464 0,367 111.6,263 282.5,282 457.4,263 613.4,216 762.3,272 912.3,376 1068.2,282 1191.2,282 1328.1,314 1440.1,372.8 1440.1,464 0,464; 0,464 0,367 111.6,263 282.5,282 457.4,263 613.4,216 762.3,272 912.3,376 1068.2,282 1191.2,204 1328.1,254 1440.1,236 1440.1,464 0,464; 0,464 0,367 111.6,263 282.5,282 457.4,263 613.4,216 762.3,272 912.3,376 1068.2,282 1191.2,204 1328.1,164 1440.1,144.79999999999998 1440.1,464 0,464; 0,464 0,367 111.6,263 282.5,282 457.4,263 613.4,216 762.3,272 912.3,376 1068.2,282 1191.2,204 1328.1,164 1440.1,8 1440.1,464 0,464;"
                fill="freeze"></animate>
            </polygon>
          </g>
        </svg>

      </section>
    );
  }