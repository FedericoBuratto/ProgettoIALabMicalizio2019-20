(defmodule KNOWONE (import MAIN ?ALL) (import ENV ?ALL) (import AGENT ?ALL)(export ?ALL))

;conoscendo la posizione i un quadrato di acqua 
;vado ad asserire (guessed (x ?x) (y ?y))


(defrule know-wather (declare (salience 1))
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y)(content water))
	(not (guessed (x ?x) (y ?y)))
	=>
	(assert(to-guess (x ?x) (y ?y)))
	(printout t "(know-wather)" crlf)
)


; si attiva quando conosciamo tutte le navi a parte l ultima di lunghezza 1 

(defrule know-last-one
	(status (step ?s)(currently running))
	?boats <- (closed-boats (one 3)(two 3)(three 2)(four 1))
	?row1 <- (k-per-row (row ?x) (num ?val-row1&:(eq ?val-row1 1)))
	?col1 <- (k-per-col (col ?y) (num ?val-col1&:(eq ?val-col1 1)))
	(not (guessed (x ?x) (y ?y)))
	=>
	(modify ?boats(one 4))
	(assert(to-guess (x ?x) (y ?y)))
	(assert(to-guess (x (- ?x 1))(y ?y)))
	(assert(to-guess (x (- ?x 1))(y (+ ?y 1))))
	(assert(to-guess (x (- ?x 1))(y (- ?y 1))))
	(assert(to-guess (x ?x)(y (- ?y 1))))
	(assert(to-guess (x ?x)(y (+ ?y 1))))
	(assert(to-guess (x (+ ?x 1))(y (- ?y 1))))
	(assert(to-guess (x (+ ?x 1))(y ?y)))
	(assert(to-guess (x (+ ?x 1))(y (+ ?y 1))))
	(assert(exec (step ?s) (action guess) (x ?x) (y ?y)))
	(printout t " (know-last-one) sub " ?x " " ?y crlf)
	(assert(return))
    (pop-focus)
)

;conosciendo la posizione di un sub vado ad asserire come guessed 
;il sub e tutti i blocchi che lo circondano poi vado a eseguire 
;l'azione di guess nella posizione del sub

(defrule know-sub 
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y) (content sub))
	(not (guessed (x ?x) (y ?y)))
	?boats <- (closed-boats (one ?o))
	?row1 <- (k-per-row (row ?x) (num ?val-row1))
	?col1 <- (k-per-col (col ?y) (num ?val-col1))
	=>
	(assert(to-guess (x ?x) (y ?y)))
	(assert(to-guess (x (- ?x 1))(y ?y)))
	(assert(to-guess (x (- ?x 1))(y (+ ?y 1))))
	(assert(to-guess (x (- ?x 1))(y (- ?y 1))))
	(assert(to-guess (x ?x)(y (- ?y 1))))
	(assert(to-guess (x ?x)(y (+ ?y 1))))
	(assert(to-guess (x (+ ?x 1))(y (- ?y 1))))
	(assert(to-guess (x (+ ?x 1))(y ?y)))
	(assert(to-guess (x (+ ?x 1))(y (+ ?y 1))))
	(modify ?boats(one (+ ?o 1)))
	(modify ?row1 (num (- ?val-row1 1)))
	(modify ?col1 (num (- ?val-col1 1)))
	(assert(exec (step ?s) (action guess) (x ?x) (y ?y)))
	(printout t " (know-sub) sub " ?x " " ?y crlf)
	(assert(return))
    (pop-focus)
)

;di seguito si trovano 12 regole che si attiveranno solamente nel momento in cui
;conosco un estremo di una nave e ho solo piu un sottoinsieme di navi
;(per esempio ho gia trovato tutte le navi lunghe 2 e 3 quindi avendo un estremo
; so per certo che quella nave sarà lunga 4)

