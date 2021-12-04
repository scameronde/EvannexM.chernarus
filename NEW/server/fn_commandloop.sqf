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

COMMAND_CHECK_FOR_DEAD_INFANTRY_GROUPS = "check for dead infantry groups";

private _command=COMMAND_EMPTY;
private _commandParams=[];

private _spawnedFriendlyInfantry=[];

private _addCommandsForBaseMarkers = {
	{
		[COMMAND_SPAWN_BASE_DEFENCE] call NEW_fnc_commandqueue_push;
	} forEach BASE_POS_DEFENCE;

	for "_i" from 1 to PARAM_FRIENDLY_NR_AIR_TRANSPORT_HELI do {
		[COMMAND_SPAWN_AIR_TRANSPORT_HELI] call NEW_fnc_commandqueue_push;
	};

	for "_i" from 1 to PARAM_FRIENDLY_NR_AIR_COMBAT_HELI do {
		[COMMAND_SPAWN_AIR_COMBAT_HELI] call NEW_fnc_commandqueue_push;
	};

	for "_i" from 1 to PARAM_FRIENDLY_NR_AIR_COMBAT_JET do {
		[COMMAND_SPAWN_AIR_COMBAT_JET] call NEW_fnc_commandqueue_push;
	};

	for "_i" from 1 to PARAM_FRIENDLY_NR_GROUND_TRANSPORT_VEHICLE do {
		[COMMAND_SPAWN_GROUND_TRANSPORT_VEHICLE] call NEW_fnc_commandqueue_push;
	};

	for "_i" from 1 to PARAM_FRIENDLY_NR_GROUND_COMBAT_VEHICLE do {
		[COMMAND_SPAWN_GROUND_COMBAT_VEHICLE] call NEW_fnc_commandqueue_push;
	};

	for "_i" from 1 to PARAM_FRIENDLY_NR_GROUND_COMBAT_INFANTRY do {
		[COMMAND_SPAWN_GROUND_COMBAT_INFANTRY] call NEW_fnc_commandqueue_push;
	};
};

private _findEmptyPosition = {
	params ["_positionsToCheck", "_unitType"];
	private _found=[];

	if (count _positionsToCheck == 0) then {
		_found = ([BASE] call CBA_fnc_randPosArea) findEmptyPosition [0, 5, _unitType];
	} else {
		{
			_found = _x findEmptyPosition [0, 5, _unitType];
			if (count _found > 0) exitWith { _found };
		} forEach _positionsToCheck;
	};

	_found;
};

private _findEmptyPositionForGroup = {
	params ["_positionsToCheck"];
	private _found=[];

	if (count _positionsToCheck == 0) then {
		_found = ([BASE] call CBA_fnc_randPosArea) findEmptyPosition [0, 5];
	} else {
		{
			_found = _x findEmptyPosition [0, 5];
			if (count _found > 0) exitWith { _found };
		} forEach _positionsToCheck;
	};

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
			_x setSkill PARAM_FRIENDLY_AI_SKILL;
			_x disableAI "PATH";
			_x enableSimulationGlobal false;
			//_x addEventHandler ["killed", "br_dead_objects pushBack (_this select 0);"];
		} forEach (crew _vehicle);
		_vehicle setBehaviour "AWARE";
		_vehicle setSkill PARAM_FRIENDLY_AI_SKILL;
		_vehicle disableAI "PATH";
		_vehicle enableSimulationGlobal false;
		private _killHandler = format ['[["%1", _this select 0, 10], ["%2", [], 11]] call NEW_fnc_commandqueue_push;', _killCommand, _spawnCommand];
		_vehicle addEventHandler ["killed", _killHandler];

		{
			_x addCuratorEditableObjects [[_vehicle], true];
		} forEach allCurators;
	}
	else {
		// try again
		[[_spawnCommand, [], 1]] call NEW_fnc_commandqueue_push;
	};
};

private _spawnGroup = {
	params ["_spawnlistKey", "_positions", "_killCommand", "_spawnCommand"];
	private _composition = selectRandom (SPAWNLISTS_FRIENDLY get _spawnlistKey);
	private _pos = [_positions, _composition] call _findEmptyPositionForGroup;
	if (count _pos > 0) then {
		private _group = [_pos, WEST, _composition] call BIS_fnc_spawnGroup;
		{
			_x setBehaviour "AWARE";
			_x setSkill PARAM_FRIENDLY_AI_SKILL;
			_x disableAI "PATH";
			_x enableSimulationGlobal false;
			//_x addEventHandler ["killed", "br_dead_objects pushBack (_this select 0);"];
		} forEach (units _group);
		_group setBehaviour "AWARE";
		_spawnedFriendlyInfantry pushBack _group;

		{
			_x addCuratorEditableObjects [units _group, true];
		} forEach allCurators;
	}
	else {
		hint "No empty position for ground combat infantry found";
		// try again
		[[_spawnCommand, [], 1]] call NEW_fnc_commandqueue_push;
	};
};

private _checkForDeadInfantryGroups = {
	private _units = [];
	private _alive = false;
	private _deadGroups = [];

	{
		_units = units _x;
		_alive = false;
		{
			if (alive _x) exitWith { _alive = true };
		} forEach _units;
		if (_alive == false) then { _deadGroups pushBack _x };
	} forEach _spawnedFriendlyInfantry;

	_spawnedFriendlyInfantry = _spawnedFriendlyInfantry - _deadGroups;

	{
		private _group = _x;
		{
			_x removeCuratorEditableObjects [units _group, true];
		} forEach allCurators;
		[COMMAND_SPAWN_GROUND_COMBAT_INFANTRY] call NEW_fnc_commandqueue_push;
	} forEach _deadGroups;

	[[COMMAND_CHECK_FOR_DEAD_INFANTRY_GROUPS, [], 2]] call NEW_fnc_commandqueue_push;
};

