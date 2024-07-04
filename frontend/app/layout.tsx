import "@rainbow-me/rainbowkit/styles.css";
import type { Metadata } from "next";
import Providers from "../providers/providers";
import "./globals.css";

export const metadata: Metadata = {
  title: "Cantina | NFT Marketplace",
  description: "Discover, collect, and sell extraordinary NFTs",
};

function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>
        <Providers>{children}</Providers>
      </body>
    </html>
  );
}

export default RootLayout;