(defrule start-know-bottom-only-two 
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y) (content bot))
	?row2 <- (k-per-row (row ?x1 &:(eq (- ?x 1) ?x1 ))(num ?val-row2))
	(closed-boats (two ?two-val&~3)(three 2) (four 1))
	(not(guessed (x ?x1) (y ?y)))
	?boats <- (closed-boats)
	?row1 <- (k-per-row (row ?x) (num ?val-row1))
	?col1 <- (k-per-col (col ?y) (num ?val-col1))
	=>
	(modify ?boats(two (+ ?two-val 1)))
	(modify ?row1 (num (- ?val-row1 1)))
	(modify ?row2(num (- ?val-row2 1)))
	(modify ?col1(num (- ?val-col1 2)))
	(assert(to-guess (x ?x)(y ?y)))
	(assert(to-guess (x ?x1)(y ?y)))
	(assert(to-guess (x (- ?x 2))(y ?y)))
	(assert(to-guess (x (- ?x 2))(y (+ ?y 1))))
	(assert(to-guess (x (- ?x 2))(y (- ?y 1))))
	(assert(to-guess (x (- ?x 1))(y (- ?y 1))))
	(assert(to-guess (x (- ?x 1))(y (+ ?y 1))))
	(assert(to-guess (x ?x)(y (- ?y 1))))
	(assert(to-guess (x ?x)(y (+ ?y 1))))
	(assert(to-guess (x (+ ?x 1))(y (- ?y 1))))
	(assert(to-guess (x (+ ?x 1))(y ?y)))
	(assert(to-guess (x (+ ?x 1))(y (+ ?y 1))))
	(printout t " (start-know-bottom-only-two) ho guessato come top " ?x1 " " ?y crlf)
	(assert(exec (step ?s) (action guess) (x (- ?x 1)) (y ?y )))
	(assert (ausiliar-exec (action guess) (x ?x)(y ?y)))
	(assert(return))
    (pop-focus)
)

(defrule start-know-top-only-two 
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y) (content top))
	?row2 <- (k-per-row (row ?x1 &:(eq (+ ?x 1) ?x1 ))(num ?val-row2))
	(closed-boats (two ?two-val&~3)(three 2) (four 1))
	(not(guessed (x ?x1) (y ?y)))
	?boats <- (closed-boats)
	?row1 <- (k-per-row (row ?x) (num ?val-row1))
	?col1 <- (k-per-col (col ?y) (num ?val-col1))
	=>
	(modify ?boats(two (+ ?two-val 1)))
	(modify ?row1 (num (- ?val-row1 1)))
	(modify ?row2(num (- ?val-row2 1)))
	(modify ?col1(num (- ?val-col1 2)))
	(assert(to-guess (x ?x)(y ?y)))
	(assert(to-guess (x ?x1)(y ?y)))
	(assert(to-guess (x (+ ?x 2))(y ?y)))
	(assert(to-guess (x (+ ?x 2))(y (+ ?y 1))))
	(assert(to-guess (x (+ ?x 2))(y (- ?y 1))))
	(assert(to-guess (x (+ ?x 1))(y (- ?y 1))))
	(assert(to-guess (x (+ ?x 1))(y (+ ?y 1))))
	(assert(to-guess (x ?x)(y (- ?y 1))))
	(assert(to-guess (x ?x)(y (+ ?y 1))))
	(assert(to-guess (x (- ?x 1))(y (- ?y 1))))
	(assert(to-guess (x (- ?x 1))(y ?y)))
	(assert(to-guess (x (- ?x 1))(y (+ ?y 1))))
	(printout t "(start-know-top-only-two) ho guessato come bottom " ?x1 " " ?y crlf)
	(assert(exec (step ?s) (action guess) (x (+ ?x 1)) (y ?y )))
	(assert (ausiliar-exec (action guess) (x ?x)(y ?y)))
	(assert(return))
    (pop-focus)
)

