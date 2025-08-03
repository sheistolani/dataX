;; Dataset NFT Contract - Clarity v2

(define-constant ERR-NOT-AUTHORIZED u100)
(define-constant ERR-NOT-OWNER u101)
(define-constant ERR-PAUSED u102)
(define-constant ERR-TOKEN-NOT-FOUND u103)
(define-constant ERR-ZERO-ADDRESS u104)

(define-data-var admin principal tx-sender)
(define-data-var paused bool false)
(define-data-var total-supply uint u0)

(define-map token-owners uint principal)
(define-map token-approvals (tuple (token-id uint) (operator principal)) bool)
(define-map token-metadata uint (string-utf8 256))
(define-map token-hashes uint (string-utf8 128))

;; --------------------------
;; Helpers
;; --------------------------

(define-private (is-admin)
  (is-eq tx-sender (var-get admin))
)

(define-private (ensure-not-paused)
  (asserts! (not (var-get paused)) (err ERR-PAUSED))
)

(define-private (is-token-owner (token-id uint))
  (is-eq (unwrap-panic (map-get? token-owners token-id)) tx-sender)
)

;; --------------------------
;; Admin functions
;; --------------------------

(define-public (set-paused (pause bool))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (var-set paused pause)
    (ok pause)
  )
)

(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (asserts! (not (is-eq new-admin 'SP000000000000000000002Q6VF78)) (err ERR-ZERO-ADDRESS))
    (var-set admin new-admin)
    (ok true)
  )
)

;; --------------------------
;; NFT Core
;; --------------------------

(define-public (mint (recipient principal) (metadata string-utf8 256) (hash string-utf8 128))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (asserts! (not (is-eq recipient 'SP000000000000000000002Q6VF78)) (err ERR-ZERO-ADDRESS))
    (ensure-not-paused)
    (let ((token-id (+ (var-get total-supply) u1)))
      (map-set token-owners token-id recipient)
      (map-set token-metadata token-id metadata)
      (map-set token-hashes token-id hash)
      (var-set total-supply token-id)
      (ok token-id)
    )
  )
)

(define-public (transfer (token-id uint) (to principal))
  (begin
    (ensure-not-paused)
    (asserts! (not (is-eq to 'SP000000000000000000002Q6VF78)) (err ERR-ZERO-ADDRESS))
    (asserts! (is-token-owner token-id) (err ERR-NOT-OWNER))
    (map-set token-owners token-id to)
    (ok true)
  )
)

(define-public (approve (token-id uint) (operator principal))
  (begin
    (asserts! (is-token-owner token-id) (err ERR-NOT-OWNER))
    (map-set token-approvals (tuple (token-id token-id) (operator operator)) true)
    (ok true)
  )
)

(define-public (revoke-approval (token-id uint) (operator principal))
  (begin
    (asserts! (is-token-owner token-id) (err ERR-NOT-OWNER))
    (map-delete token-approvals (tuple (token-id token-id) (operator operator)))
    (ok true)
  )
)

;; --------------------------
;; Read-only
;; --------------------------

(define-read-only (get-owner (token-id uint))
  (match (map-get? token-owners token-id)
    owner (ok owner)
    (err ERR-TOKEN-NOT-FOUND)
  )
)

(define-read-only (get-metadata (token-id uint))
  (match (map-get? token-metadata token-id)
    meta (ok meta)
    (err ERR-TOKEN-NOT-FOUND)
  )
)

(define-read-only (get-hash (token-id uint))
  (match (map-get? token-hashes token-id)
    hash (ok hash)
    (err ERR-TOKEN-NOT-FOUND)
  )
)

(define-read-only (get-total-supply)
  (ok (var-get total-supply))
)

(define-read-only (get-admin)
  (ok (var-get admin))
)

(define-read-only (is-approved (token-id uint) (operator principal))
  (ok (is-some (map-get? token-approvals (tuple (token-id token-id) (operator operator)))))
)

(define-read-only (is-paused)
  (ok (var-get paused))
)
