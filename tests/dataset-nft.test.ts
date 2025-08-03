import { describe, it, expect, beforeEach } from "vitest"

type TokenId = number

interface DatasetNFTContract {
  admin: string
  paused: boolean
  totalSupply: number
  tokenOwners: Map<TokenId, string>
  tokenMetadata: Map<TokenId, string>
  tokenHashes: Map<TokenId, string>

  isAdmin(caller: string): boolean
  setPaused(caller: string, pause: boolean): { value?: boolean; error?: number }
  mint(caller: string, recipient: string, metadata: string, hash: string): { value?: TokenId; error?: number }
  transfer(caller: string, tokenId: TokenId, to: string): { value?: boolean; error?: number }
}

const mockContract: DatasetNFTContract = {
  admin: "ST1ADMIN...",
  paused: false,
  totalSupply: 0,
  tokenOwners: new Map(),
  tokenMetadata: new Map(),
  tokenHashes: new Map(),

  isAdmin(caller) {
    return caller === this.admin
  },

  setPaused(caller, pause) {
    if (!this.isAdmin(caller)) return { error: 100 }
    this.paused = pause
    return { value: pause }
  },

  mint(caller, recipient, metadata, hash) {
    if (!this.isAdmin(caller)) return { error: 100 }
    if (this.paused) return { error: 102 }
    const tokenId = ++this.totalSupply
    this.tokenOwners.set(tokenId, recipient)
    this.tokenMetadata.set(tokenId, metadata)
    this.tokenHashes.set(tokenId, hash)
    return { value: tokenId }
  },

  transfer(caller, tokenId, to) {
    if (this.paused) return { error: 102 }
    const owner = this.tokenOwners.get(tokenId)
    if (owner !== caller) return { error: 101 }
    this.tokenOwners.set(tokenId, to)
    return { value: true }
  }
}

describe("Dataset NFT Contract", () => {
  beforeEach(() => {
    mockContract.admin = "ST1ADMIN..."
    mockContract.paused = false
    mockContract.totalSupply = 0
    mockContract.tokenOwners = new Map()
    mockContract.tokenMetadata = new Map()
    mockContract.tokenHashes = new Map()
  })

  it("should allow admin to mint NFTs", () => {
    const result = mockContract.mint("ST1ADMIN...", "ST2DATA...", "metadata.json", "hash123")
    expect(result.value).toBe(1)
    expect(mockContract.tokenOwners.get(1)).toBe("ST2DATA...")
  })

  it("should prevent minting when paused", () => {
    mockContract.setPaused("ST1ADMIN...", true)
    const result = mockContract.mint("ST1ADMIN...", "ST2DATA...", "meta", "hash")
    expect(result.error).toBe(102)
  })

  it("should transfer token if owner", () => {
    mockContract.mint("ST1ADMIN...", "ST2DATA...", "data.json", "hash")
    const result = mockContract.transfer("ST2DATA...", 1, "ST3RECV...")
    expect(result.value).toBe(true)
    expect(mockContract.tokenOwners.get(1)).toBe("ST3RECV...")
  })

  it("should not transfer if not owner", () => {
    mockContract.mint("ST1ADMIN...", "ST2DATA...", "data", "hash")
    const result = mockContract.transfer("ST3RECV...", 1, "ST4EVIL...")
    expect(result.error).toBe(101)
  })
})