(defrule start-know-left-only-two 
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y) (content left))
	?col2 <- (k-per-col (col ?y1 &:(eq (+ ?y 1) ?y1 ))(num ?val-col2))
	(closed-boats (two ?two-val&~3)(three 2) (four 1))
	(not(guessed (x ?x) (y ?y1)))
	?boats <- (closed-boats)
	?row1 <- (k-per-col (col ?y) (num ?val-col1))
	?col1 <- (k-per-row (row ?x) (num ?val-row1))
	=>
	(modify ?boats(two (+ ?two-val 1)))
	(modify ?col1 (num (- ?val-col1 1)))
	(modify ?col2(num (- ?val-col2 1)))
	(modify ?row1(num (- ?val-row1 2)))
	(assert(to-guess (x ?x)(y ?y)))
	(assert(to-guess (x ?x)(y ?y1)))
	(assert(to-guess (x (+ ?x 1))(y ?y)))
	(assert(to-guess (x (+ ?x 1))(y (+ ?y 1))))
	(assert(to-guess (x (+ ?x 1))(y (- ?y 1))))
	(assert(to-guess (x (+ ?x 1))(y (+ ?y 2))))
	(assert(to-guess (x ?x)(y (+ ?y 2))))
	(assert(to-guess (x ?x)(y (- ?y 1))))
	(assert(to-guess (x (- ?x 1))(y (+ ?y 2))))
	(assert(to-guess (x (- ?x 1))(y (- ?y 1))))
	(assert(to-guess (x (- ?x 1))(y ?y)))
	(assert(to-guess (x (- ?x 1))(y (+ ?y 1))))
	(printout t " (start-know-left-only-two) ho guessato come right " ?x " " ?y1 crlf)
	(assert(exec (step ?s) (action guess) (x ?x) (y (+ ?y 1))))
	(assert (ausiliar-exec (action guess) (x ?x)(y ?y)))
	(assert(return))
    (pop-focus)
)

(defrule start-know-right-only-two 
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y) (content right))
	?col2 <- (k-per-col (col ?y1 &:(eq (- ?y 1) ?y1 ))(num ?val-col2))
	(closed-boats (two ?two-val&~3)(three 2) (four 1))
	(not(guessed (x ?x) (y ?y1)))
	?boats <- (closed-boats)
	?row1 <- (k-per-col (col ?y) (num ?val-col1))
	?col1 <- (k-per-row (row ?x) (num ?val-row1))
	=>
	(modify ?boats(two (+ ?two-val 1)))
	(modify ?col1 (num (- ?val-col1 1)))
	(modify ?col2(num (- ?val-col2 1)))
	(modify ?row1(num (- ?val-row1 2)))
	(assert(to-guess (x ?x)(y ?y)))
	(assert(to-guess (x ?x)(y ?y1)))
	(assert(to-guess (x (+ ?x 1))(y ?y)))
	(assert(to-guess (x (+ ?x 1))(y (+ ?y 1))))
	(assert(to-guess (x (+ ?x 1))(y (- ?y 1))))
	(assert(to-guess (x (+ ?x 1))(y (- ?y 2))))
	(assert(to-guess (x ?x)(y (- ?y 2))))
	(assert(to-guess (x ?x)(y (+ ?y 1))))
	(assert(to-guess (x (- ?x 1))(y (- ?y 2))))
	(assert(to-guess (x (- ?x 1))(y (- ?y 1))))
	(assert(to-guess (x (- ?x 1))(y ?y)))
	(assert(to-guess (x (- ?x 1))(y (+ ?y 1))))
	(printout t " (start-know-right-only-two) ho guessato come left " ?x " " ?y1 crlf)
	(assert(exec (step ?s) (action guess) (x ?x) (y (- ?y 1))))
	(assert (ausiliar-exec (action guess) (x ?x)(y ?y)))
	(assert(return))
    (pop-focus)
)



