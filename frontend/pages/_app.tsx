import "@rainbow-me/rainbowkit/styles.css";
import type { AppProps } from 'next/app';
import Providers from '../providers/providers';
import '../app/globals.css';

function MyApp({ Component, pageProps }: AppProps) {
  return (
    <Providers>
      <Component {...pageProps} />
    </Providers>
  );
}

export default MyApp;