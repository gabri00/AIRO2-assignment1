(define (problem problem1)
    (:domain coffeeshop)
   (:objects
    drink1 drink2 drink3 -drink
    barman - barman
    )

    (:init

        (not(is_occupied barman))

        (cold drink1)
        (cold drink2)
        (cold drink3)

        (= (occupied_time barman) 3)

        

    )

    (:goal (and
        (ready drink1)
        (ready drink2)
        (ready drink3)
            
        )   
            
    )
    

    (:metric minimize(total-time))
)