(defrule know-top-only-three 
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y) (content top))
	?row3 <- (k-per-row (row ?x2 &:(eq (+ ?x 2) ?x2 ))(num ?val-row3))
	?row2 <- (k-per-row (row ?x1 &:(eq (+ ?x 1) ?x1 ))(num ?val-row2))
	(closed-boats (two 3)(three ?t-val&~2) (four 1))
	(not(guessed (x ?x1) (y ?y)))
	(not(guessed (x ?x2) (y ?y)))
	?boats <- (closed-boats)
	?row1 <- (k-per-row (row ?x) (num ?val-row1))
	?col1 <- (k-per-col (col ?y) (num ?val-col1))
	=>
	(modify ?boats(three (+ ?t-val 1)))
	(modify ?col1 (num (- ?val-col1 3)))
	(modify ?row1(num (- ?val-row1 1)))
	(modify ?row2(num (- ?val-row2 1)))
	(modify ?row3(num (- ?val-row3 1)))
	(assert(to-guess (x ?x)(y ?y)))
	(assert(to-guess(x ?x1) (y ?y)))
	(assert(to-guess(x ?x2) (y ?y)))
	(assert(to-guess (x (- ?x 1))(y ?y)))
	(assert(to-guess (x (- ?x 1))(y (+ ?y 1))))
	(assert(to-guess (x (- ?x 1))(y (- ?y 1))))
	(assert(to-guess (x ?x)(y (- ?y 1))))
	(assert(to-guess (x ?x)(y (+ ?y 1))))
	(assert(to-guess (x (+ ?x 1))(y (+ ?y 1))))
	(assert(to-guess (x (+ ?x 1))(y (- ?y 1))))
	(assert(to-guess (x (+ ?x 2))(y (+ ?y 1))))
	(assert(to-guess (x (+ ?x 2))(y (- ?y 1))))
	(assert(to-guess (x (+ ?x 3))(y ?y)))
	(assert(to-guess (x (+ ?x 3))(y (+ ?y 1))))
	(assert(to-guess (x (+ ?x 3))(y (- ?y 1))))
	(assert(exec (step ?s) (action guess) (x (+ ?x 1)) (y ?y)))
	(assert (ausiliar-exec (action guess) (x (+ ?x 2))(y ?y)))
	(assert (ausiliar-exec (action guess) (x ?x)(y ?y)))
	(printout t "(know-top-only-three) ho guessato middle in " ?x1 " e bottom " ?x2 crlf)
	(assert(return))
    (pop-focus)
)


(defrule know-bottom-only-three 
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y) (content bot))
	?row3 <- (k-per-row (row ?x2 &:(eq (- ?x 2) ?x2 ))(num ?val-row3))
	?row2 <- (k-per-row (row ?x1 &:(eq (- ?x 1) ?x1 ))(num ?val-row2))
	(closed-boats (two 3)(three ?t-val&~2) (four 1))
	(not(guessed (x ?x1) (y ?y)))
	(not(guessed (x ?x2) (y ?y)))
	?boats <- (closed-boats)
	?row1 <- (k-per-row (row ?x) (num ?val-row1))
	?col1 <- (k-per-col (col ?y) (num ?val-col1))
	=>
	(modify ?boats(three (+ ?t-val 1)))
	(modify ?col1 (num (- ?val-col1 3)))
	(modify ?row1(num (- ?val-row1 1)))
	(modify ?row2(num (- ?val-row2 1)))
	(modify ?row3(num (- ?val-row3 1)))
	(assert(to-guess(x ?x)(y ?y)))
	(assert(to-guess(x ?x1) (y ?y)))
	(assert(to-guess(x ?x2) (y ?y)))
	(assert(to-guess (x (+ ?x 1))(y ?y)))
	(assert(to-guess (x (+ ?x 1))(y (+ ?y 1))))
	(assert(to-guess (x (+ ?x 1))(y (- ?y 1))))
	(assert(to-guess (x ?x)(y (- ?y 1))))
	(assert(to-guess (x ?x)(y (+ ?y 1))))
	(assert(to-guess (x (- ?x 1))(y (+ ?y 1))))
	(assert(to-guess (x (- ?x 1))(y (- ?y 1))))
	(assert(to-guess (x (- ?x 2))(y (+ ?y 1))))
	(assert(to-guess (x (- ?x 2))(y (- ?y 1))))
	(assert(to-guess (x (- ?x 3))(y ?y)))
	(assert(to-guess (x (- ?x 3))(y (+ ?y 1))))
	(assert(to-guess (x (- ?x 3))(y (- ?y 1))))
	(assert(exec (step ?s) (action guess) (x (- ?x 1)) (y ?y )))
	(assert (ausiliar-exec (action guess) (x (- ?x 2))(y ?y)))
	(assert (ausiliar-exec (action guess) (x ?x)(y ?y)))
	(printout t " (know-bottom-only-three ) ho guessato middle in " ?x1 " e top " ?x2 crlf)
	(assert(return))
    (pop-focus)
)

