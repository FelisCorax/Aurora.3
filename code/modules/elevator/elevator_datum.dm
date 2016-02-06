var/global/list/station_floors = list("1" = 1, "7" = 0, "8" = -1)

#define MOVE_UP 1
#define MOVE_DOWN 2

#define EVENT_MOVE 1
#define EVENT_STARTUP 3

#define WAIT_BEFORE_START 100

/datum/elevator
	var/process_status = 0
	var/elevator_id = null
	var/current_floor
	var/next_floor
	var/stalled = 0
	var/list/elevator_zones
	var/list/elevator_doors
	var/list/floor_queue = list()

	var/next_event = 0
	var/next_event_time = 0

/datum/elevator/New(var/new_elevator_id, var/starting_level)
	if (!new_elevator_id || !starting_level)
		return

	..()

	warning("WE WERE CREATED! FEAR US!")

	elevator_id = new_elevator_id
	elevator_zones = list()

	for (var/area/elevator/check_zone in world)
		if (check_zone.elevator_id != elevator_id)
			continue

		if (!elevator_zones[check_zone.z])
			elevator_zones += check_zone.z
			elevator_zones[check_zone.z] = check_zone

	current_floor = starting_level

	next_event = EVENT_STARTUP

	process_status = 1

/datum/elevator/proc/process()
	if (!next_event)
		return

	if (world.time >= next_event_time)
		do_event()

/datum/elevator/proc/do_event()
	if (!next_event)
		next_event_time = 0
		return

	var/clear_event = 0

	switch (next_event)
		if (EVENT_STARTUP)
			clear_event = prepare_doors()

		if (EVENT_MOVE)
			clear_event = do_move()

	if (clear_event)
		next_event = 0
		next_event_time = 0

/datum/elevator/proc/prepare_doors()
	elevator_doors = list()

	for (var/obj/machinery/door/airlock/airlock in world)
		if (airlock.id_tag != "elevator_[elevator_id]")
			continue

		if (!elevator_doors[airlock.z])
			elevator_doors[airlock.z] = list()

		elevator_doors[airlock.z] += airlock

		if (airlock.z == current_floor)
			airlock.open()
			airlock.locked = 1
		else
			airlock.close()
			airlock.locked = 1

	return 1

/datum/elevator/proc/add_destination(var/destination)
	if (!destination)
		return 0

	if (!next_floor)
		next_floor = destination
		setup_move()
		return 1

	if (floor_queue.len && (destination in floor_queue))
		return 0

	floor_queue += destination
	return 1

/datum/elevator/proc/setup_move()
	if (!floor_queue.len)
		next_floor = null
		return

	//Deal with floor assignment
	if (floor_queue.len > 1)
		sortList(floor_queue)
		if (get_movement_direction() == MOVE_DOWN)
			reverselist(floor_queue)

	next_floor = floor_queue[1]

	floor_queue -= next_floor

	//Deal with setting up the event
	next_event = EVENT_MOVE
	next_event_time = world.time + WAIT_BEFORE_START

	return

/datum/elevator/proc/can_move()
	if (!elevator_doors.len || !elevator_doors[current_floor])
		return 0

	for (var/obj/machinery/door/airlock/airlock in elevator_doors[current_floor])
		airlock.locked = 0

		if (airlock.can_close())
			continue
		else
			return 0

	return 1

/datum/elevator/proc/do_move(var/forced = 0)
	if (!forced && !can_move())
		if (!stalled)
			stalled = 1

		return 0

	for (var/obj/machinery/door/airlock/airlock in elevator_doors[current_floor])
		airlock.close()
		airlock.locked = 1
		airlock.update_icon()

	var/area/start_location = elevator_zones[current_floor]
	var/area/end_location = elevator_zones[next_floor]

	start_location.move_contents_to(end_location, /turf/simulated/floor)

	if (stalled)
		stalled = 0

	current_floor = end_location.z

	setup_move()
	return 1

/datum/elevator/proc/get_movement_direction()
	if (!floor_queue.len)
		return 0

	if (station_floors[num2text(next_floor)] > current_floor)
		return MOVE_UP
	else
		return MOVE_DOWN

#undef MOVE_UP
#undef MOVE_DOWN

#undef EVENT_MOVE
#undef EVENT_STARTUP

#undef WAIT_BEFORE_START
