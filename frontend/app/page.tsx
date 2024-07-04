import dynamic from 'next/dynamic';
const Header = dynamic(() => import('../components/Header'), { ssr: false });
const MainSection = dynamic(() => import('../components/MainSection'), { ssr: false });


export default function Home() {
  return (
        <main>
          <Header />
          <MainSection />
          </main>
  );
}