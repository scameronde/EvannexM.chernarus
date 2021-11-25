// the fifo queue
COMMANDQUEUE = [];

// possible entry types
COMMAND_EMPTY = "empty";
COMMAND_RESET_GAME = "reset game";
COMMAND_BUILD_BASE = "build base";
COMMAND_BUILD_ZONE = "build zone";
COMMAND_DELETE_ZONE = "delete zone";

COMMAND_SPAWN_BASE_DEFENCE = "spawn base defence";
COMMAND_SPAWN_AIR_TRANSPORT_HELI = "spawn heli transport";
COMMAND_SPAWN_AIR_COMBAT_HELI = "spawn heli combat";
COMMAND_SPAWN_AIR_COMBAT_JET = "spawn jet combat";
COMMAND_SPAWN_GROUND_TRANSPORT_VEHICLE = "spawn ground transport";
COMMAND_SPAWN_GROUND_COMBAT_VEHICLE = "spawn ground combat vehicle";
COMMAND_SPAWN_GROUND_COMBAT_INFANTRY = "spawn ground combat infantry";

COMMAND_DELETE_KILLED_BASE_DEFENCE = "delete killed base defence";
COMMAND_DELETE_KILLED_AIR_TRANSPORT_HELI = "delete killed heli transport";
COMMAND_DELETE_KILLED_AIR_COMBAT_HELI = "delete killed heli combat";
COMMAND_DELETE_KILLED_AIR_COMBAT_JET = "delete killed jet combat";
COMMAND_DELETE_KILLED_GROUND_TRANSPORT_VEHICLE = "delete killed ground transport";
COMMAND_DELETE_KILLED_GROUND_COMBAT_VEHICLE = "delete killed ground combat vehicle";
COMMAND_DELETE_KILLED_GROUND_COMBAT_INFANTRY = "delete killed ground combat infantry";


private _command=COMMAND_EMPTY;
private _commandParams=[];

private _scanMapForBaseMarkers = {
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
		};

	} forEach allMapMarkers;
};

private _addCommandsForBaseMarkers = {
	{
		[COMMAND_SPAWN_BASE_DEFENCE] call NEW_fnc_commandqueue_push;
	} forEach BASE_POS_DEFENCE;

	{
		[COMMAND_SPAWN_AIR_TRANSPORT_HELI] call NEW_fnc_commandqueue_push;
	} forEach BASE_POS_AIR_TRANSPORT_HELI;

	{
		[COMMAND_SPAWN_GROUND_TRANSPORT_VEHICLE] call NEW_fnc_commandqueue_push;
	} forEach BASE_POS_GROUND_TRANSPORT_VEHICLE;

	{
		[COMMAND_SPAWN_GROUND_COMBAT_VEHICLE] call NEW_fnc_commandqueue_push;
	} forEach BASE_POS_GROUND_COMBAT_VEHICLE;

	if (count BASE_POS_GROUND_COMBAT_INFANTRY > 0) then {
		for "_i" from 1 to PARAM_FRIENDLY_NR_GROUND_COMBAT_INFANTRY do {
			[COMMAND_SPAWN_GROUND_COMBAT_INFANTRY] call NEW_fnc_commandqueue_push;
		};
	};

	{
		[COMMAND_SPAWN_AIR_COMBAT_HELI] call NEW_fnc_commandqueue_push;
	} forEach BASE_POS_AIR_COMBAT_HELI;

	{
		[COMMAND_SPAWN_AIR_COMBAT_JET] call NEW_fnc_commandqueue_push;
	} forEach BASE_POS_AIR_COMBAT_JET;
};

private _findEmptyPosition = {
	params ["_positionsToCheck", "_unitType"];
	private _found=[];

	{
		_found = _x findEmptyPosition [0, 5, _unitType];
		if (count _found > 0) exitWith { _found };
	} forEach _positionsToCheck;

	_found;
};