(defrule know-left-only-three 
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y) (content left))
	?col3 <- (k-per-col (col ?y2 &:(eq (+ ?y 2) ?y2 ))(num ?val-col3))
	?col2 <- (k-per-col (col ?y1 &:(eq (+ ?y 1) ?y1 ))(num ?val-col2))
	(closed-boats (two 3)(three ?t-val&~2) (four 1))
	(not(guessed (x ?x) (y ?y1)))
	(not(guessed (x ?x) (y ?y2)))
	?boats <- (closed-boats)
	?row1 <- (k-per-row (row ?x) (num ?val-row1))
	?col1 <- (k-per-col (col ?y) (num ?val-col1))
	=>
	(modify ?boats(three (+ ?t-val 1)))
	(modify ?row1(num (- ?val-row1 3)))
	(modify ?col1 (num (- ?val-col1 1)))
	(modify ?col2(num (- ?val-col2 1)))
	(modify ?col3(num (- ?val-col3 1)))
	(assert(to-guess(x ?x)(y ?y)))
	(assert(to-guess(x ?x) (y ?y1)))
	(assert(to-guess(x ?x) (y ?y2)))
	(assert(to-guess (x (+ ?x 1))(y ?y)))
	(assert(to-guess (x (+ ?x 1))(y (+ ?y 1))))
	(assert(to-guess (x (+ ?x 1))(y (- ?y 1))))
	(assert(to-guess (x (+ ?x 1))(y (+ ?y 2))))
	(assert(to-guess (x (+ ?x 1))(y (+ ?y 3))))
	(assert(to-guess (x ?x)(y (- ?y 1))))
	(assert(to-guess (x ?x)(y (+ ?y 3))))
	(assert(to-guess (x (- ?x 1))(y ?y)))
	(assert(to-guess (x (- ?x 1))(y (+ ?y 1))))
	(assert(to-guess (x (- ?x 1))(y (- ?y 1))))
	(assert(to-guess (x (- ?x 1))(y (+ ?y 2))))
	(assert(to-guess (x (- ?x 1))(y (+ ?y 3))))
	(assert(exec (step ?s) (action guess) (x ?x )(y ?y1)))
	(assert (ausiliar-exec (action guess) (x ?x )(y ?y2)))
	(assert (ausiliar-exec (action guess) (x ?x)(y ?y)))
	(printout t "(know-left-only-three) ho guessato middle in " ?y1 " e right " ?y2 crlf)
	(assert(return))
    (pop-focus)
)


(defrule know-right-only-three 
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y) (content right))
	?col3 <- (k-per-col (col ?y2 &:(eq (- ?y 2) ?y2 ))(num ?val-col3))
	?col2 <- (k-per-col (col ?y1 &:(eq (- ?y 1) ?y1 ))(num ?val-col2))
	(closed-boats (two 3)(three ?t-val&~2) (four 1))
	(not(guessed (x ?x) (y ?y1)))
	(not(guessed (x ?x) (y ?y2)))
	?boats <- (closed-boats)
	?row1 <- (k-per-row (row ?x) (num ?val-row1))
	?col1 <- (k-per-col (col ?y) (num ?val-col1))
	=>
	(modify ?boats(three (+ ?t-val 1)))
	(modify ?row1(num (- ?val-row1 3)))
	(modify ?col1 (num (- ?val-col1 1)))
	(modify ?col2(num (- ?val-col2 1)))
	(modify ?col3(num (- ?val-col3 1)))
	(assert(to-guess(x ?x)(y ?y)))
	(assert(to-guess(x ?x) (y ?y1)))
	(assert(to-guess(x ?x) (y ?y2)))
	(assert(to-guess (x (+ ?x 1))(y ?y)))
	(assert(to-guess (x (+ ?x 1))(y (+ ?y 1))))
	(assert(to-guess (x (+ ?x 1))(y (- ?y 1))))
	(assert(to-guess (x (+ ?x 1))(y (- ?y 2))))
	(assert(to-guess (x (+ ?x 1))(y (- ?y 3))))
	(assert(to-guess (x ?x)(y (+ ?y 1))))
	(assert(to-guess (x ?x)(y (- ?y 3))))
	(assert(to-guess (x (- ?x 1))(y ?y)))
	(assert(to-guess (x (- ?x 1))(y (+ ?y 1))))
	(assert(to-guess (x (- ?x 1))(y (- ?y 1))))
	(assert(to-guess (x (- ?x 1))(y (- ?y 2))))
	(assert(to-guess (x (- ?x 1))(y (- ?y 3))))
	(assert(exec (step ?s) (action guess) (x ?x )(y ?y1)))
	(assert (ausiliar-exec (action guess) (x ?x )(y ?y2)))
	(assert (ausiliar-exec (action guess) (x ?x)(y ?y)))
	(printout t " (know-right-only-three) ho guessato middle in " ?y1 " e left " ?y2 crlf)
	(assert(return))
    (pop-focus)
)



