'use client';
import { useEffect } from 'react';
import { Footer } from './Footer';
import { TiArrowForwardOutline } from "react-icons/ti";
import Header from './Header';
import AOS from 'aos';
import Link from 'next/link';
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
    <main>
      <div className="homepage-container">
        <Header />
        <div className="homepage-top-container">
          <p className="mission-statement">Our Mission</p>
          <h1 className="main-heading">Building an ecosystem for all</h1>
          <p className="mission-description">Empowering creators, gamers, and investors with unparalleled opportunities for expression, engagement, and financial empowerment...</p>
          <Link href="/aboutus">
            <button className="join-us-btn">Learn More <TiArrowForwardOutline aria-hidden="true" /></button>
          </Link>
        </div>

        <div className="image-container">
          <div className="image-1" data-aos="fade-up"></div>
          <div className="image-2" data-aos="fade-up"></div>
          <div className="image-3" data-aos="fade-up"></div>
        </div>

        <section className="what-we-do-sections">
          <div className="right-aligned-container" data-aos="fade-up">
            <p className="homepage-section-subtitle">What we do</p>
            <p className="homepage-section-text spacing-class">Redefining the digital asset landscape.</p>
            <p className="homepage-section-text spacing-class">Meticulously crafted to serve a broad spectrum of users.</p>
            <p className="homepage-section-text">Anchored on the robust Superchain infrastructure.</p>
          </div>
          <div className="left-aligned-container" data-aos="fade-up">
            <div className="top-section">
              <p className="product-design-strategy">Challenge</p>
              <p className="additional-info">Navigating the fast-paced blockchain landscape demands more than just innovative features—it requires a profound understanding of user needs, an unwavering commitment to quality and security, and a steadfast dedication to community engagement. The true challenge is crafting a platform that appeals to a wide audience, ranging from seasoned crypto enthusiasts to those new to the space, while guaranteeing secure transactions, meaningful interactions, and valuing every contribution.</p>
              <p className="tell-me-more">
                <Link href="/aboutus">
                  <span className="tell-me-more-content">Tell me more <TiArrowForwardOutline aria-hidden="true" /></span>
                </Link>
              </p>
              <div className="line-break"></div>
            </div>
            <div className="bottom-section">
              <p className="development-engineering">Solution</p>
              <p className="additional-info">CantinaVerse confronts these challenges directly by crafting a comprehensive ecosystem designed to cater to a wide range of interests and expertise. Prioritizing user experience at every stage, we enforce rigorous security measures to protect transactions and cultivate an active community where every voice matters. Our platform aims to serve as a beacon of innovation, a nexus for creative expression, and a driving force for meaningful engagement across the blockchain ecosystem.</p>
              <p className="tell-me-more">
                <Link href="/aboutus">
                  <span className="tell-me-more-content">Tell me more <TiArrowForwardOutline aria-hidden="true" /></span>
                </Link>
              </p>
            </div>
          </div>
        </section>

        <section className="ecosystem-sections">
          <div className="left-column">
            <div className="diagonal-container-1" data-aos="fade-up">
              <img src="/assets/4.svg" alt="Diagonal Image 1" className="container-image" />
              <p className="ecosystem-header-name">NFT Marketplace</p>
              <p className="eco-additional-info">A robust platform for buying, selling, create, mint and auctioning NFTs, facilitating seamless connections between artists and collectors.</p>
              <p className="eco-tell-me-more">
                <Link href="/marketplace">
                  <span className="eco-tell-me-more-content">Go there <TiArrowForwardOutline aria-hidden="true" /></span>
                </Link>
              </p>
            </div>
            <div className="diagonal-container-3" data-aos="fade-up">
              <img src="/assets/6.svg" alt="Diagonal Image 3" className="container-image" />
              <p className="ecosystem-header-name">Casino Gaming</p>
              <p className="eco-additional-info">A variety of casino games, ensuring a fair and transparent gaming experience through partnerships with trusted networks like Gelato.</p>
              <p className="eco-tell-me-more">
                <Link href="/casinogames">
                  <span className="eco-tell-me-more-content">Go there <TiArrowForwardOutline aria-hidden="true" /></span>
                </Link>
              </p>
            </div>
          </div>
          <div className="right-column">
            <div className="text-container" data-aos="fade-up">
              <p className="ecosystem-section-subtitle">Ecosystem</p>
              <p className="ecosystem-section-text">Fostering a vibrant community where innovation and mutual benefit thrive.</p>
            </div>
            <div className="diagonal-container-2" data-aos="fade-up">
              <img src="/assets/5.svg" alt="Diagonal Image 2" className="container-image" />
              <p className="ecosystem-header-name">Token Creation</p>
              <p className="eco-additional-info">A user-friendly interface for creating ERC20 tokens, allowing users to opt-in purchasing these created token providing the initial liquidity pooling once the threshold amount is reached for this tokens to be traded on DEX's.
              </p>
              <p className="eco-tell-me-more">
                <Link href="/tokencreation">
                  <span className="eco-tell-me-more-content">Go there <TiArrowForwardOutline aria-hidden="true" /></span>
                </Link>
              </p>
            </div>
            <div className="diagonal-container-4" data-aos="fade-up">
              <img src="/assets/7.svg" alt="Diagonal Image 4" className="container-image" />
              <p className="ecosystem-header-name">Governance Voting</p>
              <p className="eco-additional-info">Empowers users to vote on new platform upgrades, giveaways, game integrations, and community-sponsored incentives.</p>
              <p className="eco-tell-me-more">
                <Link href="/governance">
                  <span className="eco-tell-me-more-content">Go there <TiArrowForwardOutline aria-hidden="true" /></span>
                </Link>
              </p>
            </div>
          </div>
        </section>
        <Footer />
      </div>
    </main>
  );
}