// Run evannex gamemode
execVM "core\evannexInit.sqf";
// Enable friendly markers
execVM "core\client\QS_icons.sqf";
0 setOvercast (random 1);
forceWeatherChange;
0 setFog [(random 0.1), (random 0.015), (random 200)];
setTimeMultiplier 1;