(defrule know-right-only-four 
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y) (content right))
	?col4 <- (k-per-col (col ?y3 &:(eq (- ?y 3) ?y3 ))(num ?val-col4))
	?col3 <- (k-per-col (col ?y2 &:(eq (- ?y 2) ?y2 ))(num ?val-col3))
	?col2 <- (k-per-col (col ?y1 &:(eq (- ?y 1) ?y1 ))(num ?val-col2))
	(closed-boats (two 3)(three 2) (four 0))
	(not(guessed (x ?x) (y ?y1)))
	(not(guessed (x ?x) (y ?y2)))
	(not(guessed (x ?x) (y ?y3)))
	?boats <- (closed-boats)
	?row1 <- (k-per-row (row ?x) (num ?val-row1))
	?col1 <- (k-per-col (col ?y) (num ?val-col1))
	=>
	(modify ?boats(four 1))
	(modify ?row1(num (- ?val-row1 4)))
	(modify ?col1(num (- ?val-col1 1)))
	(modify ?col2(num (- ?val-col2 1)))
	(modify ?col3(num (- ?val-col3 1)))
	(modify ?col4(num (- ?val-col4 1)))
	(assert(to-guess(x ?x)(y ?y)))
	(assert(to-guess(x ?x) (y ?y1)))
	(assert(to-guess(x ?x) (y ?y2)))
	(assert(to-guess(x ?x) (y ?y3)))
	(assert(to-guess (x (+ ?x 1))(y ?y)))
	(assert(to-guess (x (+ ?x 1))(y (+ ?y 1))))
	(assert(to-guess (x (+ ?x 1))(y (- ?y 1))))
	(assert(to-guess (x (+ ?x 1))(y (- ?y 2))))
	(assert(to-guess (x (+ ?x 1))(y (- ?y 3))))
	(assert(to-guess (x (+ ?x 1))(y (- ?y 4))))
	(assert(to-guess (x ?x)(y (+ ?y 1))))
	(assert(to-guess (x ?x)(y (- ?y 4))))
	(assert(to-guess (x (- ?x 1))(y ?y)))
	(assert(to-guess (x (- ?x 1))(y (+ ?y 1))))
	(assert(to-guess (x (- ?x 1))(y (- ?y 1))))
	(assert(to-guess (x (- ?x 1))(y (- ?y 2))))
	(assert(to-guess (x (- ?x 1))(y (- ?y 3))))
	(assert(to-guess (x (- ?x 1))(y (- ?y 4))))
	(assert(exec (step ?s) (action guess) (x ?x )(y ?y1)))
	(assert (ausiliar-exec (action guess) (x ?x )(y ?y2)))
	(assert (ausiliar-exec (action guess) (x ?x )(y ?y3)))
	(assert (ausiliar-exec (action guess) (x ?x)(y ?y)))
	(printout t "(know-right-only-four) ho guessato middle in " ?y1 " middle2 " ?y2 " e left " ?y3 crlf)
	(assert(return))
    (pop-focus)
)


