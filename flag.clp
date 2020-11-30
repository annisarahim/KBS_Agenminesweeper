;kalo sebelumnya udah ada yang di flag, maka around_flag ga 0
;variable buat yang ketutup masih pake closed
;soalnya kl pake not probed belum bisa gatau kenapa:(

(defrule flag_remain
    (declare (salience 500))
    ?sisa <- (flag_remaining ?x ?y)
    ?sekitar <- (around_flag ?x ?y ?n)
    ?tutup <- (closed ?cekx ?ceky ?z)
    ?total <- (total_flag ?t)
    ?sekitar_tutup <- (around_closed ?x ?y ?a)
    (not (flag ?cekx ?ceky ?z))
    =>

    ;ini kondisi -> lg ngecek bagian mana dari tile sekarang 
    ;atas
    (if (or (and (eq ?cekx (+ ?x 1)) (eq ?ceky (- ?y 1))) ;atas-kanan
    (or (and (eq ?cekx (- ?x 1)) (eq ?ceky (- ?y 1))) ;atas-kiri
    (and (eq ?cekx ?x) (eq ?ceky (- ?y 1))))) ;atas-tengah
        then
            (retract ?sekitar)
            (retract ?sekitar_tutup)
            (assert (flag ?cekx ?ceky ?z))
            (assert (around_flag ?x ?y (+ ?n 1)))
            (assert (total_flag (+ ?t 1)))
            (assert (around_closed ?x ?y (- ?a 1)))

            (printout t "Bagian Atas" ?x ?y crlf)
    )

    ;sejajar
    (if (or (and (eq ?cekx (- ?x 1)) (eq ?ceky ?y)) ;sejajar-kiri
    (and (eq ?cekx (+ ?x 1)) (eq ?ceky ?y))) ;sejajar-kanan
        then
            (retract ?sekitar)
            (retract ?sekitar_tutup)
            (assert (flag ?cekx ?ceky ?z))
            (assert (around_flag ?x ?y (+ ?n 1)))
            (assert (total_flag (+ ?t 1)))
            (assert (around_closed ?x ?y (- ?a 1)))

            (printout t "Sejajar" ?x ?y crlf)
    )

    ;bawah
    (if (or (and (eq ?cekx (+ ?x 1)) (eq ?ceky (+ ?y 1))) ;bawah-kanan
    (or (and (eq ?cekx (- ?x 1)) (eq ?ceky (+ ?y 1))) ;bawah-kiri
    (and (eq ?cekx ?x) (eq ?ceky (+ ?y 1))))) ;bawah-tengah
        then
            (retract ?sekitar)
            (retract ?sekitar_tutup)
            (assert (flag ?cekx ?ceky ?z))
            (assert (around_flag ?x ?y (+ ?n 1)))
            (assert (total_flag (+ ?t 1)))
            (assert (around_closed ?x ?y (- ?a 1)))

            (printout t "Bawah" ?x ?y crlf)
    )

)


(deffacts facts
    (flag_remaining 1 2)
    (around_flag 1 2 0)
    (closed 0 1)
    (closed 1 1)
    (closed 2 1)
    (closed 0 2)
    (closed 2 2)
    (closed 0 3)
    (closed 1 3)
    (closed 2 3)
    (total_flag 0)
    (initial-fact)
)