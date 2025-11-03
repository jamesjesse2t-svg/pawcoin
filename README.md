# Pawbit (PBIT)

SIP-010 compliant fungible token implemented in Clarity and structured for use with Clarinet.

## Prerequisites
- Install Clarinet: https://github.com/hirosystems/clarinet

## Project layout
- `Clarinet.toml` – Clarinet project manifest
- `contracts/traits/sip-010-trait.clar` – SIP-010 trait definition
- `contracts/pawbit.clar` – Pawbit token contract

## Quick start
```bash
# Validate contracts
clarinet check

# Open a dev console
clarinet console
```

## Example (in Clarinet console)
```clarity
;; Mint 1,000,000 PBIT (decimals = 6) to the deployer
(contract-call? .pawbit mint u1000000 tx-sender)

;; Check your balance
(contract-call? .pawbit get-balance tx-sender)

;; Transfer 500 PBIT from you to someone
(contract-call? .pawbit transfer u500 tx-sender 'ST3J2GVMMM2R07ZFBJDWTYEYAR8FZH5WKDTFJ9AHA none)

;; Read token metadata
(contract-call? .pawbit get-name)
(contract-call? .pawbit get-symbol)
(contract-call? .pawbit get-decimals)
(contract-call? .pawbit get-total-supply)
```

## Notes
- `token-admin` is initially the deployer and can call `mint`, `burn`, `set-admin`, and `set-token-uri`.
- Decimals are set to `u6` (i.e., 1 PBIT = 1_000_000 base units).
- Errors: `u100` unauthorized, `u102` zero amount.
