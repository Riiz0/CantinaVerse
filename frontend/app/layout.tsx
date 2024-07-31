import "@rainbow-me/rainbowkit/styles.css";
import type { Metadata } from "next";
import Providers from "../providers/providers";
import "./globals.css";

export const metadata: Metadata = {
  title: "CantinaVerse",
  description: "Building a ecosystem that integrates NFTs, ERC20 tokens, casino games, and DAO governance, aiming to empower creators, gamers, and investors with opportunities for expression, engagement, and financial empowerment.",
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