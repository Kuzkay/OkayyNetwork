function teleportUp(player, terrain)

	local x, y, z = GetPlayerLocation(player)
	CallEvent("SafeTeleport", player, x, y, terrain + 200)
end

AddRemoteEvent("Kuzkay:UnderMapFix", teleportUp)