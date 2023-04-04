(define (domain CoffeeShop)

   (:requirements
      :strips                    ;basic actions
      :typing                    ;types for objects
      :fluents                   ;numeric fluents
      :negative-preconditions    ;not in preconditions
      :disjunctive-preconditions ;or in preconditions
      :universal-preconditions   ;foreach and exists in preconditions
      :equality                  ;equal to compare objects
      :conditional-effects       ;when in action effects
      :time                      ;processes and events
   )

   (:types
      barman waiter - robot
      drink biscuit - food
      costumer
      table bar - location
   )

   (:predicates
      ; Drink predicates
      (cold ?d - drink)
      (warm ?d - drink)

      ; Spatial predicates
      (at_drink ?d - drink ?l - location)
      (at_biscuit ?f - biscuit ?l - location)
      (at_waiter ?w - waiter ?l - location)
      (at_costumer ?c - costumer ?t - table)

      (free ?r - robot)

      (prepare_drink ?d - drink)
      (serving_drink ?d - drink ?w - waiter ?t - table)
      (serving_biscuit ?f - biscuit ?w - waiter ?t - table)
      (drinking ?d - drink ?c - customer)
      (moving ?w - waiter)

      (ready_drink ?d - drink)

      (to_clean ?t - table)
      (cleaned ?t - table)
   )

   (:functions
      (distance ?l1 ?l2 - location)
      (table_area ?t - table)
      (prep_time ?d - drink)
      (move_time ?w - waiter) ; distance / speed
      (drinking_time ?d - drink ?c - customer)
      (cleaning_time ?t - table)
      (cooling_time ?d - drink)
   )
   
   (:process move
      :parameters (?w - waiter ?l1 ?l2 - location)
      :precondition (and
         (at_waiter ?w ?l1)
      )
      :effect (and
         (decrease (distance ?l1 ?l2) (* #t 2))
      )
   )

   (:action end_move
      :parameters (?w - waiter ?l1 ?l2 - location)
      :precondition (and
         (<= (distance ?l1 ?l2) 0)
      )
      :effect (and
         (at_waiter ?w ?l2)
         (not (at_waiter ?w ?l1))
      )
   )

   (:action prepare_drink
      :parameters (?d - drink ?b - barman)
      :precondition (and
         (free ?b)
         (not (ready_drink ?d))
      )
      :effect (and
         (prepare_drink ?d)
         (not (free ?b))
         (when (cold ?d) (assign (prep_time ?d) 3))
         (when (warm ?d) (assign (prep_time ?d) 5))
      )
   )

   (:process shake_drink
      :parameters (?d - drink)
      :precondition (and
         (prepare_drink ?d)
      )
      :effect (and
         (decrease (prep_time ?d) #t)
      )
   )

   (:action put_on_counter
      :parameters (?d - drink ?b - barman ?l - bar ?f - biscuit)
      :precondition (and
         (<= (prep_time ?d) 0)
         (prepare_drink ?d)
         (not (free ?b))
      )
      :effect (and
         (free ?b)
         (ready_drink ?d)
         (at_drink ?d ?l)
         (not (prepare_drink ?d))
         ; (when (cold ?d) (at_biscuit ?f ?l))
         ; (when (warm ?d) (assign (cooling_time ?d) 4))
      )
   )

   (:action take_drink
      :parameters (?d - drink ?w - waiter ?l - bar ?t - table)
      :precondition (and
         (ready_drink ?d)
         (at_drink ?d ?l)
         (at_waiter ?w ?l)
         (free ?w)
      )
      :effect (and
         (serving_drink ?d ?w ?t)
         (not (at_drink ?d ?l))
         (not (free ?w))
      )
   )

   (:action serve_drink
      :parameters (?w - waiter ?t - table ?l - bar ?d - drink ?c - customer)
      :precondition (and
         (serving_drink ?d ?w ?t)
         (at_waiter ?w ?t)
         (at_costumer ?c ?t)
         (not (free ?w))
         ; (<= (move_time ?w) 0)
      )
      :effect (and
         (at_drink ?d ?t)
         (free ?w)
         ; (drinking ?d ?c)
         (not (serving_drink ?d ?w ?t))
      )
   )

   ; (:action take_biscuit
   ;    :parameters (?f - biscuit ?w - waiter ?l - bar ?t - table)
   ;    :precondition (and
   ;       (at_biscuit ?f ?l)
   ;       (at_waiter ?w ?l)
   ;       (free ?w)
   ;    )
   ;    :effect (and
   ;       ; (serving_biscuit ?f ?w ?t)
   ;       (not (at_biscuit ?f ?l))
   ;       ; (not (at_waiter ?w ?l))
   ;       (not (free ?w))
   ;       ; (assign (move_time ?w) (/ (distance ?l ?t) 2))
   ;    )
   ; )

   ; (:action serve_biscuit
   ;    :parameters (?w - waiter ?t - table ?l - bar ?f - biscuit ?c - customer)
   ;    :precondition (and
   ;       ; (serving_biscuit ?f ?w ?t)
   ;       (at_waiter ?w ?t)
   ;       (at_costumer ?c ?t)
   ;       ; (<= (move_time ?w) 0)
   ;    )
   ;    :effect (and
   ;       (at_biscuit ?f ?t)
   ;       ; (at_waiter ?w ?t)
   ;       (free ?w)
   ;       ; (not (serving_biscuit ?f ?w ?t))
   ;       ; (assign (move_time ?w) (/ (distance ?l ?t) 2))
   ;    )
   ; )

   ; ; (:process drinking_process
   ; ;    :parameters (?c - customer ?d - drink)
   ; ;    :precondition (and
   ; ;       (drinking ?d ?c)
   ; ;       (> (drinking_time ?d ?c) 0)
   ; ;    )
   ; ;    :effect (and
   ; ;       (decrease (drinking_time ?d ?c) #t)
   ; ;    )
   ; ; )

   ; ; (:action finish_drink
   ; ;    :parameters (?c - customer ?d - drink ?t - table)
   ; ;    :precondition (and
   ; ;       (drinking ?d ?c)
   ; ;       (<= (drinking_time ?d ?c) 0)
   ; ;    )
   ; ;    :effect (and
   ; ;       (not (drinking ?d ?c))
   ; ;       (to_clean ?t)
   ; ;       (assign (move_time ?w) (/ (distance ?l ?t) 2))
   ; ;       (assign (drinking_time ?d ?c) 4)
   ; ;    )
   ; ; )
 
   ; (:process clean
   ;    :parameters (?t - table ?w - waiter)
   ;    :precondition (and
   ;       (to_clean ?t)
   ;       (at_waiter ?w ?t)
   ;       (> (cleaning_time ?t) 0)
   ;    )
   ;    :effect (and
   ;       (decrease (cleaning_time ?t) #t)
   ;    )
   ; )

   ; (:action cleaned_table
   ;    :parameters (?t - table ?w - waiter)
   ;    :precondition (and
   ;       (to_clean ?t)
   ;       (at_waiter ?w ?t)
   ;       (<= (cleaning_time ?t) 0)
   ;    )
   ;    :effect (and
   ;       (cleaned ?t)
   ;       (not (to_clean ?t))
   ;    )
   ; )
   
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
   
   ; (:action remake_drink
   ;    :parameters (?d - drink ?b - barman)
   ;    :precondition (and
   ;       (warm ?d)
   ;       (ready_drink ?d)
   ;       (<= (cooling_time ?d) 0)
   ;    )
   ;    :effect (and
   ;       (not (ready_drink ?d))
   ;       (assign (prep_time ?d) 5)
   ;    )
   ; )
)