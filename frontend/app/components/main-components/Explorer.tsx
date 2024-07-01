'use client';
import { IonIcon } from '@ionic/react';
import Image from 'next/image';
import { arrowForwardOutline, bagAddOutline } from 'ionicons/icons';

export function Explorer() {
  return (
    <section className="section explore" id="explore">
      <div className="container">

        <p className="section-subtitle">Exclusive Assets</p>

        <div className="title-wrapper">
          <h2 className="h2 section-title">Explore</h2>

          <a href="#" className="btn-link">
            <span>Explore All</span>

            <IonIcon icon={arrowForwardOutline} aria-hidden="true"></IonIcon>
          </a>
        </div>

        <ul className="grid-list">

          <li>
            <div className="card explore-card">

              <figure className="card-banner">
                <a href="#">
                  <Image src="/assets/auction-1.jpg" width="600" height="600" loading="lazy"
                    alt="Walking On Air" className="img-cover" />
                </a>
              </figure>

              <h3 className="h3 card-title">
                <a href="#">Walking On Air</a>
              </h3>

              <span className="card-author">
                Owned By <a href="#" className="author-link">Richard</a>
              </span>

              <div className="wrapper">
                <data className="wrapper-item" value="1.5">1.5 ETH</data>

                <span className="wrapper-item">1 of 1</span>
              </div>

              <button className="btn">
                <IonIcon icon={bagAddOutline} aria-hidden="true"></IonIcon>

                <span>Place a Bid</span>
              </button>

            </div>
          </li>

          <li>
            <div className="card explore-card">

              <figure className="card-banner">
                <a href="#">
                  <Image src="/assets/auction-2.jpg" width="600" height="600" loading="lazy" alt="Domain Names"
                    className="img-cover" />
                </a>
              </figure>

              <h3 className="h3 card-title">
                <a href="#">Domain Names</a>
              </h3>

              <span className="card-author">
                Owned By <a href="#" className="author-link">John Deo</a>
              </span>

              <div className="wrapper">
                <data className="wrapper-item" value="2.7">2.7 ETH</data>

                <span className="wrapper-item">1 of 1</span>
              </div>

              <button className="btn">
                <IonIcon icon={bagAddOutline} aria-hidden="true"></IonIcon>

                <span>Place a Bid</span>
              </button>

            </div>
          </li>

          <li>
            <div className="card explore-card">

              <figure className="card-banner">
                <a href="#">
                  <Image src="/assets/auction-3.jpg" width="600" height="600" loading="lazy" alt="Trading Cards"
                    className="img-cover" />
                </a>
              </figure>

              <h3 className="h3 card-title">
                <a href="#">Trading Cards</a>
              </h3>

              <span className="card-author">
                Owned By <a href="#" className="author-link">Arham</a>
              </span>

              <div className="wrapper">
                <data className="wrapper-item" value="2.3">2.3 ETH</data>

                <span className="wrapper-item">1 of 1</span>
              </div>

              <button className="btn">
                <IonIcon icon={bagAddOutline} aria-hidden="true"></IonIcon>

                <span>Place a Bid</span>
              </button>

            </div>
          </li>
        </ul>
      </div>
    </section>
  );
}