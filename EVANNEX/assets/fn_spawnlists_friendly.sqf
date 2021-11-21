// add key constants to mission namespace
SPAWNLIST_FRIENDLY_BASE_DEFENCE = "base defence";
SPAWNLIST_FRIENDLY_OBJECTIVE_SQUAD_VEHICLES = "objective squad vehicles";
SPAWNLIST_FRIENDLY_AIR_TRANSPORT_VEHICLES = "air transport vehicles";
SPAWNLIST_FRIENDLY_GROUND_TRANSPORT_VEHICLES = "ground transport vehicles";
SPAWNLIST_FRIENDLY_JET_COMBAT_VEHICLES = "jet combat vehicles";
SPAWNLIST_FRIENDLY_AIR_COMBAT_VEHICLES = "air combat vehicles";
SPAWNLIST_FRIENDLY_GROUND_COMBAT_VEHICLES = "ground combat vehicles";
SPAWNLIST_FRIENDLY_INFANTRY_UNIT_COMPOSITIONS = "infantry unit compositions";

// define private datastructure
private _map = createHashMap;

// build compositions
private _base_defence = ["B_AAA_System_01_F", "B_SAM_System_01_F"];
private _objective_squad_vehicles = ["B_Truck_01_transport_F", "B_Truck_01_covered_F"];
private _air_transport_vehicles = ["B_Heli_Transport_03_F", "B_Heli_Transport_03_unarmed_F", "B_Heli_Transport_03_black_F", "B_Heli_Transport_03_unarmed_green_F", "B_CTRG_Heli_Transport_01_sand_F", "B_CTRG_Heli_Transport_01_tropic_F", "B_Heli_Light_01_F", "B_Heli_Transport_01_F", "B_Heli_Transport_01_camo_F"];
private _ground_transport_vehicles = ["B_Truck_01_transport_F", "B_Truck_01_covered_F", "B_APC_Wheeled_01_cannon_F", "B_APC_Wheeled_03_cannon_F", "B_T_LSV_01_armed_F", "B_T_LSV_01_AT_F", "B_T_LSV_01_armed_CTRG_F", "B_T_LSV_01_unarmed_F"];
private _jet_combat_vehicles = ["B_Plane_CAS_01_F", "B_UAV_02_F", "B_UAV_02_CAS_F", "B_Plane_Fighter_01_F", "B_UAV_05_F", "B_Plane_Fighter_01_Stealth_F", "B_Plane_CAS_01_Cluster_F"];
private _air_combat_vehicles = ["B_Heli_Light_01_armed_F", "B_Heli_Attack_01_F"];
private _ground_combat_vehicles = ["B_MRAP_01_gmg_F", "B_MRAP_01_hmg_F", "B_G_Offroad_01_armed_F", "B_MBT_01_cannon_F", "B_APC_Tracked_01_AA_F", "B_UGV_01_rcws_F", "B_APC_Tracked_01_CRV_F", "B_Truck_01_medical_F", "B_Truck_01_fuel_F", "B_Truck_01_ammo_F", "B_Truck_01_Repair_F", "B_APC_Wheeled_01_cannon_F", "B_MBT_01_TUSK_F", "B_APC_Wheeled_03_cannon_F", "B_T_LSV_01_armed_F", "B_T_LSV_01_armed_CTRG_F", "B_LSV_01_armed_F", "B_LSV_01_AT_F", "B_LSV_01_armed_black_F", "B_T_LSV_01_armed_black_F", "B_T_MRAP_01_gmg_F", "B_T_MRAP_01_hmg_F", "B_G_Quadbike_01_F", "B_AFV_Wheeled_01_cannon_F", "B_T_AFV_Wheeled_01_cannon_F", "B_AFV_Wheeled_01_up_cannon_F", "B_T_AFV_Wheeled_01_up_cannon_F", "B_APC_Tracked_01_AA_F", "B_APC_Tracked_01_rcws_F", "B_UGV_01_F"];
private _infantry_unit_compositions = ["BUS_InfSentry", "BUS_InfSquad", "BUS_InfAssault", "BUS_InfSquad_Weapons", "BUS_InfTeam", "BUS_InfTeam_AA", "BUS_InfTeam_AT", "BUS_ReconPatrol", "BUS_ReconSentry", "BUS_ReconTeam", "BUS_ReconSquad", "BUS_SniperTeam" ];

// build map
_map set [SPAWNLIST_FRIENDLY_BASE_DEFENCE, _base_defence];
_map set [SPAWNLIST_FRIENDLY_OBJECTIVE_SQUAD_VEHICLES, _objective_squad_vehicles];
_map set [SPAWNLIST_FRIENDLY_AIR_TRANSPORT_VEHICLES, _air_transport_vehicles];
_map set [SPAWNLIST_FRIENDLY_GROUND_TRANSPORT_VEHICLES, _ground_transport_vehicles];
_map set [SPAWNLIST_FRIENDLY_JET_COMBAT_VEHICLES, _jet_combat_vehicles];
_map set [SPAWNLIST_FRIENDLY_AIR_COMBAT_VEHICLES, _air_combat_vehicles];
_map set [SPAWNLIST_FRIENDLY_GROUND_COMBAT_VEHICLES, _ground_combat_vehicles];
_map set [SPAWNLIST_FRIENDLY_INFANTRY_UNIT_COMPOSITIONS, _infantry_unit_compositions];

// return map
SPAWNLISTS_FRIENDLY = _map;