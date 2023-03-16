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
        
        (shaking_time ?b - barman)

        
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
        :precondition 
		    (not (free ?b))
		
        :effect 
            (increase (shaking_time ?b) (* #t 1))
        
    )

    (:event cold_ready
        :parameters (?b - barman ?c - cold)
        
        :precondition 
            (>= (shaking_time ?b) 3)
        
        :effect (and
		    (assign (shaking_time ?b) 0)
            (not (shaking ?c))
        )
		
    )

    (:action pick_down
        :parameters (?b - barman ?c - cold ?l - bar)
        :precondition (and 
            (not (shaking ?c))
            (not (free ?b))
            (= (shaking_time ?b) 0)
            )
        :effect (and
            (free ?b)
	        (at_drink ?c ?l)
	    )
    )

    
)
