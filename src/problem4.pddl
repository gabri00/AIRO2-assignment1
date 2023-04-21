(define (problem CoffeeShop_prob)
    (:domain CoffeeShop)

    (:objects
        barman - barman
        waiter - waiter
        bar - bar
        drink1 drink2 drink3 drink4 drink5 drink6 drink7 drink8 - drink
        biscuit1 biscuit2 biscuit3 biscuit4 biscuit5 biscuit6 biscuit7 biscuit8 - biscuit
        table1 table2 table3 table4 - table
    )

    (:init
        (= (distance bar table1) 2)
        (= (distance bar table2) 2)
        (= (distance bar table3) 4)
        (= (distance bar table4) 4)

        (= (distance table1 bar) 2)
        (= (distance table2 bar) 2)
        (= (distance table3 bar) 4)
        (= (distance table4 bar) 4)

        ; (= (distance table1 table2) 1)
        ; (= (distance table1 table3) 1)
        ; (= (distance table1 table4) 1)

        ; (= (distance table2 table1) 1)
        ; (= (distance table2 table3) 1)
        ; (= (distance table2 table4) 1)

        ; (= (distance table3 table1) 1)
        ; (= (distance table3 table2) 1)
        ; (= (distance table3 table4) 1)

        ; (= (distance table4 table1) 1)
        ; (= (distance table4 table2) 1)
        ; (= (distance table4 table3) 1)

        ; (= (table_area table1) 1)
        (= (table_area table2) 1)
        ; (= (table_area table3) 2)
        ; (= (table_area table4) 1)

        (free barman)
        (free waiter)

        (at_waiter bar)

        (cold drink1) (cold drink2) (cold drink3) (cold drink4)
        (warm drink5) (warm drink6) (warm drink7) (warm drink8)

        (can_serve_biscuit biscuit1 drink1)
        (can_serve_biscuit biscuit2 drink2)
        (can_serve_biscuit biscuit3 drink3)
        (can_serve_biscuit biscuit4 drink4)

        (to_clean table2)
    )

    (:goal
        (and
            (at_drink drink1 table1)
            (at_biscuit biscuit1 table1)
            
            (at_drink drink2 table1)
            (at_biscuit biscuit2 table1)

            (at_drink drink3 table4)
            (at_biscuit biscuit3 table4)

            (at_drink drink4 table4)
            (at_biscuit biscuit4 table4)

            (at_drink drink5 table3)
            (at_drink drink6 table3)
            (at_drink drink7 table3)
            (at_drink drink8 table3)

            (cleaned table2)
        )
    )

    (:metric minimize(total-time))
)