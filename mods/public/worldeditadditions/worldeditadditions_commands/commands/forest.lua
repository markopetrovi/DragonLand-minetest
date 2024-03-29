local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

-- ███████  ██████  ██████  ███████ ███████ ████████
-- ██      ██    ██ ██   ██ ██      ██         ██
-- █████   ██    ██ ██████  █████   ███████    ██
-- ██      ██    ██ ██   ██ ██           ██    ██
-- ██       ██████  ██   ██ ███████ ███████    ██

worldeditadditions_core.register_command("forest", {
	params = "[<density>] <sapling_a> [<chance_a>] <sapling_b> [<chance_b>] [<sapling_N> [<chance_N>]] ...",
	description = "Plants and grows trees in the defined region according to the given list of sapling names and chances and density factor. The density controls the relative density of the resulting forest, and defaults to 1 (floating-point numbers allowed). Higher chance numbers result in a lower relative chance with respect to other saplings in the list. Saplings that fail to grow are subsequently removed (this will affect pre-existing saplings too).",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		local density = 1
		local match_start = params_text:match("^[%d.]+%s+")
		if match_start then
			density = tonumber(match_start)
			params_text = params_text:sub(#match_start + 1) -- everything starts at 1 in Lua :-/
		end
		
		local success, sapling_list = wea_c.parse.weighted_nodes(
			wea_c.split_shell(params_text),
			false,
			function(name)
				return worldedit.normalize_nodename(
					wea_c.normalise_saplingname(name)
				)
			end
		)
		if not success then return success, sapling_list end
		return success, density, sapling_list
	end,
	nodes_needed = function(name)
		-- //overlay only modifies up to 1 node per column in the selected region
		local pos1, pos2 = Vector3.sort(worldedit.pos1[name], worldedit.pos2[name])
		return (pos2.x - pos1.x) * (pos2.y - pos1.y)
	end,
	func = function(name, density, sapling_list)
		local start_time = wea_c.get_ms_time()
		local pos1, pos2 = Vector3.sort(worldedit.pos1[name], worldedit.pos2[name])
		local success, stats = worldeditadditions.forest(
			pos1, pos2,
			density,
			sapling_list
		)
		if not success then return success, stats end
		local time_taken = wea_c.format.human_time(wea_c.get_ms_time() - start_time)
		
		local distribution_display = wea_c.format.node_distribution(
			stats.placed,
			stats.successes,
			false -- no grand total at the bottom
		)
		
		minetest.log("action", name.." used //forest at "..pos1.." - "..pos2..", "..stats.successes.." trees placed, averaging "..stats.attempts_avg.." growth attempts / tree and "..stats.failures.." failed attempts in "..time_taken)
		return true, distribution_display.."\n=========================\n"..stats.successes.." trees placed, averaging "..stats.attempts_avg.." growth attempts / tree and "..stats.failures.." failed attempts in "..time_taken
	end
})
