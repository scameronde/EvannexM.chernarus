// add key constants to mission namespace
SPAWNLIST_ENEMY_SIDE = "side units";
SPAWNLIST_ENEMY_SPECIAL = "special units";

// define private datastructures
private _map = createHashMap;

// build compositions
private _side = createHashMap;
_side set ["HQ", ["B_officer_F", "B_Soldier_F", "B_medic_F", "B_Soldier_F", "B_Soldier_F"]];
_side set ["Construction Site", ["B_Soldier_F", "B_Soldier_F", "B_Soldier_F", "B_Soldier_F", "B_Soldier_F", "B_Soldier_F", "B_Soldier_F", "B_Soldier_F", "B_Soldier_F", "B_Soldier_F", "B_Soldier_F", "B_Soldier_F", "B_Soldier_F", "B_Soldier_F", "B_Soldier_F", "B_Soldier_F", "B_Soldier_F"]];
_side set ["AA", ["B_T_APC_Tracked_01_AA_F", "B_T_APC_Tracked_01_AA_F", "B_T_MRAP_01_gmg_F"]];
_side set ["Artillery", ["B_T_MBT_01_arty_F", "B_T_MRAP_01_hmg_F"]];
_side set ["Enemy Survivors", ["B_Survivor_F", "B_Survivor_F", "B_Survivor_F", "B_Survivor_F", "B_Survivor_F", "B_Survivor_F"]];
_side set ["Enemy Mortars",["B_Mortar_01_F", "B_Mortar_01_F", "B_Mortar_01_F", "B_Mortar_01_F", "B_MRAP_01_gmg_F"]];
_side set ["EMP", ["O_Truck_03_device_F"]];
_side set ["Helicopter", ["B_Heli_Attack_01_F"]];
_side set ["AA_Zone", ["B_T_APC_Tracked_01_AA_F"]];
_side set ["Enemy_Camp", ["B_Soldier_F", "B_Soldier_F", "B_soldier_AA_F", "B_soldier_AT_F", "B_Soldier_F"]];
_side set ["Enemy_Mortars", ["B_Mortar_01_F", "B_Mortar_01_F", "B_Mortar_01_F", "B_Mortar_01_F"]];

private _special = ["B_MRAP_01_gmg_F", "B_MRAP_01_hmg_F", "B_G_Offroad_01_armed_F", "B_MBT_01_cannon_F", "B_APC_Tracked_01_AA_F", "B_UGV_01_rcws_F", "B_APC_Tracked_01_CRV_F", "B_Truck_01_medical_F", "B_Truck_01_fuel_F", "B_Truck_01_ammo_F", "B_Truck_01_Repair_F", "B_APC_Wheeled_01_cannon_F", "B_MBT_01_TUSK_F", "B_APC_Wheeled_03_cannon_F", "B_T_LSV_01_armed_F", "B_T_LSV_01_armed_CTRG_F", "B_LSV_01_armed_F", "B_LSV_01_AT_F", "B_LSV_01_armed_black_F", "B_T_LSV_01_armed_black_F", "B_T_MRAP_01_gmg_F", "B_T_MRAP_01_hmg_F", "B_T_UAV_03_F", "B_G_Quadbike_01_F", "B_Heli_Light_01_armed_F", "I_LT_01_cannon_F", "I_LT_01_AA_F", "I_LT_01_scout_F", "I_LT_01_AT_F", "C_Kart_01_Red_F", "B_AFV_Wheeled_01_cannon_F", "B_T_AFV_Wheeled_01_cannon_F", "B_AFV_Wheeled_01_up_cannon_F", "B_T_AFV_Wheeled_01_up_cannon_F", "B_APC_Tracked_01_AA_F", "B_APC_Tracked_01_rcws_F", "B_Heli_Attack_01_F", "B_UGV_01_F", "B_static_AA_F", "B_static_AT_F", "B_Static_Designator_01_F", "B_T_Static_AA_F", "B_T_Static_AT_F", "B_T_GMG_01_F", "B_T_HMG_01_F", "B_T_Mortar_01_F", "B_Boat_Armed_01_minigun_F", "B_Boat_Armed_01_minigun_F", "B_Boat_Armed_01_minigun_F"];

// build map
_map set [SPAWNLIST_ENEMY_SIDE, _side];
_map set [SPAWNLIST_ENEMY_SPECIAL, _special];

// return map
SPAWNLISTS_ENEMY = _map;
