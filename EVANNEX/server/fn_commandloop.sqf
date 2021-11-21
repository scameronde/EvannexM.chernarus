// the fifo queue
COMMANDQUEUE = [];

// possible entry types
COMMAND_EMPTY = "empty";
COMMAND_RESET_GAME = "reset game";
COMMAND_BUILD_BASE = "build base";
COMMAND_BUILD_ZONE = "build zone";
COMMAND_DELETE_ZONE = "delete zone";
COMMAND_SPAWN_BASE_DEFENCE = "spawn base defence";
COMMAND_SPAWN_AIR_TRANSPORT = "spawn air transport";
COMMAND_SPAWN_GROUND_TRANSPORT = "spawn ground transport";
COMMAND_SPAWN_GROUND_COMBAT_VEHICLE = "spawn ground combat vehicle";
COMMAND_DELETE_KILLED_BASE_DEFENCE = "delete killed base defence";
COMMAND_DELETE_KILLED_AIR_TRANSPORT = "delete killed air transport";
COMMAND_DELETE_KILLED_GROUND_TRANSPORT = "delete killed ground transport";
COMMAND_DELETE_KILLED_GROUND_COMBAT_VEHICLE = "delete killed ground combat vehicle";

private _command=COMMAND_EMPTY;
private _commandParams=[];

private _scanMapForBaseMarkers = {
	private _pos=[];
	{
		_pos = markerPos _x;
		switch true do {
			case (_x regexMatch "defence_spawn_.*"): { BASE_POS_DEFENCE pushBack _pos; };
			case (_x regexMatch "helicopter_transport_.*"): { BASE_POS_HELI_TRANSPORT pushBack _pos; };
			case (_x regexMatch "vehicle_transport_spawn_.*"): { BASE_POS_GROUND_TRANSPORT pushBack _pos; };
			case (_x regexMatch "vehicle_spawn_.*"): { BASE_POS_GROUND_COMBAT_VEHICLE pushBack _pos; };
		};

	} forEach allMapMarkers;
};

private _addCommandsForBaseMarkers = {
	{
		[COMMAND_SPAWN_BASE_DEFENCE] call EVANNEX_fnc_commandqueue_push;
	} forEach BASE_POS_DEFENCE;

	{
		[COMMAND_SPAWN_AIR_TRANSPORT] call EVANNEX_fnc_commandqueue_push;
	} forEach BASE_POS_HELI_TRANSPORT;

	{
		[COMMAND_SPAWN_GROUND_TRANSPORT] call EVANNEX_fnc_commandqueue_push;
	} forEach BASE_POS_GROUND_TRANSPORT;

	{
		[COMMAND_SPAWN_GROUND_COMBAT_VEHICLE] call EVANNEX_fnc_commandqueue_push;
	} forEach BASE_POS_GROUND_COMBAT_VEHICLE;
};

private _findEmptyPosition = {
	params ["_positionsToCheck", "_unitType"];
	private _found=[];
	
	{
		_found = _x findEmptyPosition [0, 5, _unitType];
		if (count _found > 0) exitWith {
			_found;
		};
	} forEach _positionsToCheck;

	_found;
};

private _commandSpawnBaseDefence = {
	private _baseDefence = selectRandom (SPAWNLISTS_FRIENDLY get SPAWNLIST_FRIENDLY_BASE_DEFENCE);
	private _pos = [BASE_POS_DEFENCE, _baseDefence] call _findEmptyPosition;
	if (count _pos > 0) then {
		hint "Spawning base defence at position";

		private _vehicle = _baseDefence createVehicle _pos;
		private _group = createVehicleCrew _vehicle;
		{
			_x setBehaviour "AWARE";
			_x setSkill 0.7; // TODO: use config
			_x disableAI "PATH";
			//_x addEventHandler ["killed", "br_dead_objects pushBack (_this select 0);"];
		} forEach (crew _vehicle);
		_vehicle addEventHandler ["killed", "[[COMMAND_DELETE_KILLED_BASE_DEFENCE, [_this select 0, serverTime, 10]], COMMAND_SPAWN_BASE_DEFENCE] call EVANNEX_fnc_commandqueue_push;"];

		{
			_x addCuratorEditableObjects [[_vehicle], true];
		} forEach allCurators;
	}
	else {
		hint "No empty position for base defence found";
		// try again
		[COMMAND_SPAWN_BASE_DEFENCE] call EVANNEX_fnc_commandqueue_push;
	};
};

