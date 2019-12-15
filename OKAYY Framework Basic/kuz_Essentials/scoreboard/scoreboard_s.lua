function UpdateScoreboardData(playerid)
	local PlayerTable = { }
	
	local i = 1
	for _, v in ipairs(GetAllPlayers()) do
		
		local job = GetPlayerJob(v)
		--local job = 'none'

		if job == nil then
			job = "#"
		end

		if IsValidPlayer(v) then
			PlayerTable[i] = {
				GetPlayerName(v),
				job,
				GetPlayerPing(v),
				v
			}
			i = i + 1
		end
	end
	
	CallRemoteEvent(playerid, "OnGetScoreboardData", "OKAYY FRAMEWORK  (" .. math.floor(GetServerTickRate()) .."Hz)", GetPlayerCount(), GetMaxPlayers(), PlayerTable)
end
AddRemoteEvent("UpdateScoreboardData", UpdateScoreboardData)


function cmd_stoppack(player, package_)

	StopPackage(package_)
end
AddCommand("stoppack", cmd_stoppack)