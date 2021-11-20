// add key constants to mission namespace
SPAWNLIST_FRIENDLY_BASE_DEFENCE = "base defence";
SPAWNLIST_FRIENDLY_OBJECTIVE_SQUAD_VEHICLES = "objective squad vehicles";
SPAWNLIST_FRIENDLY_AIR_TRANSPORT_VEHICLES = "air transport vehicles";
SPAWNLIST_FRIENDLY_GROUND_TRANSPORT_VEHICLES = "ground transport vehicles";
SPAWNLIST_FRIENDLY_JET_ATTACK_VEHICLES = "jet attack vehicles";
SPAWNLIST_FRIENDLY_AIR_ATTACK_VEHICLES = "air attack vehicles";
SPAWNLIST_FRIENDLY_GROUND_ATTACK_VEHICLES = "ground attack vehicles";
SPAWNLIST_FRIENDLY_INFANTRY_UNIT_COMPOSITIONS = "infantry unit compositions";

// declare private datastructures
private _map = createHashMap;
private _base_defence;
private _objective_squad_vehicles;
private _air_transport_vehicles;
private _ground_transport_vehicles;
private _jet_attack_vehicles;
private _air_attack_vehicles;
private _ground_attack_vehicles;
private _infantry_unit_compositions;

// build compositions
_base_defence = ["B_AAA_System_01_F", "B_SAM_System_01_F"];
_objective_squad_vehicles = ["B_Truck_01_transport_F", "B_Truck_01_covered_F"];
_air_transport_vehicles = ["B_Heli_Transport_03_F", "B_Heli_Transport_03_unarmed_F", "B_Heli_Transport_03_black_F", "B_Heli_Transport_03_unarmed_green_F", "B_CTRG_Heli_Transport_01_sand_F", "B_CTRG_Heli_Transport_01_tropic_F", "B_Heli_Light_01_F", "B_Heli_Transport_01_F", "B_Heli_Transport_01_camo_F"];
_ground_transport_vehicles = ["B_Truck_01_transport_F", "B_Truck_01_covered_F", "B_APC_Wheeled_01_cannon_F", "B_APC_Wheeled_03_cannon_F", "B_T_LSV_01_armed_F", "B_T_LSV_01_AT_F", "B_T_LSV_01_armed_CTRG_F", "B_T_LSV_01_unarmed_F"];
_jet_attack_vehicles = ["B_Plane_CAS_01_F", "B_UAV_02_F", "B_UAV_02_CAS_F", "B_Plane_Fighter_01_F", "B_UAV_05_F", "B_Plane_Fighter_01_Stealth_F", "B_Plane_CAS_01_Cluster_F"];
_air_attack_vehicles = ["B_Heli_Light_01_armed_F", "B_Heli_Attack_01_F"];
_ground_attack_vehicles = ["B_MRAP_01_gmg_F", "B_MRAP_01_hmg_F", "B_G_Offroad_01_armed_F", "B_MBT_01_cannon_F", "B_APC_Tracked_01_AA_F", "B_UGV_01_rcws_F", "B_APC_Tracked_01_CRV_F", "B_Truck_01_medical_F", "B_Truck_01_fuel_F", "B_Truck_01_ammo_F", "B_Truck_01_Repair_F", "B_APC_Wheeled_01_cannon_F", "B_MBT_01_TUSK_F", "B_APC_Wheeled_03_cannon_F", "B_T_LSV_01_armed_F", "B_T_LSV_01_armed_CTRG_F", "B_LSV_01_armed_F", "B_LSV_01_AT_F", "B_LSV_01_armed_black_F", "B_T_LSV_01_armed_black_F", "B_T_MRAP_01_gmg_F", "B_T_MRAP_01_hmg_F", "B_G_Quadbike_01_F", "B_AFV_Wheeled_01_cannon_F", "B_T_AFV_Wheeled_01_cannon_F", "B_AFV_Wheeled_01_up_cannon_F", "B_T_AFV_Wheeled_01_up_cannon_F", "B_APC_Tracked_01_AA_F", "B_APC_Tracked_01_rcws_F", "B_UGV_01_F"];
_infantry_unit_compositions = ["BUS_InfSentry", "BUS_InfSquad", "BUS_InfAssault", "BUS_InfSquad_Weapons", "BUS_InfTeam", "BUS_InfTeam_AA", "BUS_InfTeam_AT", "BUS_ReconPatrol", "BUS_ReconSentry", "BUS_ReconTeam", "BUS_ReconSquad", "BUS_SniperTeam" ];

// build map
_map set [SPAWNLIST_FRIENDLY_BASE_DEFENCE, _base_defence];
_map set [SPAWNLIST_FRIENDLY_OBJECTIVE_SQUAD_VEHICLES, _objective_squad_vehicles];
_map set [SPAWNLIST_FRIENDLY_AIR_TRANSPORT_VEHICLES, _air_transport_vehicles];
_map set [SPAWNLIST_FRIENDLY_GROUND_TRANSPORT_VEHICLES, _ground_transport_vehicles];
_map set [SPAWNLIST_FRIENDLY_JET_ATTACK_VEHICLES, _jet_attack_vehicles];
_map set [SPAWNLIST_FRIENDLY_AIR_ATTACK_VEHICLES, _air_attack_vehicles];
_map set [SPAWNLIST_FRIENDLY_GROUND_ATTACK_VEHICLES, _ground_attack_vehicles];
_map set [SPAWNLIST_FRIENDLY_INFANTRY_UNIT_COMPOSITIONS, _infantry_unit_compositions];

// return map
_map;