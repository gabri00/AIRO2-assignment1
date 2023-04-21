(define (problem CoffeeShop_prob)
    (:domain CoffeeShop)

    (:objects
        barman - barman
        waiter - waiter
        bar - bar
        drink1 drink2 - drink
        biscuit1 biscuit2 - biscuit
        table1 table2 table3 table4 - table
    )

    (:init
        ; (= (distance bar table1) 2)
        (= (distance bar table2) 2)
        (= (distance bar table3) 4)
        (= (distance bar table4) 4)

        ; (= (distance table1 bar) 2)
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
        (= (table_area table3) 2)
        (= (table_area table4) 1)

        (free barman)
        (free waiter)

        (at_waiter bar)

        (cold drink1)
        (cold drink2)

        (can_serve_biscuit biscuit1 drink1)
        (can_serve_biscuit biscuit2 drink2)

        (to_clean table3)
        (to_clean table4)
    )

    (:goal
        (and
            (at_drink drink1 table2)
            (at_biscuit biscuit1 table2)
            
            (at_drink drink2 table2)
            (at_biscuit biscuit2 table2)

            (cleaned table3)
            (cleaned table4)
        )
    )

    (:metric minimize(total-time))
)

; 1 sec di consegna drink sbagliato e move a caso 1 volta