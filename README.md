# PawCoin (PAW)

SIP-010 compliant fungible token implemented in Clarity and structured for use with Clarinet.

## Prerequisites
- Install Clarinet: https://github.com/hirosystems/clarinet

## Project layout
- `Clarinet.toml` – Clarinet project manifest
- `contracts/traits/sip-010-trait.clar` – SIP-010 trait definition
- `contracts/pawcoin.clar` – PawCoin token contract

## Quick start
```bash
# Validate contracts
clarinet check

# Open a dev console
clarinet console
```

## Example (in Clarinet console)
```clarity
;; Mint 1,000,000 PAW (decimals = 6) to the deployer
(contract-call? .pawcoin mint tx-sender u1000000)

;; Check your balance
(contract-call? .pawcoin get-balance tx-sender)

;; Transfer 500 PAW from you to someone
(contract-call? .pawcoin transfer u500 tx-sender 'ST3J2GVMMM2R07ZFBJDWTYEYAR8FZH5WKDTFJ9AHA none)

;; Read token metadata
(contract-call? .pawcoin get-name)
(contract-call? .pawcoin get-symbol)
(contract-call? .pawcoin get-decimals)
(contract-call? .pawcoin get-total-supply)
```

## Notes
- `token-admin` is initially the deployer and can call `mint` or `set-admin`.
- Decimals are set to `u6` (i.e., 1 PAW = 1_000_000 base units).
- Errors: `u100` unauthorized, `u101` insufficient balance, `u102` zero amount.
