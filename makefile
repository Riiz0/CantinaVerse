-include .env

.PHONY: all test clean deploy fund help install snapshot format anvil scopefile

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

all: remove install build

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install foundry-rs/forge-std --no-commit && forge install openzeppelin/openzeppelin-contracts --no-commit

# Update Dependencies
update:; forge update

build:; forge build

test :; forge test 

snapshot :; forge snapshot

format :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

slither :; slither . --config-file slither.config.json --checklist 

aderyn :; aderyn .

scopefile :; @tree ./src/ | sed 's/└/#/g' | awk -F '── ' '!/\.sol$$/ { path[int((length($$0) - length($$2))/2)] = $$2; next } { p = "src"; for(i=2; i<=int((length($$0) - length($$2))/2); i++) if (path[i] != "") p = p "/" path[i]; print p "/" $$2; }' > scope.txt

scope :; tree ./src/ | sed 's/└/#/g; s/──/--/g; s/├/#/g; s/│ /|/g; s/│/|/g'

# Sepolia Deploy script
deploy sepolia AuctionEndChecker :; forge script script/DeployAuctionEndChecker.s.sol:DeployAuctionEndChecker --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --verifier blockscout --verifier-url $(VERIFIER_URL)
deploy sepolia MarketPlace :; forge script script/DeployMarketPlace.s.sol:DeployMarketPlace --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --verifier blockscout --verifier-url $(VERIFIER_URL)
deploy sepolia FactoryNFTContract :; forge script script/DeployFactoryNFTContract.s.sol:DeployFactoryNFTContract --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --verifier blockscout --verifier-url $(VERIFIER_URL)

