class NEW
{
	tag = "NEW";
	class assets
	{
		file = "NEW\assets";
		class compositions_enemy {};
		class spawnlists_friendly {};
		class spawnlists_enemy {};
		class base_friendly {};
	};
	class client
	{
		file = "NEW\client";
		// class showNumUnits {};
	};
	class server
	{
		file = "NEW\server";
		class commandloop {};
		class commandqueue_cleanup {};
		class commandqueue_clear {};
		class commandqueue_pop {};
		class commandqueue_push {};
		class read_params {};
	};
};