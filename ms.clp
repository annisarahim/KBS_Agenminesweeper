; DELETE FACTS DIBAWAH INI DULU KL MAU JALANIN PAKE PYTHONN
; (deffacts board
;     (board 4 4)
;     (total_bomb 2)
;     (total_flag 0)
;     (closed 2 1 -1)
;     (closed 3 2 -1)
;     (closed 0 0 0)
;     (closed 0 1 0)
;     (closed 0 2 0)
;     (closed 0 3 0)
;     (closed 1 0 1)
;     (closed 1 1 1)
;     (closed 1 2 1)
;     (closed 1 3 0)
;     (closed 2 0 1)
;     (closed 2 2 2)
;     (closed 2 3 1)
;     (closed 3 0 1)
;     (closed 3 1 2)
;     (closed 3 3 1)
;     (around_flag 0 0 0)
;     (around_closed 0 0 0)
;     (around_flag 0 1 0)
;     (around_closed 0 1 0)
;     (around_flag 0 2 0)
;     (around_closed 0 2 0)
;     (around_flag 0 3 0)
;     (around_closed 0 3 0)
;     (around_flag 1 0 0)
;     (around_closed 1 0 0)
;     (around_flag 1 1 0)
;     (around_closed 1 1 0)
;     (around_flag 1 2 0)
;     (around_closed 1 2 0)
;     (around_flag 1 3 0)
;     (around_closed 1 3 0)
;     (around_flag 2 0 0)
;     (around_closed 2 0 0)
;     (around_flag 2 1 0)
;     (around_closed 2 1 0)
;     (around_flag 2 2 0)
;     (around_closed 2 2 0)
;     (around_flag 2 3 0)
;     (around_closed 2 3 0)
;     (around_flag 3 0 0)
;     (around_closed 3 0 0)
;     (around_flag 3 1 0)
;     (around_closed 3 1 0)
;     (around_flag 3 2 0)
;     (around_closed 3 2 0)
;     (around_flag 3 3 0)
;     (around_closed 3 3 0)
; )

(defrule start
    (declare(salience 500))
    ?init <- (initial-fact)
    ?tile0 <- (closed 0 0 0)
    =>
    (retract ?init)
    (retract ?tile0)
    (assert (probed 0 0 0))
    (printout t "LOHAAA SELAMAT DATANG" crlf)
    (printout t "" crlf)
)

(defrule probe-start
; Membuka pertama kali dari posisi (0, 0)
; not_cek_probe = tile belum di cek apakah tile sekitarnya dapat lanjut dibuka atau tidak
; STEPS :
; 1. Buka posisi (1,0) (0,1) (1,1)
; 2. Posisi akan masuk ke probe-zero apabila score posisi tsb = 0
    (probed 0 0 0)
    ?tr <-(closed 1 0 ?s1)
    ?td <-(closed 0 1 ?s2)
    ?trd <-(closed 1 1 ?s3)

    =>
    (retract ?tr)
    (assert (probed 1 0 ?s1))
    (assert (not_cek_probe 1 0))

    (retract ?td)
    (assert (probed 0 1 ?s2))
    (assert (not_cek_probe 0 1))

    (retract ?trd)
    (assert (probed 1 1 ?s3))
    (assert (not_cek_probe 1 1))

    (printout t "rule probe-start jalan" crlf)
)

