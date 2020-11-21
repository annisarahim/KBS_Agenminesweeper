
(defrule start
    (declare(salience 500))
    ?init <- (initial-fact)
    ?tile0 <-(score 0 0 0)
;     ?b <- (bomb 1 ?x)
    =>
    (retract ?init)
    (retract ?tile0)
    (assert (probed 0 0 0))
    (printout t "LOHAAA SELAMAT DATANG" crlf)
    
    
    )

(deffacts board
;inisiasi fakta awal
    (bomb 1 2 )
    (bomb 2 2 )
    (total_bomb 2 )
    (score 0 0 0 )
    (score 1 0 0 )
    (score 2 0 0 )
    (score 0 1 1 )
    (score 1 1 2 )
    (score 2 1 2 )
    (score 0 2 1 )
    (board 3 3)
)

(defrule probe-start
; Ini buat buka pertama kali
    (probed 0 0 0)
    ?tr <-(score 1 0 ?s1)
    ?td <-(score 0 1 ?s2)
    ?trd <-(score 1 1 ?s3)

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
; Ini buat ngebuka sekitar tile yg score 0
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
    (assert (has-cek-probe ?x ?y))
)

(defrule probe
    ?del_can <- (can_probe ?x ?y)
    ?del_score <- (score ?x ?y ?n)

    =>
    (retract ?del_can)
    (retract ?del_score)
    (assert (probe ?x ?y ?n))
    (printout t "hapuss score"?x ?y crlf)

)


