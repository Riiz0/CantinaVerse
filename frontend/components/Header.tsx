'use client';
import Image from 'next/image';
import Link from 'next/link';

export default function Header() {
    return (
        <nav className="homepage-navbar">
            <div className="logo-and-title">
                <Link href="/" passHref>
                    <div style={{ display: 'flex', alignItems: 'center' }}>
                        <Image
                            src="/assets/logo_title.svg"
                            width={275}
                            height={275}
                            alt="NFTC Logo"
                            layout="intrinsic"
                        />
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
        </nav>
    );
}
