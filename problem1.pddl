(define (problem problem1)
    (:domain CoffeShop)
   (:objects
    cold1 - cold
    barman - barman
    bar - bar 
    )

    (:init

        (free barman)

        (= (shaking_time barman) 0)



    )

    (:goal
        (at_drink cold1 bar)
            
            
            
    )
    

    (:metric minimize(total-time))
)
