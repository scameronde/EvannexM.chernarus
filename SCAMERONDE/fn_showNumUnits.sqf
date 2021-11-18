SCAMERONDE_DEBUG_SHOW_NUM_UNITS = false;
while { true } do 
{ 
	if ( SCAMERONDE_DEBUG_SHOW_NUM_UNITS ) then 
	{
		// Get the number of OPFOR units 
		private _numOfUnits = count allUnits; 
		private _numOfEnemies = east countSide allUnits;
		private _numOfFriendlies = west countSide allUnits;
		hintSilent format ["A: %1, F: %2, E: %3", _numOfUnits, _numOfFriendlies, _numOfEnemies];
	};
	// "Sleep" for 3 seconds 
	uiSleep 3; 
};
