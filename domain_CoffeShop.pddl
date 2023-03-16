(define (domain CoffeShop)
    (:requirements :strips :adl :typing :time)
    (:types
        barman - robot
        bar t1 t2 t3 t4 - location
        cold - drink
    )

    (:predicates

    (free ?b - barman)
	(shaking ?c - cold)
	(at_drink ?c - cold ?l - location)
    

        
    )

    (:functions
        
        (shaking_time ?c - cold)
        (distance ?o)
        (speed ?v)
        
    )

    (:action pick_glass
        :parameters (?b - barman ?c - cold)
        :precondition 
            (free ?b)
            
        :effect (and

            (shaking ?c)
            (not (free ?b))
        )
        
    
    )

    (:process making_cold
        :parameters (?b - barman ?c - cold)
        :precondition (and
		    (not (free ?b))
            (shaking ?c)
        )
        :effect 
            (increase (shaking_time ?c) (* #t 1))
        
    )

    

    (:action pick_down
        :parameters (?b - barman ?c - cold ?l - bar)
        :precondition (and 
            (shaking ?c)
            (not (free ?b))
            (>= (shaking_time ?c) 3)
            )
        :effect (and
            (free ?b)
	        (at_drink ?c ?l)
            (not (shaking ?c))
            (assign (shaking_time ?c) 0)
            
	    )
    )


   
)