private _commandSpawnAirTransport = {
	private _heli = selectRandom (SPAWNLISTS_FRIENDLY get SPAWNLIST_FRIENDLY_AIR_TRANSPORT_VEHICLES);
	private _pos = [BASE_POS_HELI_TRANSPORT, _heli] call _findEmptyPosition;
	if (count _pos > 0) then {
		hint "Spawning air transport at position";

		private _vehicle = _heli createVehicle _pos;
		private _group = createVehicleCrew _vehicle;
		{
			_x setBehaviour "AWARE";
			_x setSkill 0.7; // TODO: use config
			_x disableAI "PATH";
			//_x addEventHandler ["killed", "br_dead_objects pushBack (_this select 0);"];
		} forEach (crew _vehicle);
		_vehicle addEventHandler ["killed", { [[COMMAND_DELETE_KILLED_AIR_TRANSPORT, [_this select 0, serverTime, 10]], COMMAND_SPAWN_AIR_TRANSPORT] call EVANNEX_fnc_commandqueue_push; }];

		{
			_x addCuratorEditableObjects [[_vehicle], true];
		} forEach allCurators;
	}
	else {
		hint "No empty position for air transport found";
		// try again
		[COMMAND_SPAWN_AIR_TRANSPORT] call EVANNEX_fnc_commandqueue_push;
	};
};

private _commandSpawnGroundTransport = {
	private _entity = selectRandom (SPAWNLISTS_FRIENDLY get SPAWNLIST_FRIENDLY_GROUND_TRANSPORT_VEHICLES);
	private _pos = [BASE_POS_GROUND_TRANSPORT, _entity] call _findEmptyPosition;
	if (count _pos > 0) then {
		hint "Spawning ground transport at position";

		private _vehicle = _entity createVehicle _pos;
		private _group = createVehicleCrew _vehicle;
		{
			_x setBehaviour "AWARE";
			_x setSkill 0.7; // TODO: use config
			_x disableAI "PATH";
			//_x addEventHandler ["killed", "br_dead_objects pushBack (_this select 0);"];
		} forEach (crew _vehicle);
		_vehicle addEventHandler ["killed", { [[COMMAND_DELETE_KILLED_GROUND_TRANSPORT, [_this select 0, serverTime, 10]], COMMAND_SPAWN_GROUND_TRANSPORT] call EVANNEX_fnc_commandqueue_push; }];

		{
			_x addCuratorEditableObjects [[_vehicle], true];
		} forEach allCurators;
	}
	else {
		hint "No empty position for ground transport found";
		// try again
		[COMMAND_SPAWN_GROUND_TRANSPORT] call EVANNEX_fnc_commandqueue_push;
	};
};

private _commandSpawnGroundCombatVehicle = {
	private _entity = selectRandom (SPAWNLISTS_FRIENDLY get SPAWNLIST_FRIENDLY_GROUND_COMBAT_VEHICLES);
	private _pos = [BASE_POS_GROUND_COMBAT_VEHICLE, _entity] call _findEmptyPosition;
	if (count _pos > 0) then {
		hint "Spawning ground combat vehicle at position";

		private _vehicle = _entity createVehicle _pos;
		private _group = createVehicleCrew _vehicle;
		{
			_x setBehaviour "AWARE";
			_x setSkill 0.7; // TODO: use config
			_x disableAI "PATH";
			//_x addEventHandler ["killed", "br_dead_objects pushBack (_this select 0);"];
		} forEach (crew _vehicle);
		_vehicle addEventHandler ["killed", { [[COMMAND_DELETE_KILLED_GROUND_COMBAT_VEHICLE, [_this select 0, serverTime, 10]], COMMAND_SPAWN_GROUND_COMBAT_VEHICLE] call EVANNEX_fnc_commandqueue_push; }];

		{
			_x addCuratorEditableObjects [[_vehicle], true];
		} forEach allCurators;
	}
	else {
		hint "No empty position for ground combat vehicle found";
		// try again
		[COMMAND_SPAWN_GROUND_COMBAT_VEHICLE] call EVANNEX_fnc_commandqueue_push;
	};
};

