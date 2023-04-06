(define (problem problem1)
    (:domain coffeeshop)
   (:objects
    drink1 drink2 drink3 drink4 - drink
    barman - barman
    bar - bar
    t1 t2 t3 - table
    waiter1 - waiter
    grabber - grabber
    )

    (:init

        
        

        (cold drink1)
        (cold drink2)
        (warm drink3)
        (warm drink4)

        (at_agent waiter1 bar)
        
        (free grabber)
        (free waiter1)
        (free barman)

        (= (time_cold barman) 3)
        (= (time_warm  barman) 5)

        ; all possible distance
        (= (distance bar t1) 20)
        (= (distance bar t2) 20)
        
        
        (= (distance t1 bar) 20)
        (= (distance t2 bar) 20)

        (= (distance t1 t3) 6)
        (= (distance t3 t1) 6)
        
        (at_t t1)
        (at_t t2)
        (at_t t3)
        

    )

    (:goal (and
        
       ; (at_drink drink1 t3)
        (at_drink drink2 t3)
        ;(at_drink drink3 t3)
        
        ;(at_agent waiter1 bar)
            
        )   
            
    )
    

    ;(:metric minimize(total-time))
)

