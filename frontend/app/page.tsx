'use client';
import dynamic from 'next/dynamic';
import '@rainbow-me/rainbowkit/styles.css';
import { RainbowKitProvider } from '@rainbow-me/rainbowkit';
import { WagmiProvider } from 'wagmi';
import { QueryClientProvider, QueryClient } from "@tanstack/react-query";
import { config } from '../config';

const queryClient = new QueryClient()

// Dynamically import Header and MainSection with SSR disabled
const Header = dynamic(() => import('./components/Header'), { ssr: false });
const MainSection = dynamic(() => import('./components/MainSection'), { ssr: false });

export default function Home() {
  return (
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>
      <RainbowKitProvider>
        <main>
          <Header />
          <MainSection />
          </main>
          </RainbowKitProvider>
      </QueryClientProvider>
    </WagmiProvider>
  );
}