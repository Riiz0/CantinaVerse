'use client';
import dynamic from 'next/dynamic';
const Header = dynamic(() => import('../components/pagesHeader'), { ssr: false });
const MainSection = dynamic(() => import('../components/nftmarketplace/homepage/MainSection'), { ssr: false });

export default function Home() {
  return (
        <main>
          <Header />
          <MainSection /> 
          </main>
  );
}