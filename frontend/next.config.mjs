/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  webpack: config => {
    config.externals.push('pino-pretty', 'lokijs', 'encoding');
    return config;
  },
  output: 'standalone',
  // Add this line
  trailingSlash: false,
};

export default nextConfig;
