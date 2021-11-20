private _command=COMMAND_EMPTY;

if ((count COMMANDQUEUE) == 0) then {
	_command = COMMAND_EMPTY;
}
else {
	_command = (COMMANDQUEUE deleteAt 0);
};
_command;