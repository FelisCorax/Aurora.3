
var/global/datum/elevator_controller/elevator_controller

/datum/elevator_controller
	var/list/elevators

/datum/elevator_controller/proc/process()
	for (var/datum/elevator/elevator in elevators)
		if (elevator.status)
			elevator.process()

/datum/elevator_controller/New()
	for (var/obj/effect/landmark/elevator_start/marker in world)
		if (marker.elevator_id)
			var/datum/elevator/new_elevator = new /datum/elevator(marker.elevator_id, marker.z)
			elevators += new_elevator

		qdel(marker)
