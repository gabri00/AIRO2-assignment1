(define (problem instance_5_1_3)
  (:domain mt-plant-watering-constrained)
  (:objects
    agent1 - agent
	tap1 - tap
	plant1 - plant
  )

  (:init
    (= (max_int) 20)
	(= (maxx) 5)
	(= (minx) 1)
	(= (maxy) 5)
	(= (miny) 1)
	(= (carrying) 0)
	(= (total_poured) 0)
	(= (total_loaded) 0)
	(= (poured plant1) 0)
	(= (x agent1) 4)
	(= (y agent1) 2)
	(= (x plant1) 1)
	(= (y plant1) 1)
	(= (x tap1) 5)
	(= (y tap1) 5)
  )

  (:goal (and 
    (= (poured plant1) 9)
	(= (total_poured) (poured plant1) )
  ))

  
  

  
)