private _findEmptyPositionForGroup = {
	params ["_positionsToCheck", "_unitType"];
	private _found=[];

	{
		_found = [_x, 0, 1, 1, 0] call BIS_fnc_findSafePos;
		if (count _found > 0) exitWith {
			_found;
		};
	} forEach _positionsToCheck;

	_found;
};

private _spawnVehiclesWithCrew = {
	params ["_spawnlistKey", "_positions", "_killCommand", "_spawnCommand"];
	private _vehicleClass = selectRandom (SPAWNLISTS_FRIENDLY get _spawnlistKey);
	private _pos = [_positions, _vehicleClass] call _findEmptyPosition;
	if (count _pos > 0) then {
		private _vehicle = _vehicleClass createVehicle _pos;
		private _group = createVehicleCrew _vehicle;
		{
			_x setBehaviour "AWARE";
			_x setSkill PARAMS_FRIENDLY_AI_SKILL;
			_x disableAI "PATH";
			//_x addEventHandler ["killed", "br_dead_objects pushBack (_this select 0);"];
		} forEach (crew _vehicle);
		private _code = format ['[["%1", _this select 0, 10], ["%2", [], 11]] call NEW_fnc_commandqueue_push;', _killCommand, _spawnCommand];
		_vehicle addEventHandler ["killed", _code];

		{
			_x addCuratorEditableObjects [[_vehicle], true];
		} forEach allCurators;
	}
	else {
		// try again
		[_spawnCommand] call NEW_fnc_commandqueue_push;
	};
};


private _commandSpawnBaseDefence = {
	[SPAWNLIST_FRIENDLY_BASE_DEFENCE, BASE_POS_DEFENCE, COMMAND_DELETE_KILLED_BASE_DEFENCE, COMMAND_SPAWN_BASE_DEFENCE] call _spawnVehiclesWithCrew;
	/*
	private _baseDefence = selectRandom (SPAWNLISTS_FRIENDLY get SPAWNLIST_FRIENDLY_BASE_DEFENCE);
	private _pos = [BASE_POS_DEFENCE, _baseDefence] call _findEmptyPosition;
	if (count _pos > 0) then {
		hint "Spawning base defence at position";

		private _vehicle = _baseDefence createVehicle _pos;
		private _group = createVehicleCrew _vehicle;
		{
			_x setBehaviour "AWARE";
			_x setSkill PARAMS_FRIENDLY_AI_SKILL;
			_x disableAI "PATH";
			//_x addEventHandler ["killed", "br_dead_objects pushBack (_this select 0);"];
		} forEach (crew _vehicle);
		_vehicle addEventHandler ["killed", {
			[[COMMAND_DELETE_KILLED_BASE_DEFENCE, _this select 0, 10], [COMMAND_SPAWN_BASE_DEFENCE, [], 11]] call NEW_fnc_commandqueue_push;
		}];

		{
			_x addCuratorEditableObjects [[_vehicle], true];
		} forEach allCurators;
	}
	else {
		hint "No empty position for base defence found";
		// try again
		[COMMAND_SPAWN_BASE_DEFENCE] call NEW_fnc_commandqueue_push;
	};
	*/
};