(defrule probe-zero
; Lanjutan dari probe-start
; Menandakan tile sekitar yang dapat dibuka (memastikan tidak keluar dari board_size) 
; dari tile bernilai 0 yang sudah dibuka sebelumnya
; can_probe = tile yang dapat dibuka, selanjutnya dibuka oleh rule probe
; has_cek_probe = tile sudah dicek dan sudah ditandai juga tile sekitarnya yang dapat dibuka

; Ini dia udah bisa ngejalanin semua yang nilai nya 0
; Masih belum bisa bagian syntax(score (+ ?x 1) ?y ?s)
; Gabisa masukin (+ ?x 1) ke dalam variabel jadi bingung akses rulenya gimana
    (declare (salience 20))
    ?tilecek_zero <- (probed ?x ?y 0)
    ?board <- (board ?xb ?yb)
    ?cek <- (not_cek_probe ?x ?y)
    =>
    (bind ?xleft (- ?x 1))
    (bind ?xright (+ ?x 1))
    (bind ?ydown (+ ?y 1))
    (bind ?yup (- ?y 1))

    ; sudut kanan atas
    (if (and (eq ?x (- ?xb 1)) (eq ?y 0))
        then
            (assert (can_probe ?xleft ?y))
            (assert (can_probe ?xleft ?ydown))
            (assert (can_probe ?x ?ydown))

            (printout t "kanan atas"?x ?y crlf)
        )
    ; sudut kanan bawah
    (if (and (eq ?x (- ?xb 1)) (eq ?y (- ?yb 1)))
        then
            (assert (can_probe ?xleft ?y))
            (assert (can_probe ?xleft ?yup))
            (assert (can_probe ?x ?yup))

            (printout t "kanan bawah"?x ?y crlf)
        )
    ; sudut kiri bawah
    (if (and (eq ?x 0) (eq ?y (- ?yb 1)))
        then
            (assert (can_probe ?xright ?y))
            (assert (can_probe ?xright ?yup))
            (assert (can_probe ?x ?yup))

            (printout t "kiri bawah"?x ?y crlf)
        )
    ; sudut kiri atas
    (if (and (eq ?x 0) (eq ?y 0))
        then
            (assert (can_probe ?xright ?y))
            (assert (can_probe ?xright ?ydown))
            (assert (can_probe ?x ?ydown))

            (printout t "kiri atas"?x ?y crlf)
        )
    ; bawah
    (if (and (neq ?x (- ?xb 1)) (and (neq ?x 0) (eq ?y (- ?yb 1))))
        then
            (assert (can_probe ?xright ?y))
            (assert (can_probe ?xright ?yup))
            (assert (can_probe ?x ?yup))
            (assert (can_probe ?xleft ?y))
            (assert (can_probe ?xleft ?yup))

            (printout t "bawah" ?x ?y crlf)
        )

    ; sisi kiri
    (if (and (neq ?y 0) (and (neq ?y (- ?yb 1)) (eq ?x 0)))
    then
        (assert (can_probe ?xright ?y))
        (assert (can_probe ?xright ?ydown))
        (assert (can_probe ?x ?ydown))
        (assert (can_probe ?xright ?yup))
        (assert (can_probe ?x ?yup))

        (printout t "kiri"?x ?y crlf)
    )

    ; atas
    (if (and (neq ?x (- ?xb 1)) (and (neq ?x 0) (eq ?y 0)))
        then
            (assert (can_probe ?xright ?y))
            (assert (can_probe ?xright ?ydown))
            (assert (can_probe ?x ?ydown))
            (assert (can_probe ?xleft ?y))
            (assert (can_probe ?xleft ?ydown))


            (printout t "atas"?x ?y crlf)
        )
    
    ; sisi kanan
    (if (and (neq ?y 0) (and (neq ?y (- ?yb 1)) (eq ?x (- ?xb 1))))
    
        then
            (assert (can_probe ?xleft ?y))
            (assert (can_probe ?xleft ?yup))
            (assert (can_probe ?x ?yup))
            (assert (can_probe ?xleft ?ydown))
            (assert (can_probe ?x ?ydown))

            (printout t "sisi kanan" ?x ?y crlf)
    )

    ; tengah
    (if (and (neq ?x 0) (and (neq ?y 0) (and (neq ?y (- ?yb 1)) (neq ?x (- ?xb 1)))))
    
        then
            (assert (can_probe ?xright ?y))
            (assert (can_probe ?xright ?ydown))
            (assert (can_probe ?x ?ydown))
            (assert (can_probe ?xleft ?y))
            (assert (can_probe ?xleft ?ydown))
            (assert (can_probe ?xright ?yup))
            (assert (can_probe ?x ?yup))
            (assert (can_probe ?xleft ?yup))


            (printout t "tengah"?x ?y crlf)
    )
    (retract ?cek)
;   (assert (has_cek_probe ?x ?y))
)

(defrule probe
; Lanjutan dari probe-zero
; Tile can_probe dibuka dan dilengkapi dengan score yang sesuai
    (declare(salience 20))
    ?del_can <- (can_probe ?x ?y)
    ?del_score <- (closed ?x ?y ?n)
    =>
    (retract ?del_can)
    (retract ?del_score)
    (assert (probed ?x ?y ?n))
    (assert (not_cek_probe ?x ?y))
    (printout t "hapuss score"?x ?y crlf)
)

