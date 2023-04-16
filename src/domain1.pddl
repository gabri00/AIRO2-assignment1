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

      ; Biscuit predicates
      (can_serve_biscuit ?bi - biscuit ?d - drink)

      ; Spatial predicates
      (at_waiter ?l - location)
      (at_drink ?d - drink ?l - location)
      (at_biscuit ?bi - biscuit ?l - location)

      (free ?r - robot)

      (to_clean ?t - table)
      (cleaned ?t - table)

      (ready_drink ?d - drink)
   
      (moving ?from ?to - location)
      (cleaning ?t - table)
      (preparing ?d - drink)
      (serving_drink ?d - drink ?t - table)
      (serving_biscuit ?bi - biscuit ?d - drink ?t - table)
   )

   (:functions
      (distance ?from ?to - location)
      (table_area ?t - table)
      (move_time ?from ?to - location)
      (cleaning_time ?t - table)
      (prep_time ?d - drink)
   )

; MOVE WAITER

   (:action move
      :parameters (?w - waiter ?from ?to - location)
      :precondition (and
         (free ?w)
         (at_waiter ?from)
      )
      :effect (and
         (moving ?from ?to)
         (not (free ?w))
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

   (:event arrived
      :parameters (?w - waiter ?from ?to - location)
      :precondition (and
         (moving ?from ?to)
         (<= (move_time ?from ?to) 0)
      )
      :effect (and
         (at_waiter ?to)
         (free ?w)
         (not (at_waiter ?from))
         (not (moving ?from ?to))
      )
   )

; CLEAN TABLE

   (:action clean_table
      :parameters (?t - table ?w - waiter)
      :precondition (and
         (at_waiter ?t)
         (to_clean ?t)
         (free ?w)
      )
      :effect (and
         (cleaning ?t)
         (not (to_clean ?t))
         (not (free ?w))
         (assign (cleaning_time ?t) (* (table_area ?t) 2))
      )
   )

   (:process clean_process
      :parameters (?t - table)
      :precondition (and
         (cleaning ?t)
      )
      :effect (and
         (decrease (cleaning_time ?t) #t)
      )
   )

   (:event cleaned_table
      :parameters (?t - table ?w - waiter)
      :precondition (and
         (cleaning ?t)
         (<= (cleaning_time ?t) 0)
      )
      :effect (and
         (cleaned ?t)
         (free ?w)
         (not (cleaning ?t))
      )
   )

; PREPARE DRINK

   (:action prepare_drink_cold
      :parameters (?d - drink ?b - barman)
      :precondition (and
         (free ?b)
         (cold ?d)
         (not (ready_drink ?d))
      )
      :effect (and
         (preparing ?d)
         (not (free ?b))
         (assign (prep_time ?d) 3)
      )
   )

   (:action prepare_drink_warm
      :parameters (?d - drink ?b - barman)
      :precondition (and
         (free ?b)
         (warm ?d)
         (not (ready_drink ?d))
      )
      :effect (and
         (preparing ?d)
         (not (free ?b))
         (assign (prep_time ?d) 5)
      )
   )

   (:process prepare_drink_process
      :parameters (?d - drink)
      :precondition (and
         (preparing ?d)
         (> (prep_time ?d) 0)
      )
      :effect (and
         (decrease (prep_time ?d) #t)
      )
   )

   (:event finish_drink_prep
      :parameters (?d - drink ?b - barman ?l - bar ?bi - biscuit)
      :precondition (and
         (preparing ?d)
         (<= (prep_time ?d) 0)
      )
      :effect (and
         (free ?b)
         (ready_drink ?d)
         (at_drink ?d ?l)
         (when (cold ?d) (at_biscuit ?bi ?l))
         (not (preparing ?d))
      )
   )

; SERVE DRINK

   (:action serve_drink
      :parameters (?w - waiter ?d - drink ?from - bar ?to - table)
      :precondition (and
         (at_waiter ?from)
         (at_drink ?d ?from)
         (free ?w)
      )
      :effect (and
         (serving_drink ?d ?to)
         (not (free ?w))
         (assign
            (move_time ?from ?to)
            (/ (distance ?from ?to) 2))
      )
   )

   (:process move_with_drink
      :parameters (?d - drink ?from - bar ?to - table)
      :precondition (and
         (serving_drink ?d ?to)
      )
      :effect (and
         (decrease (move_time ?from ?to) #t)
      )
   )

   (:event arrived_drink
      :parameters (?w - waiter ?d - drink ?bi - biscuit ?from ?to - location)
      :precondition (and
         (serving_drink ?d ?to)
         (<= (move_time ?from ?to) 0)
      )
      :effect (and
         (at_waiter ?to)
         (at_drink ?d ?to)
         (free ?w)
         (when (cold ?d) (can_serve_biscuit ?bi ?d))
         (not (at_waiter ?from))
         (not (at_drink ?d ?from))
         (not (serving_drink ?d ?to))
      )
   )

; SERVE BISCUIT

   (:action serve_biscuit
      :parameters (?w - waiter ?d - drink ?bi - biscuit ?from - bar ?to - table)
      :precondition (and
         (at_waiter ?from)
         (at_biscuit ?bi ?from)
         (at_drink ?d ?to)
         (free ?w)
         (can_serve_biscuit ?bi ?d)
      )
      :effect (and
         (serving_biscuit ?bi ?d ?to)
         (not (free ?w))
         (not (can_serve_biscuit ?bi ?d))
         (assign
            (move_time ?from ?to)
            (/ (distance ?from ?to) 2))
      )
   )

   (:process move_with_biscuit
      :parameters (?bi - biscuit ?d - drink ?from - bar ?to - table)
      :precondition (and
         (serving_biscuit ?bi ?d ?to)
      )
      :effect (and
         (decrease (move_time ?from ?to) #t)
      )
   )

   (:event arrived_biscuit
      :parameters (?w - waiter ?d - drink ?bi - biscuit ?from ?to - location)
      :precondition (and
         (serving_biscuit ?bi ?d ?to)
         (<= (move_time ?from ?to) 0)
      )
      :effect (and
         (at_waiter ?to)
         (at_biscuit ?bi ?to)
         (free ?w)
         (not (at_waiter ?from))
         (not (at_biscuit ?bi ?from))
         (not (serving_biscuit ?bi ?d ?to))
      )
   )
)