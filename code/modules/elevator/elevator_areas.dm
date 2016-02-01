// Elevator areas
/area/elevator
	name = "\proper Elevator Shaft"
	icon_state = "tcommsatwest"
	var/elevator_id

/area/elevator/New()
	..()

	if (!elevator_id)
		warning("Elevator area spawned without elevator_id on z-level [z]!")

/area/elevator/first
	elevator_id = 1

/area/elevator/first/surface
/area/elevator/first/main
/area/elevator/first/sub

/area/elevator/second
	elevator_id = 2

/area/elevator/second/surface
/area/elevator/second/main
/area/elevator/second/sub

/area/elevator/third
	elevator_id = 3

/area/elevator/third/surface
/area/elevator/third/main

/area/elevator/fourth
	elevator_id = 4

/area/elevator/fourth/main
/area/elevator/fourth/sub
