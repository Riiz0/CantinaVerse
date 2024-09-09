'use client';

import { Explorer } from "./Explorer";
import { HeroContainer } from "./HeroContainer";
import { RecentListings } from "./RecentListings";
import { RecentAuctions } from './RecentAuctions';
import { Instructions } from './Instructions';
import { Footer } from '../../pagesFooter';
import { TiArrowUpOutline } from "react-icons/ti";


export default function MainSection() {
    return (
      <main>
        <article>
          <HeroContainer />
          <Explorer />
          <RecentListings />
          <RecentAuctions />
          <Instructions />
          <Footer />
          <a href="#top" className="back-to-top" aria-label="Back to Top" data-back-top-btn>
          <TiArrowUpOutline />
          </a>
        </article>
      </main>
    );
  }