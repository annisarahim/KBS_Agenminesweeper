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
        (assert(probed ?x1 ?y1 ?n))
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