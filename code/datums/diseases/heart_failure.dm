/datum/disease/heart_failure
	form = "Condition"
	name = "Myocardial Infarction"
	max_stages = 5
	stage_prob = 1
	cure_text = "Heart replacement surgery to cure. Defibrillation (or as a last resort, uncontrolled electric shocking) may also be effective after the onset of cardiac arrest. Penthrite can also mitigate cardiac arrest."
	agent = "Shitty Heart"
	viable_mobtypes = list(/mob/living/carbon/human)
	spreading_modifier = 1
	desc = "If left untreated the subject will die!"
	severity = "Dangerous!"
	disease_flags = CAN_CARRY|CAN_RESIST
	spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
	spread_text = "Organ failure"
	visibility_flags = HIDDEN_PANDEMIC
	required_organ = ORGAN_SLOT_HEART
	bypasses_immunity = TRUE // Immunity is based on not having an appendix; this isn't a virus
	var/sound = FALSE

/datum/disease/heart_failure/Copy()
	var/datum/disease/heart_failure/D = ..()
	D.sound = sound
	return D


/datum/disease/heart_failure/stage_act(seconds_per_tick, times_fired)
	. = ..()
	if(!.)
		return

	if(!affected_mob.can_heartattack())
		cure()
		return FALSE

	switch(stage)
		if(1 to 2)
			if(SPT_PROB(1, seconds_per_tick))
				to_chat(affected_mob, span_warning("You feel [pick("discomfort", "pressure", "a burning sensation", "pain")] in your chest."))
			if(SPT_PROB(1, seconds_per_tick))
				to_chat(affected_mob, span_warning("You feel dizzy."))
				affected_mob.adjust_confusion(6 SECONDS)
			if(SPT_PROB(1.5, seconds_per_tick))
				to_chat(affected_mob, span_warning("You feel [pick("full", "nauseated", "sweaty", "weak", "tired", "short of breath", "uneasy")]."))
		if(3 to 4)
			if(!sound)
				affected_mob.playsound_local(affected_mob, 'sound/health/slowbeat.ogg', 40, FALSE, channel = CHANNEL_HEARTBEAT, use_reverb = FALSE)
				sound = TRUE
			if(SPT_PROB(1.5, seconds_per_tick))
				to_chat(affected_mob, span_danger("You feel a sharp pain in your chest!"))
				if(prob(25))
					affected_mob.vomit(VOMIT_CATEGORY_DEFAULT, lost_nutrition = 95)
				affected_mob.emote("cough")
				affected_mob.Paralyze(40)
				affected_mob.losebreath += 4
			if(SPT_PROB(1.5, seconds_per_tick))
				to_chat(affected_mob, span_danger("You feel very weak and dizzy..."))
				affected_mob.adjust_confusion(8 SECONDS)
				affected_mob.apply_damage(40, STAMINA, BODY_ZONE_CHEST)
				affected_mob.emote("cough")
		if(5)
			affected_mob.stop_sound_channel(CHANNEL_HEARTBEAT)
			affected_mob.playsound_local(affected_mob, 'sound/effects/singlebeat.ogg', 100, FALSE, use_reverb = FALSE)
			if(affected_mob.stat == CONSCIOUS)
				affected_mob.visible_message(span_danger("[affected_mob] clutches at [affected_mob.p_their()] chest as if [affected_mob.p_their()] heart is stopping!"), \
					span_userdanger("You feel a terrible pain in your chest, as if your heart has stopped!"))
			affected_mob.apply_damage(60, STAMINA, BODY_ZONE_CHEST)
			affected_mob.set_heartattack(TRUE)
			affected_mob.reagents.add_reagent(/datum/reagent/medicine/c2/penthrite, 3) // To give the victim a final chance to shock their heart before losing consciousness
			cure()
			return FALSE