(defrule aksi-1
; Aksi untuk kondisi 1
; Jika jumlah tile yang tertutup disekitar tile dengan score n > 0
; masih lebih besar daripada jumlah tile yang di tandai (flag)
; maka, tandai semua tile yang tertutup dan belum di-flag
    (declare (salience -1))
    (probed ?x ?y ?n)
    ?f1 <- (around_closed ?x ?y ?n_close)
    ?f2 <- (around_flag ?x ?y ?n_flag)
    (test (= ?n_close (- ?n ?n_flag)))
    (test (> ?n 0))
    (test (> ?n_close 0))
    =>
    (assert (flag_remaining ?x ?y))
)
(defrule aksi-2
; Aksi untuk kondisi 2
; Jika jumlah tile yang di-flag disekitar tile sama dengan score n > 0
; sama daripada jumlah tile yang di tandai (flag)
; maka, tandai semua tile yang tertutup dan belum di-flag
    (declare (salience -1))
    (probed ?x ?y ?n)
    ?f1 <- (around_closed ?x ?y ?n_close)
    ?f2 <- (around_flag ?x ?y ?n_flag)
    (test (= ?n_flag ?n))
    (test (> ?n_close 0))
    =>
    (assert (probe_remaining ?x ?y))
)

(defrule clean-can_probe
	?f1 <- (can_probe ?x ?y)
	(probed ?x ?y ?n)
	=>
	(retract ?f1)
)

(defrule update_probe
	(probed ?x ?y ?n)
    (test (> ?n 0))
	=>
	(assert (update_sekitar ?x ?y))
)

(defrule clean-not_cek_probe
	?f1 <- (not_cek_probe ?x ?y)
	(probed ?x ?y ?n)
	(test (neq ?n 0))
	=>
	(retract ?f1)
)

(defrule clean-around_closed
	?f1 <- (around_closed ?x ?y 0)
	(probed ?x ?y 0)
	=>
	(retract ?f1)
)

(defrule clean-around_flag
	?f1 <- (around_flag ?x ?y 0)
	(probed ?x ?y 0)
	=>
	(retract ?f1)
)

