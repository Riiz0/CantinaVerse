'use client';
import { useEffect } from 'react';
import { Footer } from './Footer';
import { TiArrowForwardOutline } from "react-icons/ti";
import Header from './Header';
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
    <main>
      <div className="homepage-container">
        <Header />
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
            <p className="homepage-section-text">Redefining the digital asset landscape, meticulously crafted to serve a broad spectrum of users, anchored on the robust Superchain infrastructure.</p>
          </div>
          <div className="left-aligned-container">
            <div className="top-section">
              <p className="product-design-strategy">Challenge</p>
              <p className="additional-info">In the rapidly evolving blockchain landscape, standing out is not just about introducing innovative features—it's about deeply understanding user needs, uncompromisingly prioritizing quality and security, and steadfastly committing to community engagement. The challenge lies in creating a platform that resonates with a diverse audience, from seasoned crypto enthusiasts to newcomers, while ensuring that every transaction is secure, every interaction is meaningful, and every contribution is valued.</p>
              <p className="tell-me-more">
                <a href="https://example.com/whitepaper" target="_blank" rel="noopener noreferrer">
                  <span className="tell-me-more-content">Tell me more <TiArrowForwardOutline aria-hidden="true" /></span>
                </a>
              </p>
              <div className="line-break"></div>
            </div>
            <div className="bottom-section">
              <p className="development-engineering">Solution</p>
              <p className="additional-info">CantinaVerse rises to meet these challenges head-on by weaving together a comprehensive ecosystem tailored to a broad spectrum of interests and expertise. We prioritize user experience at every turn, implementing stringent security measures to safeguard transactions, and fostering an active community where every voice counts. Our platform is designed to be a beacon of innovation, a hub for creative expression, and a catalyst for meaningful engagement within the blockchain space.</p>
              <p className="tell-me-more">
                <a href="https://example.com/whitepaper" target="_blank" rel="noopener noreferrer">
                  <span className="tell-me-more-content">Tell me more <TiArrowForwardOutline aria-hidden="true" /></span>
                </a>
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
                <a href="https://example.com/whitepaper" target="_blank" rel="noopener noreferrer">
                  <span className="eco-tell-me-more-content">Go there <TiArrowForwardOutline aria-hidden="true" /></span>
                </a>
              </p>
            </div>
            <div className="diagonal-container-3" data-aos="fade-up">
              <img src="/assets/6.svg" alt="Diagonal Image 3" className="container-image" />
              <p className="ecosystem-header-name">Casino Gaming</p>
              <p className="eco-additional-info">A variety of casino games, ensuring a fair and transparent gaming experience through partnerships with trusted networks like Gelato.</p>
              <p className="eco-tell-me-more">
                <a href="https://example.com/whitepaper" target="_blank" rel="noopener noreferrer">
                  <span className="eco-tell-me-more-content">Go there <TiArrowForwardOutline aria-hidden="true" /></span>
                </a>
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
                <a href="https://example.com/whitepaper" target="_blank" rel="noopener noreferrer">
                  <span className="eco-tell-me-more-content">Go there <TiArrowForwardOutline aria-hidden="true" /></span>
                </a>
              </p>
            </div>
            <div className="diagonal-container-4" data-aos="fade-up">
              <img src="/assets/7.svg" alt="Diagonal Image 4" className="container-image" />
              <p className="ecosystem-header-name">Governance Voting</p>
              <p className="eco-additional-info">Empowers users to vote on new platform upgrades, giveaways, game integrations, and community-sponsored incentives.</p>
              <p className="eco-tell-me-more">
                <a href="https://example.com/whitepaper" target="_blank" rel="noopener noreferrer">
                  <span className="eco-tell-me-more-content">Go there <TiArrowForwardOutline aria-hidden="true" /></span>
                </a>
              </p>
            </div>
          </div>
        </section>

        <section className="road-map-sections">
        </section>

        <section className="what-others-have-to-say-sections">
        </section>

        <section className="getting-started-section">
        </section>
        <Footer />
      </div>
    </main>
  );
}