'use client';
import { IonIcon } from '@ionic/react';
import { arrowForwardOutline } from 'ionicons/icons';
import Image from 'next/image';

export function Collections() {
    return (
      <section className="section collection" id="collection">
        <div className="container">

          <p className="section-subtitle">Most Popular</p>

          <div className="title-wrapper">
            <h2 className="h2 section-title">Popular Collections</h2>

            <a href="#" className="btn-link">
              <span>View All</span>

              <IonIcon icon={arrowForwardOutline} aria-hidden="true"></IonIcon>
            </a>
          </div>

          <ul className="grid-list">

            <li>
              <a href="#" className="card collection-card">

                <figure className="card-banner">
                  <Image src="/assets/author-banner-1.jpg" width="600" height="450" loading="lazy"
                    alt="Virtual Worlds" className="img-cover" />
                </figure>

                <figure className="card-avatar">
                  <Image src="/assets/avatar-1.jpg" width="64" height="64" loading="lazy" alt="card avatar" />
                </figure>

                <h3 className="h3 card-title">Virtual Worlds</h3>

                <span className="card-text">ERC-729</span>

              </a>
            </li>

            <li>
              <a href="#" className="card collection-card">

                <figure className="card-banner">
                  <Image src="/assets/author-banner-2.jpg" width="600" height="450" loading="lazy"
                    alt="Digital Arts" className="img-cover" />
                </figure>

                <figure className="card-avatar">
                  <Image src="/assets/avatar-2.jpg" width="64" height="64" loading="lazy" alt="card avatar" />
                </figure>

                <h3 className="h3 card-title">Digital Arts</h3>

                <span className="card-text">ERC-522</span>

              </a>
            </li>

            <li>
              <a href="#" className="card collection-card">

                <figure className="card-banner">
                  <Image src="/assets/author-banner-3.jpg" width="600" height="450" loading="lazy" alt="Sports"
                    className="img-cover" />
                </figure>

                <figure className="card-avatar">
                  <Image src="/assets/avatar-3.jpg" width="64" height="64" loading="lazy" alt="card avatar" />
                </figure>

                <h3 className="h3 card-title">Sports</h3>

                <span className="card-text">ERC-495</span>
              </a>
            </li>
          </ul>
      </div>
    </section>
  );
}