private _commandBuildBase = {
	call _scanMapForBaseMarkers;
	call _addCommandsForBaseMarkers;
};

private _commandResetGame = {
	call EVANNEX_fnc_compositions_enemy;
	call EVANNEX_fnc_spawnlists_enemy;
	call EVANNEX_fnc_spawnlists_friendly;

	call EVANNEX_fnc_base_init;

	[
		COMMAND_BUILD_BASE, 
		COMMAND_BUILD_ZONE
	] call EVANNEX_fnc_commandqueue_push;
};

private _commandDeleteKilledBaseDefence = {
	params ["_toDelete", "_killedWhen", "_waitFor"];
	if (serverTime > _killedWhen + _waitFor) then {
		deleteVehicle _toDelete;
	}
	else {
		[[COMMAND_DELETE_KILLED_BASE_DEFENCE, _this]] call EVANNEX_fnc_commandqueue_push;
	};
};

private _commandDeleteKilledAirTransport = {
	params ["_toDelete", "_killedWhen", "_waitFor"];
	if (serverTime > _killedWhen + _waitFor) then {
		deleteVehicle _toDelete;
	}
	else {
		[[COMMAND_DELETE_KILLED_AIR_TRANSPORT, _this]] call EVANNEX_fnc_commandqueue_push;
	};
};

private _commandDeleteKilledGroundTransport = {
	params ["_toDelete", "_killedWhen", "_waitFor"];
	if (serverTime > _killedWhen + _waitFor) then {
		deleteVehicle _toDelete;
	}
	else {
		[[COMMAND_DELETE_KILLED_GROUND_TRANSPORT, _this]] call EVANNEX_fnc_commandqueue_push;
	};
};

private _commandDeleteKilledGroundCombatVehicle = {
	params ["_toDelete", "_killedWhen", "_waitFor"];
	if (serverTime > _killedWhen + _waitFor) then {
		deleteVehicle _toDelete;
	}
	else {
		[[COMMAND_DELETE_KILLED_GROUND_COMBAT_VEHICLE, _this]] call EVANNEX_fnc_commandqueue_push;
	};
};

if (isServer) then {
	while { true } do {
		_command = (call EVANNEX_fnc_commandqueue_pop);
		if (typeName _command == "ARRAY") then {
			_commandParams = _command select 1;
			_command = _command select 0;
		};
		switch (_command) do {
			case COMMAND_EMPTY: { hint _command; };
			case COMMAND_RESET_GAME: {
				hint "Command: reset game";
				call _commandResetGame;
			};
			case COMMAND_BUILD_BASE: {
				hint "Command: build base";
				call _commandBuildBase;
			};
			case COMMAND_BUILD_ZONE: {
				hint "Command: building zone";
			};
			case COMMAND_SPAWN_BASE_DEFENCE: {
				hint "Command: spawn base defence";
				call _commandSpawnBaseDefence;
			};
			case COMMAND_SPAWN_AIR_TRANSPORT: {
				hint "Command: spawn air transport";
				call _commandSpawnAirTransport;
			};
			case COMMAND_SPAWN_GROUND_TRANSPORT: {
				hint "Command: spawn ground transport";
				call _commandSpawnGroundTransport;
			};
			case COMMAND_SPAWN_GROUND_COMBAT_VEHICLE: {
				hint "Command: spawn ground combat vehicle";
				call _commandSpawnGroundCombatVehicle;
			};
			case COMMAND_DELETE_KILLED_BASE_DEFENCE: {
				hint "Command: delete killed base defence after some time";
				_commandParams call _commandDeleteKilledBaseDefence;
			};
			case COMMAND_DELETE_KILLED_AIR_TRANSPORT: {
				hint "Command: delete killed air transport after some time";
				_commandParams call _commandDeleteKilledAirTransport;
			};
			case COMMAND_DELETE_KILLED_GROUND_TRANSPORT: {
				hint "Command: delete killed ground transport after some time";
				_commandParams call _commandDeleteKilledGroundTransport;

			};
			case COMMAND_DELETE_KILLED_GROUND_COMBAT_VEHICLE: {
				hint "Command: delete killed ground combat vehicle after some time";
				_commandParams call _commandDeleteKilledGroundCombatVehicle;
			};
			default { hint _command; };
		};
		sleep 1;
	};
};
