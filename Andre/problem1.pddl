(define (problem problem1)
    (:domain coffeeshop)
   (:objects
    drink1 drink4 -drink
    barman - barman
    bar - bar
    t1 t2 t3 t4 -table
    waiter1 - waiter
    grabber - grabber
    )

    (:init

        (not(is_occupied barman))

        (cold drink1)
        
        (warm drink4)

        (at_agent waiter1 bar)
        (free grabber)

        (= (occupied_time barman) 3)
        (= (occupied_time_w barman) 5)

        ; all possible distance
        (= (distance bar t1) 2)
        
        
        (= (distance t1 bar) 2)
        

    )

    (:goal (and
        
        (at_drink drink1 t1)
        (at_drink drink4 t1)
        
            
        )   
            
    )
    

    (:metric minimize(total-time))
)
