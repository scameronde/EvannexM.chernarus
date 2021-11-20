class EVANNEX
{
	tag = "EVANNEX";
	class assets
	{
		file = "EVANNEX\assets";
		class compositions_enemy {};
		class spawnlists_friendly {};
		class spawnlists_enemy {};
	};
	class spawnlists
	{
		file = "EVANNEX\spawnlists";
		// class showNumUnits {};
	};
	class client
	{
		file = "EVANNEX\client";
		// class showNumUnits {};
	};
	class server
	{
		file = "EVANNEX\server";
		class base_init {};
		class commandloop {};
		class commandqueue_cleanup {};
		class commandqueue_clear {};
		class commandqueue_pop {};
		class commandqueue_push {};
	};
};