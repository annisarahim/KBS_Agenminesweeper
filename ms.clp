; DELETE FACTS DIBAWAH INI DULU KL MAU JALANIN PAKE PYTHONN
(deffacts board
    (board 4 4)
    (closed 2 1 -1)
    (closed 3 2 -1)
    (closed 0 0 0)
    (closed 0 1 0)
    (closed 0 2 0)
    (closed 0 3 0)
    (closed 1 0 1)
    (closed 1 1 1)
    (closed 1 2 1)
    (closed 1 3 0)
    (closed 2 0 1)
    (closed 2 2 2)
    (closed 2 3 1)
    (closed 3 0 1)
    (closed 3 1 2)
    (closed 3 3 1)
    (around_flag 0 0 0)
    (around_closed 0 0 0)
    (around_flag 0 1 0)
    (around_closed 0 1 0)
    (around_flag 0 2 0)
    (around_closed 0 2 0)
    (around_flag 0 3 0)
    (around_closed 0 3 0)
    (around_flag 1 0 0)
    (around_closed 1 0 0)
    (around_flag 1 1 0)
    (around_closed 1 1 0)
    (around_flag 1 2 0)
    (around_closed 1 2 0)
    (around_flag 1 3 0)
    (around_closed 1 3 0)
    (around_flag 2 0 0)
    (around_closed 2 0 0)
    (around_flag 2 1 0)
    (around_closed 2 1 0)
    (around_flag 2 2 0)
    (around_closed 2 2 0)
    (around_flag 2 3 0)
    (around_closed 2 3 0)
    (around_flag 3 0 0)
    (around_closed 3 0 0)
    (around_flag 3 1 0)
    (around_closed 3 1 0)
    (around_flag 3 2 0)
    (around_closed 3 2 0)
    (around_flag 3 3 0)
    (around_closed 3 3 0)
)

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
    ?del_can <- (can_probe ?x ?y)
    ?del_score <- (closed ?x ?y ?n)
    =>
    (retract ?del_can)
    (retract ?del_score)
    (assert (probed ?x ?y ?n))
    (assert (not_cek_probe ?x ?y))
    (printout t "hapuss score"?x ?y crlf)
)

;(defrule aksi-1
; Aksi untuk kondisi 1
; Jika jumlah tile yang tertutup disekitar tile dengan score n > 0
; masih lebih besar daripada jumlah tile yang di tandai (flag)
; maka, tandai semua tile yang tertutup dan belum di-flag
;    (probed ?x ?y ?n)
;    =>
;    (if )

;)

