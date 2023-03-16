(define (problem problem1)
    (:domain CoffeShop)
   (:objects
    cold1 cold2 - cold
    barman - barman
    bar - bar 
    )

    (:init

        (free barman)

        (= (shaking_time cold1) 0)
        (= (shaking_time cold2) 0)

        

    )

    (:goal (and
        (at_drink cold1 bar)
        (at_drink cold2 bar)
            
        )   
            
    )
    

    (:metric minimize(total-time))
)
