(define (domain CoffeeShop_2)

   (:requirements
      :strips                    ;basic actions
      :typing                    ;types for objects
      :fluents                   ;numeric fluents
      :negative-preconditions    ;not in preconditions
      :disjunctive-preconditions ;or in preconditions
      :universal-preconditions   ;forall and exists in preconditions
      :equality                  ;equal to compare objects
      :conditional-effects       ;when in action effects
      :time                      ;processes and events
   )

   (:types
      barman waiter - robot
      table bar - location
      drink
   )

   (:predicates
      ; Drink predicates
      (cold ?d - drink)
      (warm ?d - drink)
      (ready_drink ?d - drink)
      (preparing ?d - drink)

      ; Robot predicates
      (free ?r - robot)
      (loaded ?w - waiter)

      ; Moving predicates
      (connected ?from ?to - location)
      (moving ?from ?to - location)

      ; Position predicates
      (at_waiter ?l - location)
      (at_drink ?d - drink ?l - location)

      ; Cleaning predicates
      (to_clean ?t - table)
      (cleaning ?t - table)
      (cleaned ?t - table)
   
   )

   (:functions
      (distance ?from ?to - location)
      (table_area ?t - table)
      (move_time ?from ?to - location)
      (cleaning_time ?t - table)
      (prep_time ?d - drink)
      (steps ?w)
   )

; MOVE WAITER

   (:action move_start
      :parameters (?from ?to - location ?w - waiter)
      :precondition (and
         (free ?w)
         (connected ?from ?to)
         (at_waiter ?from)
         (not (moving ?from ?to))
         (>= (steps ?w) 0)
      )
      :effect (and
         (moving ?from ?to)
         (not (at_waiter ?from))
         (not (free ?w))
         (assign (move_time ?from ?to) (/ (distance ?from ?to) 2))
      )
   )

   (:process move_process
      :parameters (?from ?to - location ?w - waiter)
      :precondition (and
         (connected ?from ?to)
         (moving ?from ?to)
         (not (free ?w))
      )
      :effect (and
         (decrease (move_time ?from ?to) #t)
      )
   )

   (:event move_end
      :parameters (?from ?to - location ?w - waiter)
      :precondition (and
         (connected ?from ?to)
         (moving ?from ?to)
         (<= (move_time ?from ?to) 0)
         (not (free ?w))
      )
      :effect (and
         (at_waiter ?to)
         (free ?w)
         (decrease (steps ?w) 1)
         (not (moving ?from ?to))
      )
   )

; CLEAN TABLE

   (:action clean_table_start
      :parameters (?t - table ?w - waiter)
      :precondition (and
         (at_waiter ?t)
         (to_clean ?t)
         (free ?w)
         (not (loaded ?w))
         (not (cleaning ?t))
         (not (cleaned ?t))
      )
      :effect (and
         (cleaning ?t)
         (not (to_clean ?t))
         (not (free ?w))
         (assign (cleaning_time ?t) (* (table_area ?t) 2))
      )
   )

   (:process clean_process
      :parameters (?t - table ?w - waiter)
      :precondition (and
         (cleaning ?t)
         (at_waiter ?t)
         (not (free ?w))
      )
      :effect (and
         (decrease (cleaning_time ?t) #t)
      )
   )

   (:event clean_table_end
      :parameters (?t - table ?w - waiter)
      :precondition (and
         (cleaning ?t)
         (at_waiter ?t)
         (<= (cleaning_time ?t) 0)
         (not (free ?w))
      )
      :effect (and
         (cleaned ?t)
         (free ?w)
         (not (cleaning ?t))
         (assign (steps ?w) 2)
      )
   )

; PREPARE DRINK

   (:action prep_drink_cold_start
      :parameters (?d - drink ?b - barman)
      :precondition (and
         (free ?b)
         (cold ?d)
         (not (preparing ?d))
         (not (ready_drink ?d))
      )
      :effect (and
         (preparing ?d)
         (not (free ?b))
         (assign (prep_time ?d) 3)
      )
   )

   (:action prep_drink_warm_start
      :parameters (?d - drink ?b - barman)
      :precondition (and
         (free ?b)
         (warm ?d)
         (not (preparing ?d))
         (not (ready_drink ?d))
      )
      :effect (and
         (preparing ?d)
         (not (free ?b))
         (assign (prep_time ?d) 5)
      )
   )

   (:process prep_drink_process
      :parameters (?d - drink)
      :precondition (and
         (preparing ?d)
      )
      :effect (and
         (decrease (prep_time ?d) #t)
      )
   )

   (:event prep_drink_end
      :parameters (?d - drink ?b - barman ?l - bar ?w - waiter)
      :precondition (and
         (preparing ?d)
         (<= (prep_time ?d) 0)
      )
      :effect (and
         (free ?b)
         (at_drink ?d ?l)
         (ready_drink ?d)
         (not (preparing ?d))
         (assign (steps ?w) 2)
      )
   )

   (:action pick_drink
      :parameters (?d - drink ?l - bar ?w - waiter)
      :precondition (and
         (at_waiter ?l)
         (at_drink ?d ?l)
         (ready_drink ?d)
         (not (loaded ?w))
      )
      :effect (and
         (loaded ?w)
         (not (at_drink ?d ?l))
      )
   )

; SERVE DRINK

   (:action serve_drink
      :parameters (?w - waiter ?d - drink ?to - table)
      :precondition (and
         (at_waiter ?to)
         (free ?w)
         (loaded ?w)
      )
      :effect (and
         (at_drink ?d ?to)
         (not (loaded ?w))
         (assign (steps ?w) 2)
      )
   )
)