# Base Deploy script
deploy base AuctionEndChecker :; forge script script/DeployAuctionEndChecker.s.sol:DeployAuctionEndChecker --rpc-url $(BASE_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --verifier blockscout --verifier-url $(VERIFIER_URL)
deploy base MarketPlace :; forge script script/DeployMarketPlace.s.sol:DeployMarketPlace --rpc-url $(BASE_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --verifier blockscout --verifier-url $(VERIFIER_URL)
deploy base FactoryNFTContract :; forge script script/DeployFactoryNFTContract.s.sol:DeployFactoryNFTContract --rpc-url $(BASE_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --verifier blockscout --verifier-url $(VERIFIER_URL)

# OP Deploy script
deploy op AuctionEndChecker :; forge script script/DeployAuctionEndChecker.s.sol:DeployAuctionEndChecker --rpc-url $(OP_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --verifier blockscout --verifier-url $(VERIFIER_URL)
deploy op MarketPlace :; forge script script/DeployMarketPlace.s.sol:DeployMarketPlace --rpc-url $(OP_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --verifier blockscout --verifier-url $(VERIFIER_URL)
deploy op FactoryNFTContract :; forge script script/DeployFactoryNFTContract.s.sol:DeployFactoryNFTContract --rpc-url $(OP_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --verifier blockscout --verifier-url $(VERIFIER_URL)

# Zora Deploy script
deploy zora AuctionEndChecker :; forge script script/DeployAuctionEndChecker.s.sol:DeployAuctionEndChecker --rpc-url $(ZORA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --verifier blockscout --verifier-url $(VERIFIER_URL)
deploy zora MarketPlace :; forge script script/DeployMarketPlace.s.sol:DeployMarketPlace --rpc-url $(ZORA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --verifier blockscout --verifier-url $(VERIFIER_URL)
deploy zora FactoryNFTContract :; forge script script/DeployFactoryNFTContract.s.sol:DeployFactoryNFTContract --rpc-url $(ZORA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --verifier blockscout --verifier-url $(VERIFIER_URL)

#Frax Deploy script
deploy Frax AuctionEndChecker :; forge script script/DeployAuctionEndChecker.s.sol:DeployAuctionEndChecker --rpc-url $(FRAX_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --verifier blockscout --verifier-url $(VERIFIER_URL)
deploy Frax MarketPlace :; forge script script/DeployMarketPlace.s.sol:DeployMarketPlace --rpc-url $(FRAX_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --verifier blockscout --verifier-url $(VERIFIER_URL)
deploy Frax FactoryNFTContract :; forge script script/DeployFactoryNFTContract.s.sol:DeployFactoryNFTContract --rpc-url $(FRAX_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --verifier blockscout --verifier-url $(VERIFIER_URL)

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- #
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- #

# Sepolia Verify script
verify sepolia AuctionEndChecker :; forge script script/DeployAuctionEndChecker.s.sol:DeployAuctionEndChecker --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --resume --verify --verifier blockscout --verifier-url $(VERIFIER_URL)
verify sepolia MarketPlace :; forge script script/DeployMarketPlace.s.sol:DeployMarketPlace --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --resume --verify --verifier blockscout --verifier-url $(VERIFIER_URL)
verify sepolia FactoryNFTContract :; forge script script/DeployFactoryNFTContract.s.sol:DeployFactoryNFTContract --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --resume --verify --verifier blockscout --verifier-url $(VERIFIER_URL)

# Base Verify script
verify base AuctionEndChecker :; forge script script/DeployAuctionEndChecker.s.sol:DeployAuctionEndChecker --rpc-url $(BASE_RPC_URL) --private-key $(PRIVATE_KEY) --resume --verify --verifier blockscout --verifier-url $(VERIFIER_URL)
verify base MarketPlace :; forge script script/DeployMarketPlace.s.sol:DeployMarketPlace --rpc-url $(BASE_RPC_URL) --private-key $(PRIVATE_KEY) --resume --verify --verifier blockscout --verifier-url $(VERIFIER_URL)
verify base FactoryNFTContract :; forge script script/DeployFactoryNFTContract.s.sol:DeployFactoryNFTContract --rpc-url $(BASE_RPC_URL) --private-key $(PRIVATE_KEY) --resume --verify --verifier blockscout --verifier-url $(VERIFIER_URL)

# OP Verify script
verify op AuctionEndChecker :; forge script script/DeployAuctionEndChecker.s.sol:DeployAuctionEndChecker --rpc-url $(OP_RPC_URL) --private-key $(PRIVATE_KEY) --resume --verify --verifier blockscout --verifier-url $(VERIFIER_URL)
verify op MarketPlace :; forge script script/DeployMarketPlace.s.sol:DeployMarketPlace --rpc-url $(OP_RPC_URL) --private-key $(PRIVATE_KEY) --resume --verify --verifier blockscout --verifier-url $(VERIFIER_URL)
verify op FactoryNFTContract :; forge script script/DeployFactoryNFTContract.s.sol:DeployFactoryNFTContract --rpc-url $(OP_RPC_URL) --private-key $(PRIVATE_KEY) --resume --verify --verifier blockscout --verifier-url $(VERIFIER_URL)

# Zora Verify script
verify zora AuctionEndChecker :; forge script script/DeployAuctionEndChecker.s.sol:DeployAuctionEndChecker --rpc-url $(ZORA_RPC_URL) --private-key $(PRIVATE_KEY) --resume --verify --verifier blockscout --verifier-url $(VERIFIER_URL)
verify zora MarketPlace :; forge script script/DeployMarketPlace.s.sol:DeployMarketPlace --rpc-url $(ZORA_RPC_URL) --private-key $(PRIVATE_KEY) --resume --verify --verifier blockscout --verifier-url $(VERIFIER_URL)
verify zora FactoryNFTContract :; forge script script/DeployFactoryNFTContract.s.sol:DeployFactoryNFTContract --rpc-url $(ZORA_RPC_URL) --private-key $(PRIVATE_KEY) --resume --verify --verifier blockscout --verifier-url $(VERIFIER_URL)

# Frax Verify script
verify frax AuctionEndChecker :; forge script script/DeployAuctionEndChecker.s.sol:DeployAuctionEndChecker --rpc-url $(FRAX_RPC_URL) --private-key $(PRIVATE_KEY) --resume --verify --verifier blockscout --verifier-url $(VERIFIER_URL)
verify frax MarketPlace :; forge script script/DeployMarketPlace.s.sol:DeployMarketPlace --rpc-url $(FRAX_RPC_URL) --private-key $(PRIVATE_KEY) --resume --verify --verifier blockscout --verifier-url $(VERIFIER_URL)
verify frax FactoryNFTContract :; forge script script/DeployFactoryNFTContract.s.sol:DeployFactoryNFTContract --rpc-url $(FRAX_RPC_URL) --private-key $(PRIVATE_KEY) --resume --verify --verifier blockscout --verifier-url $(VERIFIER_URL)
