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
      drink
      biscuit
      table bar - location
   )

   (:predicates
      ; Drink predicates
      (cold ?d - drink)
      (warm ?d - drink)
      (ready_drink ?d - drink)

      (loaded ?w - waiter)

      ; Spatial predicates
      (connected ?from ?to - location)
      (moving ?from ?to - location)

      (at_waiter ?l - location)
      (at_drink ?d - drink ?l - location)
      (at_biscuit ?bi - biscuit ?l - location)

      ; Biscuit predicates
      (can_serve_biscuit ?bi - biscuit ?d - drink)

      (free ?r - robot)

      (to_clean ?t - table)
      (cleaning ?t - table)
      (cleaned ?t - table)

      (ready_drink ?d - drink)
   
      (cleaning ?t - table)
      (preparing ?d - drink)
      (serving_drink ?d - drink ?from - bar ?t - table)
      (serving_biscuit ?bi - biscuit ?d - drink ?t - table)
   )

   (:functions
      (distance ?from ?to - location)
      (table_area ?t - table)
      (move_time ?from ?to - location)
      (cleaning_time ?t - table)
      (prep_time ?d - drink)
      (cooling_time ?d - drink)
      (drinking_time ?t - table)
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

; COOLING

   ; (:process cooling
   ;    :parameters (?d - drink)
   ;    :precondition (and
   ;       (warm ?d)
   ;       (ready_drink ?d)
   ;       (> (cooling_time ?d) 0)
   ;    )
   ;    :effect (and
   ;       (decrease (cooling_time ?d) #t)
   ;    )
   ; )

   ; (:event remake_drink
   ;    :parameters (?d - drink)
   ;    :precondition (and
   ;       (warm ?d)
   ;       (ready_drink ?d)
   ;       (<= (cooling_time ?d) 0)
   ;    )
   ;    :effect (and
   ;       (not (ready_drink ?d))
   ;    )
   ; )

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

; SERVE BISCUIT

   ; (:action serve_biscuit
   ;    :parameters (?w - waiter ?d - drink ?bi - biscuit ?from - bar ?to - table)
   ;    :precondition (and
   ;       (at_waiter ?from)
   ;       (at_biscuit ?bi ?from)
   ;       (at_drink ?d ?to)
   ;       (free ?w)
   ;       (can_serve_biscuit ?bi ?d)
   ;    )
   ;    :effect (and
   ;       (serving_biscuit ?bi ?d ?to)
   ;       (not (free ?w))
   ;       (not (can_serve_biscuit ?bi ?d))
   ;       (assign
   ;          (move_time ?from ?to)
   ;          (/ (distance ?from ?to) 2))
   ;    )
   ; )

   ; (:process move_with_biscuit
   ;    :parameters (?bi - biscuit ?d - drink ?from - bar ?to - table)
   ;    :precondition (and
   ;       (serving_biscuit ?bi ?d ?to)
   ;    )
   ;    :effect (and
   ;       (decrease (move_time ?from ?to) #t)
   ;    )
   ; )

   ; (:event arrived_biscuit
   ;    :parameters (?w - waiter ?d - drink ?bi - biscuit ?from ?to - location)
   ;    :precondition (and
   ;       (serving_biscuit ?bi ?d ?to)
   ;       (<= (move_time ?from ?to) 0)
   ;    )
   ;    :effect (and
   ;       (at_waiter ?to)
   ;       (at_biscuit ?bi ?to)
   ;       (free ?w)
   ;       (not (at_waiter ?from))
   ;       (not (at_biscuit ?bi ?from))
   ;       (not (serving_biscuit ?bi ?d ?to))
   ;    )
   ; )

; DRINKING
   
   ; (:action request_to_clean
   ;    :parameters (?t - table ?d - drink)
   ;    :precondition (and
   ;       (at_drink ?d ?t)
   ;       (clean_request ?t)
   ;       (not (to_clean ?t))
   ;    )
   ;    :effect (and
   ;       (drinking ?t)
   ;       (not (clean_request ?t))
   ;       (assign (drinking_time ?t) 4)
   ;    )
   ; )
   
   ; (:process drinking_process
   ;    :parameters (?t - table ?d - drink)
   ;    :precondition (and
   ;       (drinking ?t)
   ;    )
   ;    :effect (and
   ;       (decrease (drinking_time ?t) #t)
   ;    )
   ; )

   ; (:event finish_drink
   ;    :parameters (?d - drink ?t - table)
   ;    :precondition (and
   ;       (drinking ?t)
   ;       (<= (drinking_time ?t) 0)
   ;    )
   ;    :effect (and
   ;       (to_clean ?t)
   ;       (not (drinking ?t))
   ;       (not (at_drink ?d ?t))
   ;    )
   ; )
)