private _commandSpawnAirTransportHeli = {
	[SPAWNLIST_FRIENDLY_AIR_TRANSPORT_HELI, BASE_POS_AIR_TRANSPORT_HELI, COMMAND_DELETE_KILLED_AIR_TRANSPORT_HELI, COMMAND_SPAWN_AIR_TRANSPORT_HELI] call _spawnVehiclesWithCrew;
	/*
	private _heli = selectRandom (SPAWNLISTS_FRIENDLY get SPAWNLIST_FRIENDLY_AIR_TRANSPORT_HELI);
	private _pos = [BASE_POS_AIR_TRANSPORT_HELI, _heli] call _findEmptyPosition;
	if (count _pos > 0) then {
		hint "Spawning air transport at position";

		private _vehicle = _heli createVehicle _pos;
		private _group = createVehicleCrew _vehicle;
		{
			_x setBehaviour "AWARE";
			_x setSkill PARAMS_FRIENDLY_AI_SKILL;
			_x disableAI "PATH";
			//_x addEventHandler ["killed", "br_dead_objects pushBack (_this select 0);"];
		} forEach (crew _vehicle);
		_vehicle addEventHandler ["killed", {
			[[COMMAND_DELETE_KILLED_AIR_TRANSPORT_HELI, _this select 0, 10], [COMMAND_SPAWN_AIR_TRANSPORT_HELI, [], 11]] call NEW_fnc_commandqueue_push; 
		}];

		{
			_x addCuratorEditableObjects [[_vehicle], true];
		} forEach allCurators;
	}
	else {
		hint "No empty position for air transport found";
		// try again
		[COMMAND_SPAWN_AIR_TRANSPORT_HELI] call NEW_fnc_commandqueue_push;
	};
	*/
};

private _commandSpawnAirCombatHeli = {
};

private _commandSpawnAirCombatJet = {	
	private _entity = selectRandom (SPAWNLISTS_FRIENDLY get SPAWNLIST_FRIENDLY_AIR_COMBAT_JET);
	private _pos = [BASE_POS_AIR_COMBAT_JET, _entity] call _findEmptyPosition;
	if (count _pos > 0) then {
		hint "Spawning air combat jet at position";

		private _vehicle = _entity createVehicle _pos;
		private _group = createVehicleCrew _vehicle;
		{
			_x setBehaviour "AWARE";
			_x setSkill PARAMS_FRIENDLY_AI_SKILL;
			_x disableAI "PATH";
			//_x addEventHandler ["killed", "br_dead_objects pushBack (_this select 0);"];
		} forEach (crew _vehicle);
		_vehicle addEventHandler ["killed", { 
			[[COMMAND_DELETE_KILLED_AIR_COMBAT_JET, _this select 0, 10], [COMMAND_SPAWN_AIR_COMBAT_JET, [], 11]] call NEW_fnc_commandqueue_push; 
		}];

		{
			_x addCuratorEditableObjects [[_vehicle], true];
		} forEach allCurators;
	}
	else {
		hint "No empty position for air combat jet found";
		// try again
		[COMMAND_SPAWN_AIR_COMBAT_JET] call NEW_fnc_commandqueue_push;
	};
};

private _commandSpawnGroundTransportVehicle = {
	private _entity = selectRandom (SPAWNLISTS_FRIENDLY get SPAWNLIST_FRIENDLY_GROUND_TRANSPORT_VEHICLE);
	private _pos = [BASE_POS_GROUND_TRANSPORT_VEHICLE, _entity] call _findEmptyPosition;
	if (count _pos > 0) then {
		hint "Spawning ground transport at position";

		private _vehicle = _entity createVehicle _pos;
		private _group = createVehicleCrew _vehicle;
		{
			_x setBehaviour "AWARE";
			_x setSkill PARAMS_FRIENDLY_AI_SKILL;
			_x disableAI "PATH";
			//_x addEventHandler ["killed", "br_dead_objects pushBack (_this select 0);"];
		} forEach (crew _vehicle);
		_vehicle addEventHandler ["killed", { [[COMMAND_DELETE_KILLED_GROUND_TRANSPORT_VEHICLE, _this select 0, 10], COMMAND_SPAWN_GROUND_TRANSPORT_VEHICLE] call NEW_fnc_commandqueue_push; }];

		{
			_x addCuratorEditableObjects [[_vehicle], true];
		} forEach allCurators;
	}
	else {
		hint "No empty position for ground transport found";
		// try again
		[COMMAND_SPAWN_GROUND_TRANSPORT_VEHICLE] call NEW_fnc_commandqueue_push;
	};
};

