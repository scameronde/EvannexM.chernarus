BASE_POS_DEFENCE = [];
BASE_POS_AIR_TRANSPORT_HELI = [];
BASE_POS_AIR_COMBAT_HELI = [];
BASE_POS_AIR_COMBAT_JET = [];
BASE_POS_GROUND_TRANSPORT_VEHICLE = [];
BASE_POS_GROUND_COMBAT_VEHICLE = [];
BASE_POS_GROUND_COMBAT_INFANTRY = [];

private _pos=[];
{
	_pos = markerPos _x;
	switch true do {
		case (_x regexMatch "spawn_base_defence_.*"): { BASE_POS_DEFENCE pushBack _pos; };
		case (_x regexMatch "spawn_air_transport_heli_.*"): { BASE_POS_AIR_TRANSPORT_HELI pushBack _pos; };
		case (_x regexMatch "spawn_air_combat_heli_.*"): { BASE_POS_AIR_COMBAT_HELI pushBack _pos; };
		case (_x regexMatch "spawn_air_combat_jet_.*"): { BASE_POS_AIR_COMBAT_JET pushBack _pos; };
		case (_x regexMatch "spawn_ground_transport_vehicle_.*"): { BASE_POS_GROUND_TRANSPORT_VEHICLE pushBack _pos; };
		case (_x regexMatch "spawn_ground_combat_vehicle_.*"): { BASE_POS_GROUND_COMBAT_VEHICLE pushBack _pos; };
		case (_x regexMatch "spawn_ground_combat_infantry_.*"): { BASE_POS_GROUND_COMBAT_INFANTRY pushBack _pos; };
		case (_x regexMatch "friendly_base"): { BASE = _x; _x setMarkerAlpha 0; };
	};

} forEach allMapMarkers;
