;; PawCoin - SIP-010 compliant fungible token

(impl-trait .sip-010-trait.sip-010-trait)

(define-constant TOKEN-NAME "PawCoin")
(define-constant TOKEN-SYMBOL "PAW")
(define-constant TOKEN-DECIMALS u6)

(define-constant ERR-NOT-AUTHORIZED u100)
(define-constant ERR-INSUFFICIENT-BALANCE u101)
(define-constant ERR-ZERO-AMOUNT u102)

(define-data-var token-admin principal tx-sender)
(define-data-var total-supply uint u0)
(define-map balances { owner: principal } { balance: uint })

(define-read-only (get-name)
  (ok TOKEN-NAME)
)

(define-read-only (get-symbol)
  (ok TOKEN-SYMBOL)
)

(define-read-only (get-decimals)
  (ok TOKEN-DECIMALS)
)

(define-read-only (get-total-supply)
  (ok (var-get total-supply))
)

(define-read-only (get-balance (who principal))
  (ok (default-to u0 (get balance (map-get? balances { owner: who }))))
)

(define-private (credit (who principal) (amount uint))
  (let (
        (bal (default-to u0 (get balance (map-get? balances { owner: who }))))
       )
    (map-set balances { owner: who } { balance: (+ bal amount) })
  )
)

(define-private (debit (who principal) (amount uint))
  (let (
        (bal (default-to u0 (get balance (map-get? balances { owner: who }))))
       )
    (if (>= bal amount)
        (begin
          (map-set balances { owner: who } { balance: (- bal amount) })
          (ok true)
        )
        (err ERR-INSUFFICIENT-BALANCE)
    )
  )
)

(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (if (not (> amount u0))
      (err ERR-ZERO-AMOUNT)
      (if (is-eq tx-sender sender)
          (match (debit sender amount)
            ok-val
              (begin
                (credit recipient amount)
                (print { event: "transfer", amount: amount, sender: sender, recipient: recipient, memo: memo })
                (ok true)
              )
            err-code
              (err err-code)
          )
          (err ERR-NOT-AUTHORIZED)
      )
  )
)

(define-public (mint (recipient principal) (amount uint))
  (if (not (> amount u0))
      (err ERR-ZERO-AMOUNT)
      (if (is-eq tx-sender (var-get token-admin))
          (begin
            (credit recipient amount)
            (var-set total-supply (+ (var-get total-supply) amount))
            (print { event: "mint", recipient: recipient, amount: amount })
            (ok true)
          )
          (err ERR-NOT-AUTHORIZED)
      )
  )
)

(define-public (burn (amount uint))
  (if (not (> amount u0))
      (err ERR-ZERO-AMOUNT)
      (match (debit tx-sender amount)
        ok-val
          (begin
            (var-set total-supply (- (var-get total-supply) amount))
            (print { event: "burn", owner: tx-sender, amount: amount })
            (ok true)
          )
        err-code
          (err err-code)
      )
  )
)

(define-public (set-admin (new-admin principal))
  (if (is-eq tx-sender (var-get token-admin))
      (begin
        (var-set token-admin new-admin)
        (print { event: "set-admin", new: new-admin })
        (ok true)
      )
      (err ERR-NOT-AUTHORIZED)
  )
)

(define-read-only (get-admin)
  (ok (var-get token-admin))
)
