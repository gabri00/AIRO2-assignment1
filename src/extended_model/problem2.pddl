(define (problem CoffeeShop_problem2)
    (:domain CoffeeShop)

    (:objects
        barman - barman
        waiter - waiter
        bar - bar
        table1 table2 table3 table4 - table
        drink1 drink2 drink3 drink4 - drink
        biscuit1 biscuit2 - biscuit
    )

    (:init
        ; define connection between locations (symmetric)
        (connected bar table1) (connected table1 bar)
        (connected bar table2) (connected table2 bar)
        ; (connected bar table3) (connected table3 bar)
        ; (connected bar table4) (connected table4 bar)

        (connected table1 table2) (connected table2 table1)
        (connected table1 table3) (connected table3 table1)
        (connected table1 table4) (connected table4 table1)

        (connected table2 table3) (connected table3 table2)
        (connected table2 table4) (connected table4 table2)

        (connected table3 table4) (connected table4 table3)

        ; define distance between two locations (symmetric)
        (= (distance bar table1) 2) (= (distance table1 bar) 2)
        (= (distance bar table2) 2) (= (distance table2 bar) 2)
        ; (= (distance bar table3) 4) (= (distance table3 bar) 4)
        ; (= (distance bar table4) 4) (= (distance table4 bar) 4)

        (= (distance table1 table2) 1) (= (distance table2 table1) 1)
        (= (distance table1 table3) 1) (= (distance table3 table1) 1)
        (= (distance table1 table4) 1) (= (distance table4 table1) 1)

        (= (distance table2 table3) 1) (= (distance table3 table2) 1)
        (= (distance table2 table4) 1) (= (distance table4 table2) 1)

        (= (distance table3 table4) 1) (= (distance table4 table3) 1)

        ; define the area of tables
        (= (table_area table1) 1)
        (= (table_area table2) 1)
        (= (table_area table3) 2)
        (= (table_area table4) 1)

        ; prevent the waiter to make random moves at the beginning
        (= (steps waiter) 0)

        ; barman and waiter initially free
        (free barman) (free waiter)

        ; waiter initially at bar
        (at_waiter bar)

        ; drinks to be served
        (cold drink1) (cold drink2)
        (warm drink3) (warm drink4)
        (= (drinks_to_serve_at_table table3) 4)

        ; biscuits to be served
        (pair drink1 biscuit1) (pair drink2 biscuit2)
        (at_biscuit biscuit1 bar) (at_biscuit biscuit2 bar)
        (= (biscuits_to_serve_at_table table3) 2)

        ; tables to clean
        (to_clean table1)
    )

    (:goal
        (and
            ; all drinks served at table3
            (at_drink drink1 table3) (at_drink drink2 table3)
            (at_drink drink3 table3) (at_drink drink4 table3)

            (at_biscuit biscuit1 table3) (at_biscuit biscuit2 table3)

            ; table1 cleaned
            (cleaned table1)
            ; table3 cleaned after drinks and biscuits have been consumed
            (cleaned table3)
        )
    )

    (:metric minimize(total-time))
)