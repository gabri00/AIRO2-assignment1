(define (domain coffeeshop)

    (:requirements
        ; Allows the usage of basic actions
        :strips
        ; Allows the definition of types for objects
        :typing
        ; Allows the usage of numeric fluents
        :fluents
        ; Allows the usage of not in preconditions
        :negative-preconditions
        ; Allows the usage of or in preconditions
        :disjunctive-preconditions
        ; Allows the usage of foreach and exists in preconditions
        :universal-preconditions
        ; Allows the usage of = to compare objects
        :equality
        ; Allows the usage of when in action effects
        :conditional-effects
        ; Allows the usage of processes and events
        :time
    )

    (:types
        grabber robot drink - object
        barman waiter - robot
        bar table  - location
        
    )

    (:predicates
        
        (cold ?d - drink)
        (warm ?d - drink)
        (ready ?d - drink)
        
        (at_drink ?d - drink ?l - location)
        (at_agent ?w - waiter ?l - location)
        
        (free ?g - grabber)
        (carrying ?d - drink)
        
        
        (free ?r - robot)

        (is_preparing ?b - barman ?d - drink)

        (at_t ?t - table)
        (flag ?t - table)
        (t_to_t ?t1 ?t2 - table)
        (connection ?l1 ?l2 - location)
         
    )

    (:functions
        

        (time_cold ?b - barman )
        (time_warm ?b - barman )

        (distance ?l1 ?l2 - location)
    )



; MAKE-SHAKE-READY WARM DRINK
    (:action making_warm
        :parameters 
            (?b - barman ?d - drink)
        :precondition
            (and
            (not (ready ?d))
            (free ?b)
            (warm ?d)
                
            )
        :effect
            (and
                (not (free ?b))
                (is_preparing ?b ?d)
            )
    )

    (:process shaking_warm
        :parameters 
            (?b - barman ?d - drink)
        :precondition
            (and
                (warm ?d)
                (is_preparing ?b ?d)
            )
        :effect
            (and
                (decrease (time_warm ?b)(* #t 1))
            )
    )

    (:action drink_ready_warm
        :parameters 
            (?b - barman ?d - drink ?l - bar)
        :precondition
            (and
                (warm ?d)
                (<= (time_warm ?b) 0)
                (is_preparing ?b ?d)
            )
        :effect
            (and
                (free ?b)
                (assign (time_warm ?b) 5)
                (ready ?d)
                (not (is_preparing ?b ?d))
                (at_drink ?d ?l)
            )
    )
; MAKE-SHAKE-READY COLD DRINK
    (:action making_cold
        :parameters 
            (?b - barman ?d - drink)
        :precondition
            (and
            (not (ready ?d))
            (free ?b)
            (cold ?d)
                
            )
        :effect
            (and
                (not (free ?b))
                (is_preparing ?b ?d)
            )
    )

    (:process shaking_cold
        :parameters 
            (?b - barman ?d - drink)
        :precondition
            (and
                (cold ?d)
                (is_preparing ?b ?d)
            )
        :effect
            (and
                (decrease (time_cold ?b)(* #t 1))
            )
    )

    (:action drink_ready_cold
        :parameters 
            (?b - barman ?d - drink ?l - bar)
        :precondition
            (and
                (cold ?d)
                (<= (time_cold ?b) 0)
                (is_preparing ?b ?d)
            )
        :effect
            (and
                (free ?b)
                (assign (time_cold ?b) 3)
                (ready ?d)
                (not (is_preparing ?b ?d))
                (at_drink ?d ?l)
            )
    )








; GRAB & SERVE WAITER ACTIONS
 
    (:action grab_drink
        :parameters 
            (?d - drink ?b - bar ?w - waiter ?g - grabber)
        :precondition
            (and
                (ready ?d)
                (at_drink ?d ?b)
                (at_agent ?w ?b)
                (free ?g)
            )
        :effect
            (and
                (not (at_drink ?d ?b))
                (not (free ?g))
                (carrying ?d)
            )
    )

    (:action serve_drink
        :parameters 
            (?d - drink ?t - table ?w - waiter ?g - grabber)
        :precondition
            (and
                (carrying ?d)
                (at_agent ?w ?t)
                (not (free ?g))
            )
        :effect
            (and
                (at_drink ?d ?t)
                (free ?g)
                (not (carrying ?d))
            )
    )





; MOVEMENTS BAR -----> TABLE 1 OR 2

    (:process movement_bar_table
        :parameters 
            (?w - waiter ?b - bar ?t - table)
        :precondition
            (and  
            (at_agent ?w ?b)
            

            )
        :effect
            (and
                (decrease (distance ?b ?t)(* #t 2))
                
                
            )
    )


    (:event arrived_to_table
        :parameters 
            (?w - waiter ?b - bar ?t - table)
        :precondition
            (and
                
                (<= (distance ?b ?t) 0)
                
                
            )
        :effect
            (and
                (not (at_agent ?w ?b))
                (at_agent ?w ?t)
                (flag ?t)
                (assign (distance ?b ?t) 20)
                
            )
    )

    
    
    


; MOVEMENTS TABLE 1 OR 2 -----> BAR

    (:process movement_table_bar
        :parameters 
            (?w - waiter ?b - bar ?t - table)
        :precondition
            (and  
            (at_agent ?w ?t)
            (flag ?t)
            )
        :effect
            (and
                (decrease (distance ?t ?b)(* #t 2))
                
                
            )
    )

    (:event arrived_to_bar
        :parameters 
            (?w - waiter ?b - bar ?t - table)
        :precondition
            (and
                
                (<= (distance ?t ?b) 0)
                
                
            )
        :effect
            (and
                (not (at_agent ?w ?t))
                (at_agent ?w ?b)
                (assign (distance ?t ?b) 20)
                (not (flag ?t))
            )
    )

; MOVEMENTS TABLE1 -----> TABLE3
    

    (:process movement_table_table
        :parameters 
            (?w - waiter ?t1 ?t2 - table)
        :precondition
            (and  
            (at_agent ?w ?t1)
            (flag ?t1)
            (not (flag ?t2))
            )
        :effect
            (and
                (decrease (distance ?t1 ?t2)(* #t 2))
                
                
            )
    )

    (:event arrived_to_table
        :parameters 
            (?w - waiter ?t1 ?t2 - table)
        :precondition
            (and
                
                (<= (distance ?t1 ?t2) 0)
                
                
            )
        :effect
            (and
                (not (at_agent ?w ?t1))
                (at_agent ?w ?t2)
                (assign (distance ?t1 ?t2) 6)
                (flag ?t2)
                (not (flag ?t1))
            )
    )














)