(defrule update
    (declare (salience 10))
    ?a <- (please_update ?x ?y)
    (board ?xb ?yb)
	?f1 <- (around_closed ?x ?y ?m)
    ?f2 <- (around_flag ?x ?y ?o)
	;(test (neq ?n 0))
 ;   (test (eq ?m 0))
  ;  (test (eq ?o 0))
	=>
	(bind ?xleft (- ?x 1))
    (bind ?xright (+ ?x 1))
    (bind ?ydown (+ ?y 1))
    (bind ?yup (- ?y 1))
    (retract ?a)
    (retract ?f1)
    (retract ?f2)
    (assert (around_closed ?x ?y 0))
    (assert (around_flag ?x ?y 0))

    ; sudut kanan atas
    (if (and (eq ?x (- ?xb 1)) (eq ?y 0))
        then
            (assert (cek_close ?x ?y ?xleft ?y))
            (assert (cek_close ?x ?y ?xleft ?ydown))
            (assert (cek_close ?x ?y ?x ?ydown))
            (assert (cek_flag ?x ?y ?xleft ?y))
            (assert (cek_flag ?x ?y ?xleft ?ydown))
            (assert (cek_flag ?x ?y ?x ?ydown))
        )
    ; sudut kanan bawah
    (if (and (eq ?x (- ?xb 1)) (eq ?y (- ?yb 1)))
        then
            (assert (cek_close ?x ?y ?xleft ?y))
            (assert (cek_close ?x ?y ?xleft ?yup))
            (assert (cek_close ?x ?y ?x ?yup))
            (assert (cek_flag ?x ?y ?xleft ?y))
            (assert (cek_flag ?x ?y ?xleft ?yup))
            (assert (cek_flag ?x ?y ?x ?yup))
        )
    ; sudut kiri bawah
    (if (and (eq ?x 0) (eq ?y (- ?yb 1)))
        then
            (assert (cek_close ?x ?y ?xright ?y))
            (assert (cek_close ?x ?y ?xright ?yup))
            (assert (cek_close ?x ?y ?x ?yup))
            (assert (cek_flag ?x ?y ?xright ?y))
            (assert (cek_flag ?x ?y ?xright ?yup))
            (assert (cek_flag ?x ?y ?x ?yup))
        )
    ; sudut kiri atas
    (if (and (eq ?x 0) (eq ?y 0))
        then
            (assert (cek_close ?x ?y ?xright ?y))
            (assert (cek_close ?x ?y ?xright ?ydown))
            (assert (cek_close ?x ?y ?x ?ydown))
            (assert (cek_flag ?x ?y ?xright ?y))
            (assert (cek_flag ?x ?y ?xright ?ydown))
            (assert (cek_flag ?x ?y ?x ?ydown))
    )
    ; bawah
    (if (and (neq ?x (- ?xb 1)) (and (neq ?x 0) (eq ?y (- ?yb 1))))
        then
            (assert (cek_close ?x ?y ?xright ?y))
            (assert (cek_close ?x ?y ?xright ?yup))
            (assert (cek_close ?x ?y ?x ?yup))
            (assert (cek_close ?x ?y ?xleft ?y))
            (assert (cek_close ?x ?y ?xleft ?yup))
            (assert (cek_flag ?x ?y ?xright ?y))
            (assert (cek_flag ?x ?y ?xright ?yup))
            (assert (cek_flag ?x ?y ?x ?yup))
            (assert (cek_flag ?x ?y ?xleft ?y))
            (assert (cek_flag ?x ?y ?xleft ?yup))
    )
    ; sisi kiri
    (if (and (neq ?y 0) (and (neq ?y (- ?yb 1)) (eq ?x 0)))
    then
        (assert (cek_close ?x ?y ?xright ?y))
        (assert (cek_close ?x ?y ?xright ?ydown))
        (assert (cek_close ?x ?y ?x ?ydown))
        (assert (cek_close ?x ?y ?xright ?yup))
        (assert (cek_close ?x ?y ?x ?yup))
        (assert (cek_flag ?x ?y ?xright ?y))
        (assert (cek_flag ?x ?y ?xright ?ydown))
        (assert (cek_flag ?x ?y ?x ?ydown))
        (assert (cek_flag ?x ?y ?xright ?yup))
        (assert (cek_flag ?x ?y ?x ?yup))
    )
    ; atas
    (if (and (neq ?x (- ?xb 1)) (and (neq ?x 0) (eq ?y 0)))
        then
            (assert (cek_close ?x ?y ?xright ?y))
            (assert (cek_close ?x ?y ?xright ?ydown))
            (assert (cek_close ?x ?y ?x ?ydown))
            (assert (cek_close ?x ?y ?xleft ?y))
            (assert (cek_close ?x ?y ?xleft ?ydown))
            (assert (cek_flag ?x ?y ?xright ?y))
            (assert (cek_flag ?x ?y ?xright ?ydown))
            (assert (cek_flag ?x ?y ?x ?ydown))
            (assert (cek_flag ?x ?y ?xleft ?y))
            (assert (cek_flag ?x ?y ?xleft ?ydown))
    )
    ; sisi kanan
    (if (and (neq ?y 0) (and (neq ?y (- ?yb 1)) (eq ?x (- ?xb 1))))
        then
            (assert (cek_close ?x ?y ?xleft ?y))
            (assert (cek_close ?x ?y ?xleft ?yup))
            (assert (cek_close ?x ?y ?x ?yup))
            (assert (cek_close ?x ?y ?xleft ?ydown))
            (assert (cek_close ?x ?y ?x ?ydown))
            (assert (cek_flag ?x ?y ?xleft ?y))
            (assert (cek_flag ?x ?y ?xleft ?yup))
            (assert (cek_flag ?x ?y ?x ?yup))
            (assert (cek_flag ?x ?y ?xleft ?ydown))
            (assert (cek_flag ?x ?y ?x ?ydown))
    )
    ; tengah
    (if (and (neq ?x 0) (and (neq ?y 0) (and (neq ?y (- ?yb 1)) (neq ?x (- ?xb 1)))))
        then
            (assert (cek_close ?x ?y ?xright ?y))
            (assert (cek_close ?x ?y ?xright ?ydown))
            (assert (cek_close ?x ?y ?x ?ydown))
            (assert (cek_close ?x ?y ?xleft ?y))
            (assert (cek_close ?x ?y ?xleft ?ydown))
            (assert (cek_close ?x ?y ?xright ?yup))
            (assert (cek_close ?x ?y ?x ?yup))
            (assert (cek_close ?x ?y ?xleft ?yup))
            (assert (cek_flag ?x ?y ?xright ?y))
            (assert (cek_flag ?x ?y ?xright ?ydown))
            (assert (cek_flag ?x ?y ?x ?ydown))
            (assert (cek_flag ?x ?y ?xleft ?y))
            (assert (cek_flag ?x ?y ?xleft ?ydown))
            (assert (cek_flag ?x ?y ?xright ?yup))
            (assert (cek_flag ?x ?y ?x ?yup))
            (assert (cek_flag ?x ?y ?xleft ?yup))
    )
    
)

