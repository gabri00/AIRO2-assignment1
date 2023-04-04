(define (problem CoffeeShop_prob)
    (:domain CoffeeShop)

    (:objects
        barman - barman
        waiter - waiter
        bar - bar
        table1 table2 table3 table4 - table
        costumer1 costumer2 - costumer
        drink1 drink2 - drink
        biscuit1 biscuit2 - biscuit ; 1 x cold drink
    )

    (:init
        (free barman)
        (free waiter)

        (at_waiter waiter bar)

        (= (distance bar table1) 2)
        (= (distance bar table2) 2)
        (= (distance bar table3) 4)
        (= (distance bar table4) 4)

        (= (table_area table1) 1)
        (= (table_area table2) 1)
        (= (table_area table3) 2)
        (= (table_area table4) 1)

        (= (drinking_time drink1 costumer1) 4)
        (= (drinking_time drink2 costumer2) 4)

        ; Problem dependent initial state
        (cold drink1)
        (cold drink2)

        (to_clean table3)
        (to_clean table4)

        (at_costumer costumer1 table2)
        (at_costumer costumer2 table2)

        (= (cleaning_time table3) 4)
        (= (cleaning_time table4) 2)
    )

    (:goal
        (and
            ; (ready_drink drink1)
            ; (ready_drink drink2)
            (at_drink drink1 table2)
            (at_drink drink2 table2)

            ; (cleaned table3)
            ; (cleaned table4)
        )
    )

    (:metric minimize(total-time))
)