private _commandSpawnBaseDefence = {
	[SPAWNLIST_FRIENDLY_BASE_DEFENCE, BASE_POS_DEFENCE, COMMAND_DELETE_KILLED_BASE_DEFENCE, COMMAND_SPAWN_BASE_DEFENCE] call _spawnVehiclesWithCrew;
};

private _commandSpawnAirTransportHeli = {
	[SPAWNLIST_FRIENDLY_AIR_TRANSPORT_HELI, BASE_POS_AIR_TRANSPORT_HELI, COMMAND_DELETE_KILLED_AIR_TRANSPORT_HELI, COMMAND_SPAWN_AIR_TRANSPORT_HELI] call _spawnVehiclesWithCrew;
};

private _commandSpawnAirCombatHeli = {
	[SPAWNLIST_FRIENDLY_AIR_COMBAT_HELI, BASE_POS_AIR_COMBAT_HELI, COMMAND_DELETE_KILLED_AIR_COMBAT_HELI, COMMAND_SPAWN_AIR_COMBAT_HELI] call _spawnVehiclesWithCrew;
};

private _commandSpawnAirCombatJet = {	
	[SPAWNLIST_FRIENDLY_AIR_COMBAT_JET, BASE_POS_AIR_COMBAT_JET, COMMAND_DELETE_KILLED_AIR_COMBAT_JET, COMMAND_SPAWN_AIR_COMBAT_JET] call _spawnVehiclesWithCrew;
};

private _commandSpawnGroundTransportVehicle = {
	[SPAWNLIST_FRIENDLY_GROUND_TRANSPORT_VEHICLE, BASE_POS_GROUND_TRANSPORT_VEHICLE, COMMAND_DELETE_KILLED_GROUND_TRANSPORT_VEHICLE, COMMAND_SPAWN_GROUND_TRANSPORT_VEHICLE] call _spawnVehiclesWithCrew;
};

private _commandSpawnGroundCombatVehicle = {
	[SPAWNLIST_FRIENDLY_GROUND_COMBAT_VEHICLE, BASE_POS_GROUND_COMBAT_VEHICLE, COMMAND_DELETE_KILLED_GROUND_COMBAT_VEHICLE, COMMAND_SPAWN_GROUND_COMBAT_VEHICLE] call _spawnVehiclesWithCrew;
};

private _commandSpawnGroundCombatInfantry = {
	[SPAWNLIST_FRIENDLY_GROUND_COMBAT_INFANTRY, BASE_POS_GROUND_COMBAT_INFANTRY, COMMAND_DELETE_KILLED_GROUND_COMBAT_INFANTRY, COMMAND_SPAWN_GROUND_COMBAT_INFANTRY] call _spawnGroup;
};

private _commandBuildBase = {
	call _addCommandsForBaseMarkers;
};

private _commandResetGame = {
	call NEW_fnc_read_params;
	call NEW_fnc_compositions_enemy;
	call NEW_fnc_spawnlists_enemy;
	call NEW_fnc_spawnlists_friendly;
	call NEW_fnc_base_friendly;

	[
		COMMAND_BUILD_BASE, 
		COMMAND_BUILD_ZONE,
		[COMMAND_CHECK_FOR_DEAD_INFANTRY_GROUPS, [], 2]
	] call NEW_fnc_commandqueue_push;
};

private _deleteKilledVehicle = {
	params ["_toDelete"];
	{
		_toDelete deleteVehicleCrew _x;
	} forEach (crew _toDelete);
	deleteVehicle _toDelete;
};

private _commandDeleteKilledGroundCombatInfantry = {
	params ["_toDelete"];
	(units (group _toDelete)) apply { deleteVehicle _x };
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
				_params call _deleteKilledVehicle;
			};
			case COMMAND_DELETE_KILLED_AIR_TRANSPORT_HELI: {
				hint "Command: delete killed air transport after some time";
				_params call _deleteKilledVehicle;
			};
			case COMMAND_DELETE_KILLED_AIR_COMBAT_HELI: {
				hint "Command: delete killed air combat heli after some time";
				_params call _deleteKilledVehicle;
			};
			case COMMAND_DELETE_KILLED_AIR_COMBAT_JET: {
				hint "Command: delete killed air combat jet after some time";
				_params call _deleteKilledVehicle;
			};
			case COMMAND_DELETE_KILLED_GROUND_TRANSPORT_VEHICLE: {
				hint "Command: delete killed ground transport after some time";
				_params call _deleteKilledVehicle;

			};
			case COMMAND_DELETE_KILLED_GROUND_COMBAT_VEHICLE: {
				hint "Command: delete killed ground combat vehicle after some time";
				_params call _deleteKilledVehicle;
			};
			case COMMAND_DELETE_KILLED_GROUND_COMBAT_INFANTRY: {
				hint "Command: delete killed ground combat infantry after some time";
				_params call _commandDeleteKilledGroundCombatInfantry;
			};
			case COMMAND_CHECK_FOR_DEAD_INFANTRY_GROUPS: {
				_params call _checkForDeadInfantryGroups;
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
