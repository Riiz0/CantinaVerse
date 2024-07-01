'use client';
import '@rainbow-me/rainbowkit/styles.css';
import { RainbowKitProvider } from '@rainbow-me/rainbowkit';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { WagmiProvider } from 'wagmi'
import { config } from '../config'
import { Header } from './components/Header';
import { MainSection } from './components/MainSection';

const queryClient = new QueryClient()

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