(defrule cek-close-true
    ?f1 <- (cek_close ?x ?y ?a ?b)
    ?f2 <- (around_closed ?x ?y ?n)
    (closed ?a ?b ?z)
    =>
    (bind ?n_close (+ ?n 1))
    (retract ?f1)
    (retract ?f2)
    (assert (around_closed ?x ?y ?n_close))
    
    (printout t ?x " " ?y " " ?a " " ?b  crlf)
)

(defrule cek-close-probed
    ?f1 <- (cek_close ?x ?y ?a ?b)
    (probed ?a ?b ?n)
    =>
    (retract ?f1)
)

(defrule cek-close-probed-1
    ?f1 <- (cek_close ?x ?y ?a ?b)
    (flag ?a ?b ?n)
    =>
    (retract ?f1)
)

(defrule cek-flag-true
    ?f1 <- (cek_flag ?x ?y ?a ?b)
    ?f2 <- (around_flag ?x ?y ?n)
    ?f3 <- (around_closed ?x ?y ?m)
    (flag ?a ?b ?z)
;    (test (> ?m 0))
    =>
    (bind ?n_flag (+ ?n 1))
 ;   (bind ?n_close (- ?m 1))
    (retract ?f1)
    (retract ?f2)
    (assert (around_flag ?x ?y ?n_flag))
;    (assert (around_closed ?x ?y ?n_close))
    (printout t ?x " " ?y " " ?a " " ?b  crlf)
)

(defrule cek-flag-probed
    ?f1 <- (cek_flag ?x ?y ?a ?b)
    (probed ?a ?b ?n)
    =>
    (retract ?f1)
)
(defrule cek-flag-probed-1
    ?f1 <- (cek_flag ?x ?y ?a ?b)
    (closed ?a ?b ?n)
    =>
    (retract ?f1)
)

;proberemaining
(defrule probe-kiri-atas
    ?f1 <- (probe_remaining ?x ?y)
    ?f2 <- (closed ?x1 ?y1 ?n)
    (not (flag ?x1 ?y1))
    (not (probed ?x1 ?y1))
    (test (= ?x1 (- ?x 1)))
    (test (= ?y1 (- ?y 1)))
    => 
    (if (and (>= ?x1 0) (>= ?y1 0))
    then
        (assert (probed ?x1 ?y1 ?n))
        (retract ?f2)
        (printout t "kiri atas probed " ?x1 ?y1 crlf)
    )
)

(defrule probe-kiri-tengah
    ?f1 <- (probe_remaining ?x ?y)
    ?f2 <- (closed ?x1 ?y1 ?n)
    (not (flag ?x1 ?y1))
    (not (probed ?x1 ?y1))
    (test (= ?x1 (- ?x 1)))
    (test (= ?y1 ?y))
    =>
    (if (>= ?x1 0)
    then
        (assert(probed ?x1 ?y1 ?n))
        (retract ?f2)
        (printout t "kiri tengah probed " ?x1 ?y1 crlf)

    )
)

(defrule probe-kiri-bawah
	  ?f1 <- (probe_remaining ?x ?y)
    ?f2 <- (closed ?x1 ?y1 ?n)
    ?f3 <- (board ?xb ?yb)
    (not (flag ?x1 ?y1))
    (not (probed ?x1 ?y1))
    (test (= ?x1 (- ?x 1)))
    (test (= ?y1 (+ ?y 1)))
    =>
    (if (and (>= ?x1 0) (< ?y1 ?yb)) 
    then
        (assert(probed ?x1 ?y1 ?n))
        (retract ?f2)
        (printout t "kiri bawah probed " ?x1 ?y1 crlf)
    )
)

(defrule probe-kanan-atas
    ?f1 <- (probe_remaining ?x ?y)
    ?f2 <- (closed ?x1 ?y1 ?n)
    ?f3 <- (board ?xb ?yb)
    (not (flag ?x1 ?y1))
    (not (probed ?x1 ?y1))
    (test (= ?x1 (+ ?x 1)))
    (test (= ?y1 (- ?y 1)))
    => 
    (if (and (< ?x1 ?xb) (>= ?y1 0))
    then
        (assert(probed ?x1 ?y1 ?n))
        (retract ?f2)
        (printout t "kanan atas probed " ?x1 ?y1 crlf)
    )
)

