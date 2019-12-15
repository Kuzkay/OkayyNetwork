Shop = {}
Shop.Shops = {}
Shop.Selling = {}
Shop.Buying = {}

   
Shop.Shops = {

	{x=-169095,y=-39441,z=1149,h=57,npc_model=15,name="[Shop]",type="gas",robbery_id=1},
	{x=128736,y=77620,z=1576,h=88,npc_model=15,name="[Shop]",type="gas",robbery_id=2},
	{x=171062,y=203568,z=1413,h=162,npc_model=15,name="[Shop]",type="gas",robbery_id=3},
	{x=-15400,y=-2773,z=2065,h=90,npc_model=15,name="[Shop]",type="gas",robbery_id=4},
	{x=42678,y=137926,z=1581,h=33,npc_model=15,name="[Shop]",type="gas",robbery_id=5},
	{x=49288,y=133307,z=1578,h=-179,npc_model=7,name="[Bartender]",type="bar",robbery_id=6}

}



Shop.Selling["gas"] = {

	{item="bandage",label="Bandage",price=200},
	{item="repairkit",label="Repair kit",price=400},
	{item="firework",label="Firworks",price=100},
	{item="bigfirework",label="Fireworks Pack",price=550},
	{item="gas",label="Gasoline",price=110}

}
Shop.Buying["gas"] = {


}

Shop.Selling["bar"] = {
	{item="beer",label="Beer",price=40},
	{item="tequilla",label="Tequilla",price=100},
	{item="vodka",label="Vodka",price=130}
}

Shop.Buying["bar"] = {

}


Shop.Selling["dealer"] = {
	{item="cocaine",label="Cocaine",price=600},
	{item="weed",label="Weed",price=400},
	{item="ammo",label="Ammo box",price=500}
}
Shop.Buying["dealer"] = {
	{item="coca",label="Coca leaf",price=12},
	{item="cocaine",label="Cocaine",price=235},
	{item="heroin",label="Heroin",price=310}
}



