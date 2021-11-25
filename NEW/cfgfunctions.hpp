class NEW
{
	tag = "NEW";
	class assets
	{
		file = "NEW\assets";
		class compositions_enemy {};
		class spawnlists_friendly {};
		class spawnlists_enemy {};
	};
	class spawnlists
	{
		file = "NEW\spawnlists";
		// class showNumUnits {};
	};
	class client
	{
		file = "NEW\client";
		// class showNumUnits {};
	};
	class server
	{
		file = "NEW\server";
		class base_init {};
		class commandloop {};
		class commandqueue_cleanup {};
		class commandqueue_clear {};
		class commandqueue_pop {};
		class commandqueue_push {};
		class read_params {};
	};
};