(defrule probe-kanan-tengah
	?f1 <- (probe_remaining ?x ?y)
    ?f2 <- (closed ?x1 ?y1 ?n)
    ?f3 <- (board ?xb ?yb)
    (not (flag ?x1 ?y1))
    (not (probed ?x1 ?y1))
    (test (= ?x1 (+ ?x 1)))
    (test (= ?y1 ?y))
    =>
    ;(bind ?right (+ ?x 1))
    (if (< ?x1 ?xb)
    then
        (assert(probed ?x1 ?y1 ?n))
        (retract ?f2)
        (printout t "kanan tengah probed " ?x1 ?y1 crlf)
    )
)

(defrule probe-kanan-bawah
	?f1 <- (probe_remaining ?x ?y)
    ?f2 <- (closed ?x1 ?y1 ?n)
    ?f3 <- (board ?xb ?yb)
    (not (flag ?x1 ?y1))
    (not (probed ?x1 ?y1))
    (test (= ?x1 (+ ?x 1)))
    (test (= ?y1 (+ ?y 1)))
    =>
    (if (and (< ?x1 ?xb) (< ?y1 ?yb))
    then
        (assert(probed ?x1 ?y1 ?n))
        (retract ?f2)
        (printout t "kanan bawah probed " ?x1 ?y1 crlf)
    )
)

(defrule probe-tengah-atas
    ?f1 <- (probe_remaining ?x ?y)
    ?f2 <- (closed ?x1 ?y1 ?n)
    ?f3 <- (board ?xb ?yb)
    (not (flag ?x1 ?y1))
    (not (probed ?x1 ?y1))
    (test (= ?x1 ?x))
    (test (= ?y1 (- ?y 1)))
    =>
    (if (>= ?y1 0)
    then
        (assert(probed ?x1 ?y1 ?n))
        (retract ?f2)
        (printout t "tengah atas probed " ?x1 ?y1 crlf)
    )
)

(defrule probe-tengah-bawah
	?f1 <- (probe_remaining ?x ?y)
    ?f2 <- (closed ?x1 ?y1 ?n)
    ?f3 <- (board ?xb ?yb)
    (not (flag ?x1 ?y1))
    (not (probed ?x1 ?y1))
    (test (= ?x1 ?x))
    (test (= ?y1 (+ ?y 1)))
    =>
    (if (< ?y1 ?yb) 
    then
        (assert(probed ?x1 ?y1 ?n))
        (retract ?f2)
        (printout t "tengah bawah probed " ?x1 ?y1 crlf)
    )
)

(defrule retract-proberemaining
    (declare (salience -20))
    ?f1 <- (probe_remaining ?x ?y)
    =>
    (retract ?f1)
)

