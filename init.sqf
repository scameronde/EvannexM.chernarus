
setTimeMultiplier 1;

// Run evannex gamemode
if (isServer) then {
	[
		COMMAND_BUILD_BASE, 
		COMMAND_BUILD_ZONE
	] call EVANNEX_fnc_commandqueue_push;
};

// Enable friendly markers
[] call QS_fnc_icons;
// Enable unit count debugger
[] call SCAMERONDE_fnc_showNumUnits;
