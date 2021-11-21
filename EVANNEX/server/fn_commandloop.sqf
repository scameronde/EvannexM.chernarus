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
	private _pos=[];
	{
		_pos = markerPos _x;
		switch true do {
			case (_x regexMatch "defence_spawn_.*"): { BASE_POS_DEFENCE pushBack _pos; };
			case (_x regexMatch "helicopter_transport_.*"): { BASE_POS_BASE_HELI_TRANSPORT pushBack _pos; };
			case (_x regexMatch "vehicle_transport_spawn_.*"): { BASE_POS_GROUND_TRANSPORT pushBack _pos; };
		};

	} forEach allMapMarkers;
};

private _addCommandsForBaseMarkers = {
	{
		[COMMAND_SPAWN_BASE_DEFENCE] call EVANNEX_fnc_commandqueue_push;
	} forEach BASE_POS_DEFENCE;

	{
		[COMMAND_SPAWN_HELI_TRANSPORT] call EVANNEX_fnc_commandqueue_push;
	} forEach BASE_POS_BASE_HELI_TRANSPORT;

	{
		[COMMAND_SPAWN_GROUND_TRANSPORT] call EVANNEX_fnc_commandqueue_push;
	} forEach BASE_POS_GROUND_TRANSPORT;
};

private _findEmptyPosition = {
	params ["_positionsToCheck", "_unitType"];
	private _found=[];
	
	{
      if (count (_x findEmptyPosition [0, 0, _unitType]) > 0) exitWith {
		  _found = _x;
	  };
	} forEach _positionsToCheck;

	_found;
};

private _spawnBaseDefence = {
	private _baseDefence = selectRandom (SPAWNLISTS_FRIENDLY get SPAWNLIST_FRIENDLY_BASE_DEFENCE);
	private _pos = [BASE_POS_DEFENCE, _baseDefence] call _findEmptyPosition;
	if (count _pos > 0) then {
		hint "Spawning Base Defence at position";

		private _vehicle = _baseDefence createVehicle _pos;
		private _group = createVehicleCrew _vehicle;
		{
			_x setBehaviour "AWARE";
			_x setSkill 0.7; // TODO: use config
			_x disableAI "PATH";
			// [_x] call fn_objectInitEvents;
		} forEach (crew _vehicle);

		{
			_x addCuratorEditableObjects [[_vehicle], true];
		} forEach allCurators;
	}
	else {
		hint "No empty position for Base Defence found";
	};
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
				call _spawnBaseDefence;
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
