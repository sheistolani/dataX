# DataX

A decentralized, Clarity-based data marketplace that empowers individuals and organizations to share, monetize, and access verified datasets — with full transparency, control, and encryption.

---

## Overview

DataX consists of ten modular smart contracts working together to build a trustless data economy where creators retain ownership, consumers access verified datasets, and governance is community-led:

1. **Data Registry Contract** – Stores metadata for all datasets registered on the marketplace.
2. **Dataset NFT Contract** – Tokenizes datasets as NFTs with licensing and provenance.
3. **Access Control Contract** – Issues access keys/tokens after on-chain validation and payment.
4. **Escrow & Payments Contract** – Manages secure payment flows, including refunds and royalties.
5. **Reputation System Contract** – Tracks and verifies user behavior, dispute outcomes, and ratings.
6. **License Manager Contract** – Associates legal usage rights with dataset NFTs.
7. **Governance DAO Contract** – Enables decentralized protocol upgrades and fee management.
8. **Dispute Resolution Contract** – Facilitates arbitration and evidence handling in buyer-seller conflicts.
9. **Incentive Pool Contract** – Distributes rewards to curators, validators, and early adopters.
10. **Staking Contract** – Requires data providers to stake tokens to list data and discourage bad actors.

---

## Features

- **Tokenized datasets** for licensing and resale  
- **Encrypted data access** with decentralized key management  
- **On-chain payments and escrow** for fair, automatic compensation  
- **User reputation tracking** to ensure trust and reduce fraud  
- **DAO governance** for transparent protocol evolution  
- **Royalties and revenue share** for dataset co-creators  
- **Dispute resolution** via smart contract-based arbitration  
- **License enforcement** through token-bound legal templates  
- **Staking-based provider incentives** to deter spam  
- **Incentivized curation** to boost data quality and discoverability  

---

## Smart Contracts

### Data Registry Contract
- Dataset metadata registration (hash, format, schema, price)
- Searchable tagging and indexing
- Links to off-chain encrypted content

### Dataset NFT Contract
- Mint datasets as NFTs with embedded metadata
- Supports co-ownership and resale royalties
- Proof of authenticity and version control

### Access Control Contract
- Issues decryption keys or access rights after purchase
- Links ownership with off-chain storage providers
- Access logs and revocation capabilities

### Escrow & Payments Contract
- Buyer payment locking and conditional release
- Refund triggers in case of disputes
- Fee split to creator, referrer, and platform treasury

### Reputation System Contract
- Tracks buyer/seller history and outcomes
- Reputation scoring based on delivery and disputes
- Publicly queryable trust scores

### License Manager Contract
- Attaches standard or custom licenses to datasets
- Tracks expiration, revocation, and licensee info
- Prevents access if license terms are violated

### Governance DAO Contract
- Token-weighted proposals and voting
- Protocol upgrades, fee changes, role elections
- DAO treasury management

### Dispute Resolution Contract
- Allows filing and resolution of disputes
- Escalates to arbiters (or DAO) if needed
- Stores evidence and decision outcomes

### Incentive Pool Contract
- Distributes native tokens to curators, verifiers
- Rewards active marketplace participants
- Managed by DAO parameters

### Staking Contract
- Providers stake to list high-value data
- Slashed on confirmed fraud or low-quality delivery
- Bonded mechanism to ensure trust

---

## Installation

1. Install [Clarinet CLI](https://docs.hiro.so/clarinet/getting-started)
2. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/datax-marketplace.git
   ```
3. Run tests:
    ```bash
    npm run test
    ```

4. Deploy contracts locally:
    ```bash
    clarinet deploy
    ```

---

## Usage

- Each smart contract is modular but interoperable with others. For instance:
- A dataset is registered in Data Registry, minted in Dataset NFT, and access is controlled via Access Control.
- Payments are escrowed in Escrow & Payments, governed by license terms in License Manager.
- Disputes are handled in Dispute Resolution, and behavior tracked in Reputation System.
- Check the /contracts folder for individual usage guides and test scripts.

---

## License

MIT License