(defrule know-left-only-four 
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y) (content left))
	?col4 <- (k-per-col (col ?y3 &:(eq (+ ?y 3) ?y3 ))(num ?val-col4))
	?col3 <- (k-per-col (col ?y2 &:(eq (+ ?y 2) ?y2 ))(num ?val-col3))
	?col2 <- (k-per-col (col ?y1 &:(eq (+ ?y 1) ?y1 ))(num ?val-col2))
	(closed-boats (two 3)(three 2) (four 0))
	(not(guessed (x ?x) (y ?y1)))
	(not(guessed (x ?x) (y ?y2)))
	(not(guessed (x ?x) (y ?y3)))
	?boats <- (closed-boats)
	?row1 <- (k-per-row (row ?x) (num ?val-row1))
	?col1 <- (k-per-col (col ?y) (num ?val-col1))
	=>
	(modify ?boats(four 1))
	(modify ?row1(num (- ?val-row1 4)))
	(modify ?col1(num (- ?val-col1 1)))
	(modify ?col2(num (- ?val-col2 1)))
	(modify ?col3(num (- ?val-col3 1)))
	(modify ?col4(num (- ?val-col4 1)))
	(assert(to-guess(x ?x)(y ?y)))
	(assert(to-guess(x ?x) (y ?y1)))
	(assert(to-guess(x ?x) (y ?y2)))
	(assert(to-guess(x ?x) (y ?y3)))
	(assert(to-guess (x (+ ?x 1))(y ?y)))
	(assert(to-guess (x (+ ?x 1))(y (+ ?y 1))))
	(assert(to-guess (x (+ ?x 1))(y (- ?y 1))))
	(assert(to-guess (x (+ ?x 1))(y (+ ?y 2))))
	(assert(to-guess (x (+ ?x 1))(y (+ ?y 3))))
	(assert(to-guess (x (+ ?x 1))(y (+ ?y 4))))
	(assert(to-guess (x ?x)(y (+ ?y 4))))
	(assert(to-guess (x ?x)(y (- ?y 1))))
	(assert(to-guess (x (- ?x 1))(y ?y)))
	(assert(to-guess (x (- ?x 1))(y (+ ?y 1))))
	(assert(to-guess (x (- ?x 1))(y (- ?y 1))))
	(assert(to-guess (x (- ?x 1))(y (+ ?y 2))))
	(assert(to-guess (x (- ?x 1))(y (+ ?y 3))))
	(assert(to-guess (x (- ?x 1))(y (+ ?y 4))))
	(assert(exec (step ?s) (action guess) (x ?x )(y ?y1)))
	(assert (ausiliar-exec (action guess) (x ?x )(y ?y2)))
	(assert (ausiliar-exec (action guess) (x ?x )(y ?y3)))
	(assert (ausiliar-exec (action guess) (x ?x)(y ?y)))
	(printout t "(know-left-only-four) ho guessato middle in " ?y1 " middle2 " ?y2 " e right " ?y3 crlf)
	(assert(return))
    (pop-focus)
)


(defrule know-bottom-only-four 
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y) (content bot))
	?row4 <- (k-per-row (row ?x3 &:(eq (- ?x 3) ?x3 ))(num ?val-row4))
	?row3 <- (k-per-row (row ?x2 &:(eq (- ?x 2) ?x2 ))(num ?val-row3))
	?row2 <- (k-per-row (row ?x1 &:(eq (- ?x 1) ?x1 ))(num ?val-row2))
	(closed-boats (two 3)(three 2) (four 0))
	(not(guessed (x ?x1) (y ?y)))
	(not(guessed (x ?x2) (y ?y)))
	(not(guessed (x ?x3) (y ?y)))
	?boats <- (closed-boats)
	?row1 <- (k-per-row (row ?x) (num ?val-row1))
	?col1 <- (k-per-col (col ?y) (num ?val-col1))
	=>
	(modify ?boats(four 1))
	(modify ?col1(num (- ?val-col1 4)))
	(modify ?row1(num (- ?val-row1 1)))
	(modify ?row2(num (- ?val-row2 1)))
	(modify ?row3(num (- ?val-row3 1)))
	(modify ?row4(num (- ?val-row4 1)))
	(assert(to-guess(x ?x)(y ?y)))
	(assert(to-guess(x ?x1) (y ?y)))
	(assert(to-guess(x ?x2) (y ?y)))
	(assert(to-guess(x ?x3) (y ?y)))
	(assert(to-guess (x (+ ?x 1))(y ?y)))
	(assert(to-guess (x (+ ?x 1))(y (+ ?y 1))))
	(assert(to-guess (x (+ ?x 1))(y (- ?y 1))))
	(assert(to-guess (x ?x)(y (+ ?y 1))))
	(assert(to-guess (x ?x)(y (- ?y 1))))
	(assert(to-guess (x (- ?x 1))(y (+ ?y 1))))
	(assert(to-guess (x (- ?x 1))(y (- ?y 1))))
	(assert(to-guess (x (- ?x 2))(y (- ?y 1))))
	(assert(to-guess (x (- ?x 2))(y (+ ?y 1))))
	(assert(to-guess (x (- ?x 3))(y (- ?y 1))))
	(assert(to-guess (x (- ?x 3))(y (+ ?y 1))))
	(assert(to-guess (x (- ?x 4))(y ?y)))
	(assert(to-guess (x (- ?x 4))(y (+ ?y 1))))
	(assert(to-guess (x (- ?x 4))(y (- ?y 1))))
	(assert(exec (step ?s) (action guess) (x ?x1 )(y ?y)))
	(assert (ausiliar-exec (action guess) (x ?x2 )(y ?y)))
	(assert (ausiliar-exec (action guess) (x ?x3 )(y ?y)))
	(assert (ausiliar-exec (action guess) (x ?x)(y ?y)))
	(printout t "(know-bottom-only-four)ho guessato middle in " ?x1 " middle2 " ?x2 " e top " ?x3 crlf)
	(assert(return))
    (pop-focus)
)



