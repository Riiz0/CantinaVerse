'use client';
import { Explorer } from "./main-components/Explorer";
import { HeroContainer } from "./main-components/HeroContainer";
import { TopSeller } from "./main-components/TopSeller";
import { Collections } from './main-components/Collections';
import { Instructions } from './main-components/Instructions';
import { Footer } from './main-components/Footer';
import { IonIcon } from '@ionic/react';
import { arrowUpOutline } from 'ionicons/icons';

export default function MainSection() {
    return (
      <main>
        <article>
          <HeroContainer />
          <Explorer />
          <TopSeller />
          <Collections />
          <Instructions />
          <Footer />

          <a href="#top" className="back-to-top" aria-label="Back to Top" data-back-top-btn>
            <IonIcon icon={arrowUpOutline}></IonIcon>
          </a>
        </article>
      </main>
    );
  }