(defmodule AGENT (import MAIN ?ALL) (import ENV ?ALL) (export ?ALL))

(deftemplate closed-boats
	(slot one (default 0)(range 0 4))
	(slot two (default 0)(range 0 3))
	(slot three (default 0)(range 0 2))
	(slot four (default 0)(range 0 1))
)

(deftemplate to-guess
	(slot x)
	(slot y)
)

(deftemplate guessed
	(slot x)
	(slot y)
)

(deftemplate ausiliar-exec
	(slot action)
	(slot x)
	(slot y)
)

(deftemplate aux
	(slot x)
	(slot y)
	(slot content)
)

(deftemplate g-per-col
    (slot num (range 0 9))
    (slot val (default 0)(range 0 9))
)

(deftemplate g-per-row
    (slot num (range 0 9))
    (slot val (default 0)(range 0 9))
)

(deftemplate top-to-bottom 
	(slot x)
	(slot y)
)

(deftemplate left-to-right 
	(slot x)
	(slot y)
)

(deftemplate to-fire
    (slot x)
    (slot y)
)

(deftemplate move-x
	(slot x)
	(slot y)
)

(deftemplate move-y
	(slot y)
	(slot x)
)

(deftemplate middle-l-r 
	(slot x)
	(slot y)
)

(deftemplate middle-t-b
	(slot x)
	(slot y)
)

(deftemplate limitate
	(slot x)
	(slot y)
)

; (deffacts table )

(deffacts init
(closed-boats) 
(g-per-col(num 0))
(g-per-col(num 1))
(g-per-col(num 2))
(g-per-col(num 3))
(g-per-col(num 4))
(g-per-col(num 5))
(g-per-col(num 6))
(g-per-col(num 7))
(g-per-col(num 8))
(g-per-col(num 9))
(g-per-row(num 0))
(g-per-row(num 1))
(g-per-row(num 2))
(g-per-row(num 3))
(g-per-row(num 4))
(g-per-row(num 5))
(g-per-row(num 6))
(g-per-row(num 7))
(g-per-row(num 8))
(g-per-row(num 9))
(phases MAIN_CONTROL AFTER_NO_KNOW KNOW_DOUBLE_MIDDLE KNOWTWO KNOWONE KNOWONE_INDECISION KNOW_MIDDLE NO_KNOW )
)

;ordina le fasi e quando si arriva alla fine le fa ricominciare dall inizio

(defrule pop 
    (not(end))
    ?f <- (return) 
    ?c <- (phases $?a)
    =>
    (printout t "(----------------------pop--------------------) "crlf)
    (retract ?f)
    (retract ?c)
    (assert(phases MAIN_CONTROL AFTER_NO_KNOW KNOW_DOUBLE_MIDDLE KNOWTWO KNOWONE KNOWONE_INDECISION KNOW_MIDDLE NO_KNOW ))
    (pop-focus)
)

;si occupa dell alternanza delle fasi 

(defrule change-phase
    (not(end))
	?list <- (phases ?next-phase $?other-phases)
=>
	(focus ?next-phase)
    (printout t "(change-phase) " ?next-phase crlf)
	(retract ?list)
	(assert (phases $?other-phases ?next-phase))
)









