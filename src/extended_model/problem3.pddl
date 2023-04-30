(define (problem CoffeeShop_problem3)
    (:domain CoffeeShop)

    (:objects
        barman - barman
        waiter - waiter
        bar - bar
        table1 table2 table3 table4 - table
        drink1 drink2 drink3 drink4 - drink
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

        ; drinks to serve
        (warm drink1) (warm drink2) (warm drink3) (warm drink4)
        (= (drinks_to_serve_at_table table1) 2)
        (= (drinks_to_serve_at_table table4) 2)

        ; all drinks are warm so no biscuits
        (= (biscuits_to_serve_at_table table1) 0)
        (= (biscuits_to_serve_at_table table4) 0)

        ; tables to clean
        (to_clean table3)
    )

    (:goal
        (and
            ; drink1 and drink2 served at table1
            (at_drink drink1 table1) (at_drink drink2 table1)
            ; drink3 and drink4 served at table4
            (at_drink drink3 table4) (at_drink drink4 table4)

            ; table3 cleaned
            (cleaned table3)
            ; table1 and table4 cleaned after drinks have been consumed
            (cleaned table1) (cleaned table4)
        )
    )

    (:metric minimize(total-time))
)