(defrule clean-can_probe
	?f1 <- (can_probe ?x ?y)
	(probed ?x ?y ?n)
	=>
	(retract ?f1)
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

(defrule update-around_closed
	(probed ?x ?y ?n)
    (board ?xb ?yb)
	(around_closed ?x ?y ?m)
	(test (neq ?n 0))
	(test (eq ?m 0))
	=>
	(bind ?xleft (- ?x 1))
    (bind ?xright (+ ?x 1))
    (bind ?ydown (+ ?y 1))
    (bind ?yup (- ?y 1))

    ; sudut kanan atas
    (if (and (eq ?x (- ?xb 1)) (eq ?y 0))
        then
            (assert (cek_close ?x ?y ?xleft ?y))
            (assert (cek_close ?x ?y ?xleft ?ydown))
            (assert (cek_close ?x ?y ?x ?ydown))
        )
    ; sudut kanan bawah
    (if (and (eq ?x (- ?xb 1)) (eq ?y (- ?yb 1)))
        then
            (assert (cek_close ?x ?y ?xleft ?y))
            (assert (cek_close ?x ?y ?xleft ?yup))
            (assert (cek_close ?x ?y ?x ?yup))
        )
    ; sudut kiri bawah
    (if (and (eq ?x 0) (eq ?y (- ?yb 1)))
        then
            (assert (cek_close ?x ?y ?xright ?y))
            (assert (cek_close ?x ?y ?xright ?yup))
            (assert (cek_close ?x ?y ?x ?yup))
        )
    ; sudut kiri atas
    (if (and (eq ?x 0) (eq ?y 0))
        then
            (assert (cek_close ?x ?y ?xright ?y))
            (assert (cek_close ?x ?y ?xright ?ydown))
            (assert (cek_close ?x ?y ?x ?ydown))
    )
    ; bawah
    (if (and (neq ?x (- ?xb 1)) (and (neq ?x 0) (eq ?y (- ?yb 1))))
        then
            (assert (cek_close ?x ?y ?xright ?y))
            (assert (cek_close ?x ?y ?xright ?yup))
            (assert (cek_close ?x ?y ?x ?yup))
            (assert (cek_close ?x ?y ?xleft ?y))
            (assert (cek_close ?x ?y ?xleft ?yup))
    )
    ; sisi kiri
    (if (and (neq ?y 0) (and (neq ?y (- ?yb 1)) (eq ?x 0)))
    then
        (assert (cek_close ?x ?y ?xright ?y))
        (assert (cek_close ?x ?y ?xright ?ydown))
        (assert (cek_close ?x ?y ?x ?ydown))
        (assert (cek_close ?x ?y ?xright ?yup))
        (assert (cek_close ?x ?y ?x ?yup))
    )
    ; atas
    (if (and (neq ?x (- ?xb 1)) (and (neq ?x 0) (eq ?y 0)))
        then
            (assert (cek_close ?x ?y ?xright ?y))
            (assert (cek_close ?x ?y ?xright ?ydown))
            (assert (cek_close ?x ?y ?x ?ydown))
            (assert (cek_close ?x ?y ?xleft ?y))
            (assert (cek_close ?x ?y ?xleft ?ydown))
    )
    ; sisi kanan
    (if (and (neq ?y 0) (and (neq ?y (- ?yb 1)) (eq ?x (- ?xb 1))))
        then
            (assert (cek_close ?x ?y ?xleft ?y))
            (assert (cek_close ?x ?y ?xleft ?yup))
            (assert (cek_close ?x ?y ?x ?yup))
            (assert (cek_close ?x ?y ?xleft ?ydown))
            (assert (cek_close ?x ?y ?x ?ydown))
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


;proberemaining
(defrule probe-kiri-atas
    ?f1 <- (probe_remaining ?x ?y)
    =>
    (bind ?left (- ?x 1))
    (bind ?up (- ?y 1)) 
    (assert(can_probe ?left ?up))
)

(defrule probe-kiri-tengah
	?f1 <- (probe_remaining ?x ?y)
    =>
    (bind ?left (- ?x 1))
    (assert(can_probe ?left ?y))
)

(defrule probe-kiri-bawah
	?f1 <- (probe_remaining ?x ?y)
    =>
    (bind ?left (- ?x 1))
    (bind ?down (+ ?y 1)) 
    (assert(can_probe ?left ?down))
)

(defrule probe-kanan-atas
	?f1 <- (probe_remaining ?x ?y)
    =>
    (bind ?right (+ ?x 1))
    (bind ?up (- ?y 1)) 
    (assert(can_probe ?right ?up))
)

(defrule probe-kanan-tengah
	?f1 <- (probe_remaining ?x ?y)
    =>
    (bind ?right (+ ?x 1))
    (assert(can_probe ?right ?y))
)

(defrule probe-kanan-bawah
	?f1 <- (probe_remaining ?x ?y)
    =>
    (bind ?right (+ ?x 1))
    (bind ?down (+ ?y 1)) 
    (assert(can_probe ?right ?down))
)

(defrule probe-tengah-atas
	?f1 <- (probe_remaining ?x ?y)
    =>
    (bind ?up (- ?y 1)) 
    (assert(can_probe ?x ?up))
)

(defrule probe-tengah-bawah
	?f1 <- (probe_remaining ?x ?y)
    =>
    (bind ?down (+ ?y 1)) 
    (assert(can_probe ?x ?down))
)