'use client';
import { useEffect } from 'react';
import { Footer } from './Footer';
import { TiArrowForwardOutline } from "react-icons/ti";
import Image from 'next/image';
import Link from 'next/link';
import AOS from 'aos';
import 'aos/dist/aos.css';

export default function HomePage() {
  useEffect(() => {
    AOS.init({
      duration: 1200, // values from 0 to 3000, with step 50ms
    });

    // Function to handle scroll event
    const handleScroll = () => {
      // If the scroll position is at the top, refresh AOS to reset animations
      if (window.scrollY === 0) {
        AOS.refresh();
      }
    };

    // Add scroll event listener
    window.addEventListener('scroll', handleScroll);

    // Cleanup function to remove event listener
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  return (
    <div className="homepage-container">
    <nav className="homepage-navbar">
      {/* Logo and "CantinaVerse" Text */}
      <div className="logo-and-title">
        <Image src="/assets/CantinaVerse_Transparent.svg" width={68} height={48} alt="NFTC Logo" />
        <span className="navbar-title">CantinaVerse</span>
      </div>
      <ul className="navbar-links">
        <li><Link href="/nftmarketplace">Marketplace</Link></li>
        <li><Link href="/tokencreation">Token Pump</Link></li>
        <li><Link href="/casinogames">Gaming</Link></li>
          <li><Link href="/governance">DAO</Link></li>
          <li><Link href="/governance">About</Link></li>
        </ul>
        <div className="hidden-element"></div>
    </nav>

    <div className="homepage-top-container">
      <p className="mission-statement">Our Mission</p>
      <h1 className="main-heading">Building an ecosystem for all</h1>
      <p className="mission-description">Empowering creators, gamers, and investors with unparalleled opportunities for expression, engagement, and financial empowerment...</p>
        <button className="join-us-btn">Join us <TiArrowForwardOutline aria-hidden="true" /></button>
      </div>
      
    <div className="image-container">
      <div className="image-1" data-aos="fade-up"></div>
      <div className="image-2" data-aos="fade-up"></div>
      <div className="image-3" data-aos="fade-up"></div>
    </div>
      
    <section className="what-we-do-sections">
    <div className="right-aligned-container">
      <p className="homepage-section-subtitle">What we do</p>
      <p className="homepage-section-text">Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor wdsfi fwef asdf aj reoimgerge rio reg ergwef q vmin wef.</p>
    </div>
    <div className="left-aligned-container">
  <div className="top-section">
    <p className="product-design-strategy">Product Design & Strategy</p>
    <p className="additional-info">Additional information about product design and strategy goes here. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor wdsfi fwef asdf aj reoimgerge rio reg ergwef q vmin wef.</p>
    <p className="tell-me-more">
  <a href="https://example.com/whitepaper" target="_blank" rel="noopener noreferrer">
    <span className="tell-me-more-content">Tell me more <TiArrowForwardOutline aria-hidden="true" /></span>
  </a>
</p>
    <div className="line-break"></div>
    </div>
  <div className="bottom-section">
  <p className="development-engineering">Development & Engineering</p>
  <p className="additional-info">Additional information about product design and strategy goes here. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor wdsfi fwef asdf aj reoimgerge rio reg ergwef q vmin wef.</p>
  <p className="tell-me-more">
  <a href="https://example.com/whitepaper" target="_blank" rel="noopener noreferrer">
    <span className="tell-me-more-content">Tell me more <TiArrowForwardOutline aria-hidden="true" /></span>
  </a>
</p>
</div>
</div>
</section>

    <section className="ecosystem-sections">
      {/* Content for ERC-20 Token Creation */}
    </section>

    <section className="problem-we-solve-sections">
      {/* Content for Casino Games */}
    </section>

    <section className="what-others-have-to-say-sections">
      {/* Content for Governance Voting */}
        </section>
        <Footer />
    </div>
  );
}