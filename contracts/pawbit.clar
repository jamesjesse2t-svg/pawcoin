;; Pawbit (PBIT) SIP-010 fungible token

(use-trait sip010 .sip-010-trait.sip010-ft-standard)
(impl-trait .sip-010-trait.sip010-ft-standard)

(define-fungible-token pawbit)

;; Errors
(define-constant ERR-UNAUTHORIZED u100)
(define-constant ERR-ZERO-AMOUNT u102)

;; Metadata
(define-constant TOKEN_NAME "Pawbit")
(define-constant TOKEN_SYMBOL "PBIT")
(define-constant TOKEN_DECIMALS u6)

(define-data-var token-admin principal tx-sender)
(define-data-var token-uri (optional (string-utf8 256)) none)

;; Read-only SIP-010 getters
(define-read-only (get-name)
  (ok TOKEN_NAME)
)

(define-read-only (get-symbol)
  (ok TOKEN_SYMBOL)
)

(define-read-only (get-decimals)
  (ok TOKEN_DECIMALS)
)

(define-read-only (get-balance (who principal))
  (ok (ft-get-balance pawbit who))
)

(define-read-only (get-total-supply)
  (ok (ft-get-supply pawbit))
)

(define-read-only (get-token-uri)
  (ok (var-get token-uri))
)

;; Admin helpers
(define-read-only (get-admin)
  (ok (var-get token-admin))
)

(define-public (set-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get token-admin)) (err ERR-UNAUTHORIZED))
    (var-set token-admin new-admin)
    (ok true)
  )
)

(define-public (set-token-uri (maybe-uri (optional (string-utf8 256))))
  (begin
    (asserts! (is-eq tx-sender (var-get token-admin)) (err ERR-UNAUTHORIZED))
    (var-set token-uri maybe-uri)
    (ok true)
  )
)

;; SIP-010 transfer with optional memo
(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (begin
    (asserts! (> amount u0) (err ERR-ZERO-AMOUNT))
    (asserts! (is-eq sender tx-sender) (err ERR-UNAUTHORIZED))
    (try! (ft-transfer? pawbit amount sender recipient))
    (ok true)
  )
)

;; Admin mint/burn
(define-public (mint (amount uint) (recipient principal))
  (begin
    (asserts! (> amount u0) (err ERR-ZERO-AMOUNT))
    (asserts! (is-eq tx-sender (var-get token-admin)) (err ERR-UNAUTHORIZED))
    (try! (ft-mint? pawbit amount recipient))
    (ok true)
  )
)

(define-public (burn (amount uint) (owner principal))
  (begin
    (asserts! (> amount u0) (err ERR-ZERO-AMOUNT))
    (asserts! (is-eq tx-sender (var-get token-admin)) (err ERR-UNAUTHORIZED))
    (try! (ft-burn? pawbit amount owner))
    (ok true)
  )
)