(defrule flag_remain
    ?sisa <- (flag_remaining ?x ?y)
;    ?sekitar <- (around_flag ?x ?y ?n)
    ?tutup <- (closed ?cekx ?ceky ?z)
    ?total <- (total_flag ?t)
;    ?sekitar_tutup <- (around_closed ?x ?y ?a)
    (not (flag ?cekx ?ceky ?z))
    =>

    ;ini kondisi -> lg ngecek bagian mana dari tile sekarang 
    ;atas
    (if (or (and (eq ?cekx (+ ?x 1)) (eq ?ceky (- ?y 1))) ;atas-kanan
    (or (and (eq ?cekx (- ?x 1)) (eq ?ceky (- ?y 1))) ;atas-kiri
    (and (eq ?cekx ?x) (eq ?ceky (- ?y 1))))) ;atas-tengah
        then
;            (retract ?sekitar)
;            (retract ?sekitar_tutup)
            (retract ?tutup)
            (retract ?sisa)
            (retract ?tutup)
            (assert (flag ?cekx ?ceky ?z))
;            (assert (around_flag ?x ?y (+ ?n 1)))
            (retract ?total)
            (assert (total_flag (+ ?t 1)))
;            (assert (around_closed ?x ?y (- ?a 1)))
            (assert (update_sekitar ?cekx ?ceky))

            (printout t "Bagian Atas" ?x ?y crlf)
    )

    ;sejajar
    (if (or (and (eq ?cekx (- ?x 1)) (eq ?ceky ?y)) ;sejajar-kiri
    (and (eq ?cekx (+ ?x 1)) (eq ?ceky ?y))) ;sejajar-kanan
        then
;            (retract ?sekitar)
;            (retract ?sekitar_tutu
            (retract ?tutup)
            (retract ?sisa)
            (assert (flag ?cekx ?ceky ?z))
;            (assert (around_flag ?x ?y (+ ?n 1)))
            (assert (total_flag (+ ?t 1)))
;            (assert (around_closed ?x ?y (- ?a 1)))
            (assert (update_sekitar ?cekx ?ceky))
            (retract ?tutup)
            (retract ?total)

            (printout t "Sejajar" ?x ?y crlf)
    )

    ;bawah
    (if (or (and (eq ?cekx (+ ?x 1)) (eq ?ceky (+ ?y 1))) ;bawah-kanan
    (or (and (eq ?cekx (- ?x 1)) (eq ?ceky (+ ?y 1))) ;bawah-kiri
    (and (eq ?cekx ?x) (eq ?ceky (+ ?y 1))))) ;bawah-tengah
        then
;            (retract ?sekitar)
;            (retract ?sekitar_tutup)
            (retract ?tutup)
            (retract ?sisa)
            (assert (flag ?cekx ?ceky ?z))
;            (assert (around_flag ?x ?y (+ ?n 1)))
            (assert (total_flag (+ ?t 1)))
;            (assert (around_closed ?x ?y (- ?a 1)))
            (assert (update_sekitar ?cekx ?ceky))
            (retract ?tutup)
            (retract ?total)

            (printout t "Bawah" ?x ?y crlf)
    )
)

(defrule update-sekitar-kanan-atas
    (declare (salience -1))
    (update_sekitar ?x ?y)
    (probed ?cekx ?ceky ?n_close)
    (test (eq ?cekx (+ ?x 1)))
    (test (eq ?ceky (- ?y 1)))
    =>
    (assert (please_update ?cekx ?ceky))
)

(defrule update-sekitar-kanan-atas-1
    (declare (salience -1))
    (update_sekitar ?x ?y)
    (flag ?cekx ?ceky ?n_close)
    (test (eq ?cekx (+ ?x 1)))
    (test (eq ?ceky (- ?y 1)))
    =>
    (assert (please_update ?cekx ?ceky))
)

(defrule update-sekitar-tengah-atas
    (declare (salience -1))
    (update_sekitar ?x ?y)
    (probed ?cekx ?ceky ?n_close)
    (test (eq ?cekx ?x))
    (test (eq ?ceky (- ?y 1)))
    =>
    (assert (please_update ?cekx ?ceky))
)

(defrule update-sekitar-tengah-atas-1
    (declare (salience -1))
    (update_sekitar ?x ?y)
    (flag ?cekx ?ceky ?n_close)
    (test (eq ?cekx ?x))
    (test (eq ?ceky (- ?y 1)))
    =>
    (assert (please_update ?cekx ?ceky))
)

(defrule update-sekitar-kiri-atas
    (declare (salience -1))
    (update_sekitar ?x ?y)
    (probed ?cekx ?ceky ?n_close)
    (test (eq ?cekx (- ?x 1)))
    (test (eq ?ceky (- ?y 1)))
    =>
    (assert (please_update ?cekx ?ceky))
)

(defrule update-sekitar-kiri-atas-1
    (declare (salience -1))
    (update_sekitar ?x ?y)
    (flag ?cekx ?ceky ?n_close)
    (test (eq ?cekx (- ?x 1)))
    (test (eq ?ceky (- ?y 1)))
    =>
    (assert (please_update ?cekx ?ceky))
)

(defrule update-sekitar-kiri
    (declare (salience -1))
    (update_sekitar ?x ?y)
    (probed ?cekx ?ceky ?n_close)
    (test (eq ?cekx (- ?x 1)))
    (test (eq ?ceky ?y))
    =>
    (assert (please_update ?cekx ?ceky))
)

(defrule update-sekitar-kiri-1
    (declare (salience -1))
    (update_sekitar ?x ?y)
    (flag ?cekx ?ceky ?n_close)
    (test (eq ?cekx (- ?x 1)))
    (test (eq ?ceky ?y))
    =>
    (assert (please_update ?cekx ?ceky))
)

(defrule update-sekitar-kanan
    (declare (salience -1))
    (update_sekitar ?x ?y)
    (flag ?cekx ?ceky ?n_close)
    (test (eq ?cekx (+ ?x 1)))
    (test (eq ?ceky ?y))
    =>
    (assert (please_update ?cekx ?ceky))
)

(defrule update-sekitar-kanan-1
    (declare (salience -1))
    (update_sekitar ?x ?y)
    (probed ?cekx ?ceky ?n_close)
    (test (eq ?cekx (+ ?x 1)))
    (test (eq ?ceky ?y))
    =>
    (assert (please_update ?cekx ?ceky))
)

(defrule update-sekitar-kanan-bawah
    (declare (salience -1))
    (update_sekitar ?x ?y)
    (probed ?cekx ?ceky ?n_close)
    (test (eq ?cekx (+ ?x 1)))
    (test (eq ?ceky (+ ?y 1)))
    =>
    (assert (please_update ?cekx ?ceky))
)

(defrule update-sekitar-kanan-bawah-1
    (declare (salience -1))
    (update_sekitar ?x ?y)
    (flag ?cekx ?ceky ?n_close)
    (test (eq ?cekx (+ ?x 1)))
    (test (eq ?ceky (+ ?y 1)))
    =>
    (assert (please_update ?cekx ?ceky))
)

(defrule update-sekitar-tengah-bawah
    (declare (salience -1))
    (update_sekitar ?x ?y)
    (flag ?cekx ?ceky ?n_close)
    (test (eq ?cekx ?x))
    (test (eq ?ceky (+ ?y 1)))
    =>
    (assert (please_update ?cekx ?ceky))
)

(defrule update-sekitar-tengah-bawah-1
    (declare (salience -1))
    (update_sekitar ?x ?y)
    (probed ?cekx ?ceky ?n_close)
    (test (eq ?cekx ?x))
    (test (eq ?ceky (+ ?y 1)))
    =>
    (assert (please_update ?cekx ?ceky))
)

(defrule update-sekitar-kiri-bawah
    (declare (salience -1))
    (update_sekitar ?x ?y)
    (probed ?cekx ?ceky ?n_close)
    (test (eq ?cekx (- ?x 1)))
    (test (eq ?ceky (+ ?y 1)))
    =>
    (assert (please_update ?cekx ?ceky))
)

(defrule update-sekitar-kiri-bawah-1
    (declare (salience -1))
    (update_sekitar ?x ?y)
    (flag ?cekx ?ceky ?n_close)
    (test (eq ?cekx (- ?x 1)))
    (test (eq ?ceky (+ ?y 1)))
    =>
    (assert (please_update ?cekx ?ceky))
)

(defrule retract-updatesekitar
    (declare (salience -20))
    ?f1 <- (update_sekitar ?x ?y)
    =>
    (retract ?f1)
)


(defrule retract-please_update
    (declare (salience -20))
    ?f1 <- (please_update ?x ?y)
    (probed ?x ?y 0)
    =>
    (retract ?f1)
)

(defrule winning
    (declare (salience -20))
    (total_bomb ?x)
    (total_flag ?y)
    (test (eq ?x ?y))
    =>
    (assert (win))
    (printout t "YEYYY MENANG" crlf)
    (printout t "" crlf)
)

(defrule kalah
    (declare (salience -20))
    (probed ?x ?y -1)
    =>
    (assert (kalah))
    (printout t ":( KALAH" crlf)
    (printout t "" crlf)
)
    

;     (bind ?xleft (- ?x 1))
;     (bind ?xright (+ ?x 1))
;     (bind ?ydown (+ ?y 1))
;     (bind ?yup (- ?y 1))
;     (retract ?f1)

;     (if (and (or (> ?xleft 0) (< ?xright ?xb)) (> ?yup 0))
;     then 
;         (assert (please_update ?x ?yup))
;         (assert (please_update ?xright ?yup))
;         (assert (please_update ?xleft ?yup))
;     )

;     (if (and (or (> ?xleft 0) (< ?xright ?xb)) (< ?ydown ?yb))
;     then
;         (assert (please_update ?xright ?ydown))
;         (assert (please_update ?x ?ydown))
;         (assert (please_update ?xleft ?ydown))
;     )

;     (if (or (> ?xleft 0) (< ?xright ?xb))
;     then 
;         (assert (please_update ?xleft ?y))
;         (assert (please_update ?xright ?y))
;     )
; )