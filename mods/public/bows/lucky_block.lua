lucky_block:add_blocks({
	{"dro", {"bows:bow_wood"}},
	{"dro", {"bows:bow_steel"}},
	{"dro", {"bows:bow_bronze"}},
	{"dro", {"bows:arrow"}, 5},
	{"dro", {"bows:arrow_steel"}, 5},
	{"dro", {"bows:arrow_mese"}, 5},
	{"dro", {"bows:arrow_diamond"}, 5},
	{"nod", "default:chest", 0, {
		{name = "default:stick", max = 5},
		{name = "default:flint", max = 5},
		{name = "default:steel_ingot", max = 5},
		{name = "default:bronze_ingot", max = 5},
		{name = "default:mese_crystal_fragment", max = 5},
		{name = "farming:string", max = 5},
		{name = bows.feather, max = 5},
		{name = "bows:bow_bowie", max = 1, chance = 4}
	}},
})
