private _side = _this select 0;
private _skill = 0;

if (_side isEqualTo WEST) then { 
	_skill = br_ai_skill_friendly; 
} else 
{ 
	_skill = br_ai_skill_enemy; 
};
[_this select 5, _side, (configFile >> "CfgGroups" >> _this select 1 >> _this select 2 >> _this select 3 >> _this select 4), [], [], [_skill, _skill]] call BIS_fnc_spawnGroup;
