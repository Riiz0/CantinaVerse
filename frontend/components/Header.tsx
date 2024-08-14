'use client';
import Image from 'next/image';
import Link from 'next/link';

export default function Header() {
    return (
        <nav className="homepage-navbar">
            <div className="logo-and-title">
                <Link href="/" passHref>
                    <div style={{ display: 'flex', alignItems: 'center' }}>
                        <Image src="/assets/CantinaVerse_Transparent.svg" width={68} height={48} alt="NFTC Logo" />
                        <span className="navbar-title">CantinaVerse</span>
                    </div>
                </Link>
            </div>
            <ul className="navbar-links">
                <li><Link href="/marketplace">Marketplace</Link></li>
                <li><Link href="/tokencreation">Token Creation</Link></li>
                <li><Link href="/casinogames">Gaming</Link></li>
                <li><Link href="/governance">DAO</Link></li>
                <li><Link href="/aboutus">About Us</Link></li>
            </ul>
            <div className="hidden-element"></div>
        </nav>
    );
};
