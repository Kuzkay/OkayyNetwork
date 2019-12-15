local sb_timer = 0


function OnKeyPress(key)
	if key == "Tab" then
		if IsValidTimer(sb_timer) then
			DestroyTimer(sb_timer)
		end
		sb_timer = CreateTimer(UpdateScoreboardData, 1500)
		UpdateScoreboardData()
		ExecuteWebJS(Gui_main, "ToggleScoreboard(true);")
	end
end
AddEvent("OnKeyPress", OnKeyPress)

function OnKeyRelease(key)
	if key == "Tab" then
		DestroyTimer(sb_timer)
		ExecuteWebJS(Gui_main, "ToggleScoreboard(false);")
	end
end
AddEvent("OnKeyRelease", OnKeyRelease)

function UpdateScoreboardData()
	CallRemoteEvent("UpdateScoreboardData")
end

function OnGetScoreboardData(servername, count, maxplayers, players)
	--print(servername, count, maxplayers)

	ExecuteWebJS(Gui_main, "SetServerName('"..servername.."')")
	ExecuteWebJS(Gui_main, "SetPlayerCount("..count..", "..maxplayers..")")
	ExecuteWebJS(Gui_main, "RemovePlayers()")
	--print("OnGetScoreboardData "..#players)
	for k, v in ipairs(players) do
		ExecuteWebJS(Gui_main, "AddPlayer("..v[4].." , '"..v[1].."', '"..v[2].."', '"..v[3].."')")
	end
end
AddRemoteEvent("OnGetScoreboardData", OnGetScoreboardData)