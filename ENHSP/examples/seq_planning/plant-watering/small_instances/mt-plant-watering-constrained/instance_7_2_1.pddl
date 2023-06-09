(define (problem instance_7_2_1)
  (:domain mt-plant-watering-constrained)
  (:objects
    tap1 - tap
	plant1 plant2 - plant
	agent1 - agent
  )

  (:init
    (= (max_int) 40)
	(= (maxx) 7)
	(= (minx) 1)
	(= (maxy) 7)
	(= (miny) 1)
	(= (carrying) 0)
	(= (total_poured) 0)
	(= (total_loaded) 0)
	(= (poured plant1) 0)
	(= (poured plant2) 0)
	(= (x agent1) 5)
	(= (y agent1) 6)
	(= (x tap1) 3)
	(= (y tap1) 3)
	(= (x plant1) 6)
	(= (y plant1) 6)
	(= (x plant2) 6)
	(= (y plant2) 6)
  )

  (:goal (and 
    (= (poured plant1) 6)
	(= (poured plant2) 5)
	(= (total_poured) (+ (poured plant1) (poured plant2)) )
  ))

  
  

  
)
