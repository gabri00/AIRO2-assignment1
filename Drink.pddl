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
    )

    (:predicates
        (cold ?d - drink)
        (warm ?d - drink)
        (ready ?d - drink)

        ; True iff ?r is occupied and cannot perform a task
        (is_occupied ?r - robot)
    
        ; True iff ?b is preparing ?d
        (is_preparing ?b - barman ?d - drink)
    
        ; True iff ?w is serving ?d
        (is_serving ?w - waiter ?d - drink)
        
    )

    (:functions
        ; Where ?r is located
        (position ?r - robot)

        ; The time ?m is occupied performing some action
        (occupied_time ?r - robot)
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
                (not (warm ?d)) 
            )
        :effect
            (and
                ; ?b is now preparing ?d
                (is_preparing ?b ?d)
                ; ?b is occupied until the drink is prepared
                ((assign (occupied_time ?b) 3)
                (is_occupied ?b)
            )
    )

    (:process shaking
        :parameters 
            (?b - barman ?d - drink)
        :precondition
            (and
                ; ?b must be preparing ?d
                (is_preparing ?b ?d)
                (> (occupied_time ?b) 0)
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
                (assign (occupied_time ?b) 0)
                ; ?d is now ready
                (ready ?d)
            )
    )
)
)

