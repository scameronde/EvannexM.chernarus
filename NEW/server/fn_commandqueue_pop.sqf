private _command=[COMMAND_EMPTY, [], serverTime];

private _foundIndex = COMMANDQUEUE findIf { serverTime >= (_x select 2)};
if (_foundIndex >= 0) then {
	_command = COMMANDQUEUE deleteAt _foundIndex;
};
_command;