private _commandSpawnGroundCombatVehicle = {
	private _entity = selectRandom (SPAWNLISTS_FRIENDLY get SPAWNLIST_FRIENDLY_GROUND_COMBAT_VEHICLE);
	private _pos = [BASE_POS_GROUND_COMBAT_VEHICLE, _entity] call _findEmptyPosition;
	if (count _pos > 0) then {
		hint "Spawning ground combat vehicle at position";

		private _vehicle = _entity createVehicle _pos;
		private _group = createVehicleCrew _vehicle;
		{
			_x setBehaviour "AWARE";
			_x setSkill PARAMS_FRIENDLY_AI_SKILL;
			_x disableAI "PATH";
			//_x addEventHandler ["killed", "br_dead_objects pushBack (_this select 0);"];
		} forEach (crew _vehicle);
		_vehicle addEventHandler ["killed", { [[COMMAND_DELETE_KILLED_GROUND_COMBAT_VEHICLE, _this select 0, 10], COMMAND_SPAWN_GROUND_COMBAT_VEHICLE] call NEW_fnc_commandqueue_push; }];

		{
			_x addCuratorEditableObjects [[_vehicle], true];
		} forEach allCurators;
	}
	else {
		hint "No empty position for ground combat vehicle found";
		// try again
		[COMMAND_SPAWN_GROUND_COMBAT_VEHICLE] call NEW_fnc_commandqueue_push;
	};
};

private _commandSpawnGroundCombatInfantry = {
	private _entity = selectRandom (SPAWNLISTS_FRIENDLY get SPAWNLIST_FRIENDLY_GROUND_COMBAT_INFANTRY);
	private _pos = [BASE_POS_GROUND_COMBAT_INFANTRY, _entity] call _findEmptyPositionForGroup;
	if (count _pos > 0) then {
		hint "Spawning ground combat infantry at position";

		// private _group = [pos, side, _entity] call BIS_fnc_spawnGroup;
		private _group = [_pos, WEST, _entity] call BIS_fnc_spawnGroup;
		{
			_x setBehaviour "AWARE";
			_x setSkill PARAMS_FRIENDLY_AI_SKILL;
			_x disableAI "PATH";
			//_x addEventHandler ["killed", "br_dead_objects pushBack (_this select 0);"];
		} forEach (units _group);
		//_group addEventHandler ["killed", { [[COMMAND_DELETE_KILLED_GROUND_COMBAT_INFANTRY, [_this select 0, serverTime, 10]], COMMAND_SPAWN_GROUND_COMBAT_INFANTRY] call NEW_fnc_commandqueue_push; }];

		{
		//	_x addCuratorEditableObjects [[_group], true];
		} forEach allCurators;
	}
	else {
		hint "No empty position for ground combat infantry found";
		// try again
		[COMMAND_SPAWN_GROUND_COMBAT_INFANTRY] call NEW_fnc_commandqueue_push;
	};
};

private _commandBuildBase = {
	call _scanMapForBaseMarkers;
	call _addCommandsForBaseMarkers;
};

private _commandResetGame = {
	call NEW_fnc_read_params;
	call NEW_fnc_compositions_enemy;
	call NEW_fnc_spawnlists_enemy;
	call NEW_fnc_spawnlists_friendly;
	call NEW_fnc_base_init;

	[
		COMMAND_BUILD_BASE, 
		COMMAND_BUILD_ZONE
	] call NEW_fnc_commandqueue_push;
};

private _commandDeleteKilledBaseDefence = {
	params ["_toDelete"];
	deleteVehicle _toDelete;
};

private _commandDeleteKilledAirTransportHeli = {
	params ["_toDelete"];
	{
		_toDelete deleteVehicleCrew _x;
	} forEach (crew _toDelete);
	deleteVehicle _toDelete;
};

private _commandDeleteKilledAirCombatHeli = {
	params ["_toDelete"];
	deleteVehicle _toDelete;
};

private _commandDeleteKilledAirCombatJet = {
	params ["_toDelete"];
	deleteVehicle _toDelete;
};

