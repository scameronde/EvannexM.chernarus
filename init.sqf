// Run evannex gamemode
execVM "core\evannexInit.sqf";
// Enable friendly markers
execVM "core\client\QS_icons.sqf";

setTimeMultiplier 1;

[] call SCAMERONDE_fnc_showNumUnits;
