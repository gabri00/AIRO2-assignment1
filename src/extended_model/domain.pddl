(define (domain CoffeeShop)

   (:requirements
      :strips                    ; basic actions
      :typing                    ; types for objects
      :fluents                   ; numeric fluents
      :negative-preconditions    ; not in preconditions
      :equality                  ; equal to compare objects
      :time                      ; processes and events
      :conditional-effects       ; when in action effects
      ; :disjunctive-preconditions ; or in preconditions
      ; :universal-preconditions   ; forall and exists in preconditions
   )

   (:types
      barman waiter - robot
      table bar - location
      drink
      biscuit
   )

   (:predicates
      ; Drink predicates
      (cold ?d - drink)
      (warm ?d - drink)
      (ready_drink ?d - drink)
      (preparing ?d - drink)
      (serving ?d - drink)
      (cooling ?d - drink)
      (cooled ?d - drink)
      (at_drink ?d - drink ?l - location)

      ; Finish drink predicates
      (drinking ?t - table)
      (finished_drinking ?t - table)

      ; Robot predicates
      (free ?r - robot)
      (at_waiter ?l - location)

      ; Move predicates
      (connected ?from ?to - location)
      (moving ?from ?to - location)

      ; Clean predicates
      (to_clean ?t - table)
      (cleaning ?t - table)
      (cleaned ?t - table)
   
      ; Biscuit predicates
      (serving_biscuit ?b - biscuit)
      (pair ?d - drink ?b - biscuit)
      (at_biscuit ?b - biscuit ?l - location)

      ; Flag to prioritize warm drinks
      (priority_warm)
   )

   (:functions
      (distance ?from ?to - location)  ; distance between two locations
      (table_area ?t - table)          ; area of a table
      (move_time ?from ?to - location) ; time to move between two locations
      (cleaning_time ?t - table)       ; time to clean a table
      (prep_time ?d - drink)         ; time to prepare a drink
      (steps ?w)                    ; number of steps a waiter can do
      (cooling_time ?d - drink)     ; time to cool a drink
      (drinking_time ?t - drink)       ; time to drink a drink
      (drinks_to_serve_at_table ?t - table)     ; number of drinks to serve at a table
      (biscuits_to_serve_at_table ?t - table)   ; number of biscuits to serve at a table
   )

; MOVE WAITER

   (:action move_start
      :parameters (?from ?to - location ?w - waiter)
      :precondition (and
         (connected ?from ?to)
         (at_waiter ?from)
         (not (moving ?from ?to))
         (> (steps ?w) 0)
      )
      :effect (and
         (moving ?from ?to)
         (not (at_waiter ?from))
         (assign (move_time ?from ?to) (/ (distance ?from ?to) 2))
      )
   )

   (:process move_process
      :parameters (?from ?to - location)
      :precondition (and
         (moving ?from ?to)
      )
      :effect (and
         (decrease (move_time ?from ?to) #t)
      )
   )

   (:event move_end
      :parameters (?from ?to - location ?w - waiter)
      :precondition (and
         (moving ?from ?to)
         (<= (move_time ?from ?to) 0)
      )
      :effect (and
         (at_waiter ?to)
         (not (moving ?from ?to))
         (decrease (steps ?w) 1)
      )
   )

; CLEAN TABLE

   (:action clean_table_start
      :parameters (?t - table ?w - waiter)
      :precondition (and
         (free ?w)
         (at_waiter ?t)
         (to_clean ?t)
         (not (cleaning ?t))
         (not (cleaned ?t))
         (not (priority_warm))
      )
      :effect (and
         (cleaning ?t)
         (not (to_clean ?t))
         (not (free ?w))
         (assign (cleaning_time ?t) (* (table_area ?t) 2))
      )
   )

   (:process clean_table_process
      :parameters (?t - table ?w - waiter)
      :precondition (and
         (cleaning ?t)
         (at_waiter ?t)
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
      )
      :effect (and
         (free ?w)
         (cleaned ?t)
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
         (not (priority_warm))
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
      :parameters (?d - drink ?l - bar)
      :precondition (and
         (preparing ?d)
         (<= (prep_time ?d) 0)
      )
      :effect (and
         (ready_drink ?d)
         (at_drink ?d ?l)
         (when (warm ?d) (priority_warm))
         (not (preparing ?d))
      )
   )

; SERVE DRINK

   (:action pick_drink
      :parameters (?d - drink ?l - bar ?w - waiter)
      :precondition (and
         (free ?w)
         (at_waiter ?l)
         (ready_drink ?d)
         (at_drink ?d ?l)
         (not (serving ?d))
      )
      :effect (and
         (serving ?d)
         (not (free ?w))
         (not (at_drink ?d ?l))
         (assign (steps ?w) 2)
      )
   )

   (:action serve_drink
      :parameters (?w - waiter ?d - drink ?t - table ?b - barman)
      :precondition (and
         (serving ?d)
         (at_waiter ?t)
         (not (free ?w))
         (not (at_drink ?d ?t))
      )
      :effect (and
         (free ?b)
         (free ?w)
         (at_drink ?d ?t)
         (not (serving ?d))
         (assign (steps ?w) 2)
         (decrease (drinks_to_serve_at_table ?t) 1)
      )
   )

; SERVE BISCUIT

   (:action pick_biscuit
      :parameters (?w - waiter ?l - bar ?t - table ?b - biscuit ?d - drink)
      :precondition (and
         (free ?w)
         (cold ?d)
         (at_waiter ?l)
         (pair ?d ?b)
         (at_biscuit ?b ?l)
         (at_drink ?d ?t)
         (not (serving_biscuit ?b))
         (not (priority_warm))
      )
      :effect (and
         (serving_biscuit ?b)
         (not (free ?w))
         (not (at_biscuit ?b ?l))
         (assign (steps ?w) 2)
      )
   )

   (:action serve_biscuit
      :parameters (?w - waiter ?t - table ?d - drink ?b - biscuit)
      :precondition (and
         (pair ?d ?b)
         (at_waiter ?t)
         (serving_biscuit ?b)
         (not (free ?w))
         (not (at_biscuit ?b ?t))
         (not (priority_warm))
      )
      :effect (and
         (free ?w)
         (at_biscuit ?b ?t)
         (not (serving_biscuit ?b))
         (assign (steps ?w) 2)
         (decrease (biscuits_to_serve_at_table ?t) 1)
      )
   )

; COOLING

   (:event cooling_start
      :parameters (?d - drink ?l - bar)
      :precondition (and
         (warm ?d)
         (ready_drink ?d)
         (at_drink ?d ?l)
         (priority_warm)
         (not (preparing ?d))
         (not (cooling ?d))
         (not (cooled ?d))
      )
      :effect (and
         (cooling ?d)
         (assign (cooling_time ?d) 4)
      )
   )

   (:process cooling_process
      :parameters (?d - drink)
      :precondition (and
         (cooling ?d)
      )
      :effect (and
         (decrease (cooling_time ?d) #t)
      )
   )

   (:event cooling_end
      :parameters (?d - drink)
      :precondition (and
         (cooling ?d)
         (<= (cooling_time ?d) 0)
      )
      :effect (and
         (cooled ?d)
         (not (cooling ?d))
      )
   )

   (:event cooling_cancel
      :parameters (?d - drink ?t - table)
      :precondition (and
         (cooling ?d)
         (at_drink ?d ?t)
         (>= (cooling_time ?d) 0)
      )
      :effect (and
         (not (cooling ?d))
         (not (priority_warm))
      )
   )

; DRINKING

   (:action drinking_start
      :parameters (?t - table)
      :precondition (and
         (not (drinking ?t))
         (not (finished_drinking ?t))
         (= (drinks_to_serve_at_table ?t) 0)
      )
      :effect (and
         (drinking ?t)
         (assign (drinking_time ?t) 4)
      )
   )

   (:process drinking_process
      :parameters (?t - table)
      :precondition (and
         (drinking ?t)
      )
      :effect (and
         (decrease (drinking_time ?t) #t)
      )
   )

   (:event drinking_end
      :parameters (?t - table)
      :precondition (and
         (drinking ?t)
         (<= (drinking_time ?t) 0)
      )
      :effect (and
         (not (drinking ?t))
         (finished_drinking ?t)
      )
   )

   (:action clean_request
      :parameters (?t - table)
      :precondition (and
         (finished_drinking ?t)
         (= (drinks_to_serve_at_table ?t) 0)
         (= (biscuits_to_serve_at_table ?t) 0)
      )
      :effect (and
         (to_clean ?t)
      )
   )
)