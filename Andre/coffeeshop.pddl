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
        robot drink - object
        barman waiter - robot
        bar table - location
        grabber
    )

    (:predicates
        (cold ?d - drink)
        (warm ?d - drink)
        (ready ?d - drink)
        (at_drink ?d - drink ?l - location)

        (at_agent ?w - waiter ?l - location)
        
        (free ?g - grabber)
        (grabbed_drink ?d - drink)
        
        
        ; True iff ?r is occupied and cannot perform a task
        (is_occupied ?r - robot)
    
        ; True iff ?b is preparing ?d
        (is_preparing ?b - barman ?d - drink)
    
        ; True iff ?w is serving ?d
        (is_serving ?w - waiter ?d - drink)
        
    )

    (:functions
        

        ; The time ?m is occupied performing some action
        (occupied_time ?r - robot)
        (occupied_time_w ?r - robot)

        (distance ?l1 ?l2 - location)
    )



    (:action prepare_cold
        :parameters 
            (?b - barman ?d - drink)
        :precondition
            (and
                ; ?b must not be performing another task when occupied
                (not (is_occupied ?b))
                ; ?d must be cold
                (cold ?d)
                ;(not (warm ?d)) 
            )
        :effect
            (and
                ; ?b is now preparing ?d
                (is_preparing ?b ?d)
                
                (is_occupied ?b)
            )
    )

    (:process shaking_cold
        :parameters 
            (?b - barman ?d - drink)
        :precondition
            (and
                (cold ?d)
                ; ?b must be preparing ?d
                (is_preparing ?b ?d)
            )
        :effect
            (and
                (decrease (occupied_time ?b)(* #t 1))
            )
    )

    (:event drink_ready
        :parameters 
            (?b - barman ?d - drink)
        :precondition
            (and
                (cold ?d)
                ; ?b must have finished occupied time
                (<= (occupied_time ?b) 0)
                (is_occupied ?b)
                ; ?b must be preparing ?d
                (is_preparing ?b ?d)
            )
        :effect
            (and
                ; ?b is no longer preparing ?d
                (not (is_preparing ?b ?d))
                (not (is_occupied ?b))
                (assign (occupied_time ?b) 3)
                ; ?d is now ready
                (ready ?d)
            )
    )

    (:action prepare_warm
        :parameters 
            (?b - barman ?d - drink)
        :precondition
            (and
                ; ?b must not be performing another task when occupied
                (not (is_occupied ?b))
                ; ?d must be cold
                (warm ?d)
                (not (cold ?d)) 
            )
        :effect
            (and
                ; ?b is now preparing ?d
                (is_preparing ?b ?d)
                (is_occupied ?b)
            )
    )

    (:process shaking_warm
        :parameters 
            (?b - barman ?d - drink)
        :precondition
            (and
                (warm ?d)
                ; ?b must be preparing ?d
                (is_preparing ?b ?d)
            )
        :effect
            (and
                (decrease (occupied_time_w ?b)(* #t 1))
            )
    )

    (:event drink_ready_warm
        :parameters 
            (?b - barman ?d - drink)
        :precondition
            (and
                (warm ?d)
                ; ?b must have finished occupied time
                (<= (occupied_time_w ?b) 0)
                (is_occupied ?b)
                ; ?b must be preparing ?d
                (is_preparing ?b ?d)
            )
        :effect
            (and
                ; ?b is no longer preparing ?d
                (not (is_preparing ?b ?d))
                (not (is_occupied ?b))
                (assign (occupied_time_w ?b) 5)
                ; ?d is now ready
                (ready ?d)
            )
    )

    (:action drink_on_bancone
        :parameters 
            (?d - drink ?b - bar)
        :precondition
            (and
                (ready ?d)
            )
        :effect
            (and
                (at_drink ?d ?b)
            )
    )

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
                (grabbed_drink ?d)
            )
    )

(:process moving
        :parameters 
            (?w - waiter ?l1 ?l2 - location)
        :precondition
            (and
                
                (at_agent ?w ?l1)
            )
        :effect
            (and
                (decrease (distance ?l1 ?l2)(* #t 2))
                
            )
    )

    (:event arrived
        :parameters 
            (?w - waiter ?l1 ?l2 - location)
        :precondition
            (and
                
                (<= (distance ?l1 ?l2) 0)
                
            )
        :effect
            (and
                (not (at_agent ?w ?l1))
                (at_agent ?w ?l2)
                (assign (distance ?l1 ?l2) 2)
                
            )
    )

    (:action serve_drink
        :parameters 
            (?d - drink ?t - table ?w - waiter ?g - grabber)
        :precondition
            (and
                (at_agent ?w ?t)
                (not (free ?g))
                (grabbed_drink ?d)
            )
        :effect
            (and
                (at_drink ?d ?t)
                (free ?g)
                (not (grabbed_drink ?d))
            )
    )

)



