PARAM_FRIENDLY_AI_SKILL = [0.1, 0.5, 0.7, 1] select ("AISkillFriendly" call BIS_fnc_getParamValue);
PARAM_ENEMY_AI_SKILL = [0.1, 0.5, 0.7, 1] select ("AISkillEnemy" call BIS_fnc_getParamValue);

PARAM_ENEMY_ZONE_RADIUS = "EnemyZoneRadius" call BIS_fnc_getParamValue;

PARAM_FRIENDLY_NR_AIR_TRANSPORT_HELI = "FriendlyNrAirTransportHeli" call BIS_fnc_getParamValue;
PARAM_FRIENDLY_NR_AIR_COMBAT_HELI = "FriendlyNrAirCombatHeli" call BIS_fnc_getParamValue;
PARAM_FRIENDLY_NR_AIR_COMBAT_JET = "FriendlyNrAirCombatJet" call BIS_fnc_getParamValue;
PARAM_FRIENDLY_NR_GROUND_TRANSPORT_VEHICLE = "FriendlyNrGroundTransportVehicle" call BIS_fnc_getParamValue;
PARAM_FRIENDLY_NR_GROUND_COMBAT_VEHICLE = "FriendlyNrGroundCombatVehicle" call BIS_fnc_getParamValue;
PARAM_FRIENDLY_NR_GROUND_COMBAT_INFANTRY = "FriendlyNrGroundCombatInfantry" call BIS_fnc_getParamValue;