private _commandDeleteKilledGroundTransportVehicle = {
	params ["_toDelete"];
	deleteVehicle _toDelete;
};

private _commandDeleteKilledGroundCombatVehicle = {
	params ["_toDelete"];
	deleteVehicle _toDelete;
};

private _commandDeleteKilledGroundCombatInfantry = {
	params ["_toDelete"];
	deleteVehicle _toDelete;
};


if (isServer) then {
	while { true } do {
		(call NEW_fnc_commandqueue_pop) params ["_command", "_params", "_time"];
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
			case COMMAND_SPAWN_AIR_TRANSPORT_HELI: {
				hint "Command: spawn air transport";
				call _commandSpawnAirTransportHeli;
			};
			case COMMAND_SPAWN_AIR_COMBAT_HELI: {
				hint "Command: spawn air combat heli";
				call _commandSpawnAirCombatHeli;
			};
			case COMMAND_SPAWN_AIR_COMBAT_JET: {
				hint "Command: spawn air combat jet";
				call _commandSpawnAirCombatJet;
			};
			case COMMAND_SPAWN_GROUND_TRANSPORT_VEHICLE: {
				hint "Command: spawn ground transport";
				call _commandSpawnGroundTransportVehicle;
			};
			case COMMAND_SPAWN_GROUND_COMBAT_VEHICLE: {
				hint "Command: spawn ground combat vehicle";
				call _commandSpawnGroundCombatVehicle;
			};
			case COMMAND_SPAWN_GROUND_COMBAT_INFANTRY: {
				hint "Command: spawn ground combat infantry";
				call _commandSpawnGroundCombatInfantry;
			};
			case COMMAND_DELETE_KILLED_BASE_DEFENCE: {
				hint "Command: delete killed base defence after some time";
				_params call _commandDeleteKilledBaseDefence;
			};
			case COMMAND_DELETE_KILLED_AIR_TRANSPORT_HELI: {
				hint "Command: delete killed air transport after some time";
				_params call _commandDeleteKilledAirTransportHeli;
			};
			case COMMAND_DELETE_KILLED_AIR_COMBAT_HELI: {
				hint "Command: delete killed air combat heli after some time";
				_params call _commandDeleteKilledAirCombatHeli;
			};
			case COMMAND_DELETE_KILLED_AIR_COMBAT_JET: {
				hint "Command: delete killed air combat jet after some time";
				_params call _commandDeleteKilledAirCombatJet;
			};
			case COMMAND_DELETE_KILLED_GROUND_TRANSPORT_VEHICLE: {
				hint "Command: delete killed ground transport after some time";
				_params call _commandDeleteKilledGroundTransportVehicle;

			};
			case COMMAND_DELETE_KILLED_GROUND_COMBAT_VEHICLE: {
				hint "Command: delete killed ground combat vehicle after some time";
				_params call _commandDeleteKilledGroundCombatVehicle;
			};
			case COMMAND_DELETE_KILLED_GROUND_COMBAT_INFANTRY: {
				hint "Command: delete killed ground combat infantry after some time";
				_params call _commandDeleteKilledGroundCombatInfantry;
			};
			default { hint _command; };
		};
		sleep 0.1;
	};
};


/*
_gamelogic = CENTER;
_towns = nearestLocations [getPosATL _gamelogic, ["NameVillage","NameCity","NameCityCapital"], 25000]; 
_RandomTownPosition = position (_towns select (floor (random (count _towns))));

_m = createMarker [format ["mrk%1",random 100000],_RandomTownPosition];
_m setMarkerShape "ELLIPSE";
_m setMarkerSize [900,900];
_m setMarkerBrush "BDiagonal";
_m setMarkerAlpha 0.5;
_m setMarkerColor "ColorEAST";

_pos = getMarkerPos _m;

_randPos = [_pos , 0, 600, 12, 0, 0.3, 0] call BIS_fnc_findSafePos;
*/
