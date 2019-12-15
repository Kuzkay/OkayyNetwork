AddRemoteEvent("kuzkay:handsup", function(player, up, type)
	if up then
		if type == 1 then
			SetPlayerAnimation(player, 'HANDSUP_STAND')
		else
			SetPlayerAnimation(player, 'HANDSHEAD_KNEEL')
		end
	else
		SetPlayerAnimation(player, 'STOP')
	end

end)

