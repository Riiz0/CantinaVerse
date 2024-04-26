# NFT Marketplace

## About

This project aims to create a decentralized NFT marketplace on the Ethereum blockchain. The marketplace will allow users to create, buy, sell, and trade NFTs using smart contracts.

## Components

### Smart Contracts

- **NFT Contract (ERC-721)**: Implements the ERC-721 standard for NFTs, handling creation, ownership, and transfer.
- **Marketplace Contract (Includes Auction)**: Manages the listing, buying, and selling of NFTs on the marketplace.
- **Access Control Contract (Optional)**: Manages permissions and roles within the marketplace.

### Development Tools

- **Foundry**: For compiling, deploying, and testing smart contracts.
- **Ganache**: For local blockchain development and testing.
- **MetaMask**: For interacting with the Ethereum blockchain.

### User Interface

A user-friendly interface will be developed to allow users to list their NFTs for sale, browse available NFTs, and interact with the marketplace through transactions.

### Features

- **Fee Management**: Implemented within smart contracts to handle marketplace fees on transactions.
- **Search/Filter Functionality**: Off-chain mechanisms for efficient search and filter functionalities.
- **Security and Testing**: Rigorous testing and security audits to ensure the marketplace operates reliably and securely.
- **Royalty System**: A contract that tracks and distributes royalties to NFT creators on secondary sales.

## Getting Started

1. **Set Up Development Environment**: Install Foundry, Ganache, and MetaMask.
2. **Develop Smart Contracts**: Start by implementing the NFT, Marketplace (Auction). Optionally, implement  Access Control contracts.
3. **Develop User Interface**: Create a user-friendly interface for listing, buying, and managing NFTs.
4. **Testing**: Write and run tests for your smart contracts to ensure they work as expected.
5. **Deployment**: Deploy your smart contracts to the Ethereum blockchain and connect your UI to interact with them.

## Contributing

Contributions are welcome! Please read the contribution guidelines before submitting pull requests.

## License

This project is licensed under the MIT License.

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
