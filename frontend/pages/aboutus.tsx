'use client';

import { Footer } from '../components/Footer';
import Header from '../components/Header';
import Image from 'next/image';
export default function AboutUs() {
    return (
        <main>
            <Header />
            <section className="aboutus-top-section">
                <h1 className="aboutus-big-text">What is CantinaVerse?</h1>
                <hr className="aboutus-horizontal-line" />
                <p className="aboutus-medium-text">CantinaVerse is a groundbreaking blockchain ecosystem designed to redefine the digital asset landscape. Built on the cutting-edge Superchain, our platform integrates a robust NFT marketplace, advanced ERC20 token creation capabilities, immersive casino games, and a governance framework (DAOs) to give power to the people of CantinaVerse. Our mission is to empower creators, gamers, and investors with unparalleled opportunities for expression, engagement, and financial empowerment. We are a team of passionate blockchain enthusiasts and tech innovators committed to building a vibrant, user-centric ecosystem that leverages the power of blockchain technology to foster creativity, gaming, and investment. Our team comprises experienced professionals from various fields, including blockchain development, game design, and digital art, united by a common vision to transform the digital asset space.</p>
            </section>
            <section className="svg-section">
                <Image src="/assets/8.svg" width={500} height={500} alt="Team Image" className="svg-image" />
            </section>
            {/*<section className="newsletter-section">
                <h2 className="newsletter-title">Stay Updated</h2>
                <p className="newsletter-description">Subscribe to our newsletter to stay up to date with CantinaVerse.</p>
                <form className="newsletter-form">
                    <input type="email" placeholder="Your Email Address" className="newsletter-input" />
                    <button type="submit" className="newsletter-button">Subscribe Now</button>
                </form>
            </section> */}

            {/* Commented Out Team Section */}
            {/* <section className="team-section">
                <div className="team-text-column">
                    <hr className="aboutus-team-horizontal-line" />
                    <h2>Meet the Team</h2>
                    <ul>
                        <li><strong>Founder:</strong> John Doe - A visionary leader driving the future of CantinaVerse.</li>
                        <li><strong>UX/UI Designer:</strong> Jane Smith - Crafting intuitive interfaces for seamless user experiences.</li>
                    </ul>
                </div>
                <div className="team-image-column">
                    <img src="path/to/founder-image.jpg" alt="Founder" className="team-member-image" />
                    <img src="path/to/ui-designer-image.jpg" alt="UI Designer" className="team-member-image" />
                </div>
            </section> */}

            <Footer />
        </main>
    );
}

