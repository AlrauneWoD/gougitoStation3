/mob/living/brain/death(gibbed)
	if(stat == DEAD)
		return

	if(!gibbed && container)//If not gibbed but in a container.
		var/obj/item/mmi = container
		mmi.visible_message(
			message = span_warning("[src]'s MMI flatlines!"),
			blind_message = span_hear("You hear something flatline."),
		)
		mmi.update_appearance()

	return ..()

/mob/living/brain/gib()
	if(container)
		qdel(container)//Gets rid of the MMI if there is one
	if(loc)
		if(istype(loc, /obj/item/organ/internal/brain))
			qdel(loc)//Gets rid of the brain item
	..()
