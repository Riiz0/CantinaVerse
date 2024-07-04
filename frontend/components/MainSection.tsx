'use client';

import { Explorer } from "./Explorer";
import { HeroContainer } from "./HeroContainer";
import { TopSeller } from "./TopSeller";
import { Collections } from './Collections';
import { Instructions } from './Instructions';
import { Footer } from './Footer';
import { TiArrowUpOutline } from "react-icons/ti";


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
          <TiArrowUpOutline />
          </a>
        </article>
      </main>
    );
  }