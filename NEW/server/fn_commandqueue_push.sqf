{
	_x params [	"_command", ["_params", []], ["_timeDelta", 0] ];

	COMMANDQUEUE pushBack [_command, _params, serverTime + _timeDelta];
} forEach _this;
