'use client';
import Head from 'next/head';
import Image from 'next/image';
import Link from 'next/link';

export default function HomePage() {
    return (
        <>
        <Head>
          <title>Klar HTML Template - Frontpage one</title>
          <meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no" />
          {/* Add other meta tags as needed */}
        </Head>
        <nav id="navScroll" className="navbar navbar-dark bg-black fixed-top px-vw-5" tabIndex={0}>
          {/* Navbar content */}
        </nav>
        <main>
          {/* Main content */}
        </main>
      </>
    );
  }

