/obj/machinery/computer3/elevator
	name = "elevator console"
	desc = "Allows you to select which floor you would like to go to."
	icon = 'icons/obj/computer.dmi'
	icon_state = "wallframe"
	show_keyboard = 0
	default_prog = /datum/file/program/elevator

	var/elevator_id = null

/obj/machinery/computer3/elevator/New()
	..()

	if (!elevator_id)
		warning("Elevator control computer with no elevator_id spawned! Coordiantes: [x], [y], [z].")

/datum/file/program/elevator
	name = "Elevator Control"
	desc = "A program which controls an elevator."
	active_state = "power"

	var/elevator_id = null

/datum/file/program/elevator/New()
	..()

/datum/file/program/elevator/interact()
	if (!interactable())
		return

	var/dat

	if (!elevator_id)
		dat = "<font color='red'>Error. Elevator control systems damaged.</font>"
	else

	popup.set_content(dat)
	popup.open()

/datum/file/program/elevator/Topic(href, list/href_list)
	if (!interactable() || ..(href,href_list))
		return
