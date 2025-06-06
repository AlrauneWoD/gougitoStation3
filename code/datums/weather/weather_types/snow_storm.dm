/datum/weather/snow_storm
	name = "snow storm"
	desc = "Harsh snowstorms roam the topside of this arctic planet, burying any area unfortunate enough to be in its path."
	probability = 90

	telegraph_message = "<span class='warning'>Drifting particles of snow begin to dust the surrounding area..</span>"
	telegraph_duration = 300
	telegraph_overlay = "light_snow"
	telegraph_sound = 'sound/ambience/weather/snowstorm/snow_start.ogg'
	telegraph_sound_vol = /datum/looping_sound/snowstorm::volume + 10

	weather_message = "<span class='userdanger'><i>Harsh winds pick up as dense snow begins to fall from the sky! Seek shelter!</i></span>"
	weather_overlay = "snow_storm"
	weather_duration_lower = 600
	weather_duration_upper = 1500

	end_duration = 10 SECONDS
	end_message = span_bolddanger("The snowfall dies down, it should be safe to go outside again.")
	end_sound = 'sound/ambience/weather/snowstorm/snow_end.ogg'
	end_sound_vol = /datum/looping_sound/snowstorm::volume + 10

	area_type = /area
	protect_indoors = TRUE
	target_trait = ZTRAIT_SNOWSTORM

	immunity_type = TRAIT_SNOWSTORM_IMMUNE

	barometer_predictable = TRUE

	///Lowest we can cool someone randomly per weather act. Positive values only
	var/cooling_lower = 0.25 KELVIN
	///Highest we can cool someone randomly per weather act. Positive values only
	var/cooling_upper = 0.75 KELVIN

/datum/weather/snow_storm/weather_act(mob/living/living)
	living.adjust_body_temperature(-rand(cooling_lower, cooling_upper))

/datum/weather/snow_storm/start()
	GLOB.snowstorm_sounds.Cut() // it's passed by ref
	for(var/area/impacted_area as anything in impacted_areas)
		GLOB.snowstorm_sounds[impacted_area] = /datum/looping_sound/snowstorm
	return ..()

/datum/weather/snow_storm/end()
	GLOB.snowstorm_sounds.Cut()
	return ..()

// since snowstorm is on a station z level, add extra checks to not annoy everyone
/datum/weather/snow_storm/can_get_alert(mob/player)
	if(!..())
		return FALSE

	if(!is_station_level(player.z))
		return TRUE // bypass checks

	if(isobserver(player))
		return TRUE

	if(HAS_MIND_TRAIT(player, TRAIT_DETECT_STORM))
		return TRUE

	if(istype(get_area(player), /area/mine))
		return TRUE

	for(var/area/snow_area in impacted_areas)
		if(locate(snow_area) in view(player))
			return TRUE

	return FALSE

///A storm that doesn't stop storming, and is a bit stronger
/datum/weather/snow_storm/forever_storm
	telegraph_duration = 0 SECONDS
	perpetual = TRUE

	probability = 0

	cooling_lower = 0.5 KELVIN
	cooling_upper = 1.5 KELVIN
