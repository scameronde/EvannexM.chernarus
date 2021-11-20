// the fifo queue
COMMANDQUEUE = [];

// possible entry types
COMMAND_EMPTY = "empty";
COMMAND_BUILD_BASE = "build base";
COMMAND_BUILD_ZONE = "build zone";
COMMAND_DELETE_ZONE = "delete zone";
COMMAND_SPAWN_BASE_DEFENCE = "spawn base defence";
COMMAND_SPAWN_HELI_TRANSPORT = "spawn heli transport";
COMMAND_SPAWN_GROUND_TRANSPORT = "spawn ground transport";


private _command=COMMAND_EMPTY;

private _scanMapForBaseMarkers = {
	{
		switch true do {
			case (_x regexMatch "defence_spawn_.*"): { MARKERS_BASE_DEFENCE pushBack _x; };
			case (_x regexMatch "helicopter_transport_.*"): { MARKERS_BASE_HELI_TRANSPORT pushBack _x; };
			case (_x regexMatch "vehicle_transport_spawn_.*"): { MARKERS_BASE_GROUND_TRANSPORT pushBack _x; };
		};

	} forEach allMapMarkers;
};

private _addCommandsForBaseMarkers = {
	{
		[COMMAND_SPAWN_BASE_DEFENCE] call EVANNEX_fnc_commandqueue_push;
	} forEach MARKERS_BASE_DEFENCE;

	{
		[COMMAND_SPAWN_HELI_TRANSPORT] call EVANNEX_fnc_commandqueue_push;
	} forEach MARKERS_BASE_HELI_TRANSPORT;

	{
		[COMMAND_SPAWN_GROUND_TRANSPORT] call EVANNEX_fnc_commandqueue_push;
	} forEach MARKERS_BASE_GROUND_TRANSPORT;
};


if (isServer) then {
	while { true } do {
		_command = (call EVANNEX_fnc_commandqueue_pop);
		switch (_command) do {
			case COMMAND_EMPTY: { hint _command; };
			case COMMAND_BUILD_BASE: {
				hint "Processing Map";
				call _scanMapForBaseMarkers;
				call _addCommandsForBaseMarkers;
			};
			case COMMAND_BUILD_ZONE: {
				hint "Building Zone";
			};
			case COMMAND_SPAWN_BASE_DEFENCE: {
				hint "Spawn Base Defence";
			};
			case COMMAND_SPAWN_HELI_TRANSPORT: {
				hint "Spawn Heli Transport";
			};
			case COMMAND_SPAWN_GROUND_TRANSPORT: {
				hint "Spawn Ground Transport";
			};
			default { hint _command; };
		};
		sleep 1;
	};
};