(defrule know-top-only-four 
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y) (content top))
	?row4 <- (k-per-row (row ?x3 &:(eq (+ ?x 3) ?x3 ))(num ?val-row4))
	?row3 <- (k-per-row (row ?x2 &:(eq (+ ?x 2) ?x2 ))(num ?val-row3))
	?row2 <- (k-per-row (row ?x1 &:(eq (+ ?x 1) ?x1 ))(num ?val-row2))
	(closed-boats (two 3)(three 2) (four 0))
	(not(guessed (x ?x1) (y ?y)))
	(not(guessed (x ?x2) (y ?y)))
	(not(guessed (x ?x3) (y ?y)))
	?boats <- (closed-boats)
	?row1 <- (k-per-row (row ?x) (num ?val-row1))
	?col1 <- (k-per-col (col ?y) (num ?val-col1))
	=>
	(modify ?boats(four 1))
	(modify ?col1(num (- ?val-col1 4)))
	(modify ?row1(num (- ?val-row1 1)))
	(modify ?row2(num (- ?val-row2 1)))
	(modify ?row3(num (- ?val-row3 1)))
	(modify ?row4(num (- ?val-row4 1)))
	(assert(to-guess(x ?x)(y ?y)))
	(assert(to-guess(x ?x1) (y ?y)))
	(assert(to-guess(x ?x2) (y ?y)))
	(assert(to-guess(x ?x3) (y ?y)))
	(assert(to-guess (x (- ?x 1))(y ?y)))
	(assert(to-guess (x (- ?x 1))(y (+ ?y 1))))
	(assert(to-guess (x (- ?x 1))(y (- ?y 1))))
	(assert(to-guess (x ?x)(y (+ ?y 1))))
	(assert(to-guess (x ?x)(y (- ?y 1))))
	(assert(to-guess (x (+ ?x 1))(y (+ ?y 1))))
	(assert(to-guess (x (+ ?x 1))(y (- ?y 1))))
	(assert(to-guess (x (+ ?x 2))(y (- ?y 1))))
	(assert(to-guess (x (+ ?x 2))(y (+ ?y 1))))
	(assert(to-guess (x (+ ?x 3))(y (- ?y 1))))
	(assert(to-guess (x (+ ?x 3))(y (+ ?y 1))))
	(assert(to-guess (x (+ ?x 4))(y ?y)))
	(assert(to-guess (x (+ ?x 4))(y (+ ?y 1))))
	(assert(to-guess (x (+ ?x 4))(y (- ?y 1))))
	(assert(exec (step ?s) (action guess) (x ?x1 )(y ?y)))
	(assert (ausiliar-exec (action guess) (x ?x2 )(y ?y)))
	(assert (ausiliar-exec (action guess) (x ?x3 )(y ?y)))
	(assert (ausiliar-exec (action guess) (x ?x)(y ?y)))
	(printout t "(know-top-only-four) ho guessato middle in " ?x1 " middle2 " ?x2 " e bottom " ?x3 crlf)
	(assert(return))
    (pop-focus)
)