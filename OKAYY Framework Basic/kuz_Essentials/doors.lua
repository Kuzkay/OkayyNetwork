local housing = nil

AddEvent("Kuzkay:HousingLoaded", function()
	housing = ImportPackage("kuz_Housing")
end)

AddEvent("OnPlayerInteractDoor", function(player, door, bWantsOpen)

	local x,y,z = GetDoorLocation(door)

	--PRISON DOORS
	if GetDistance3D(x,y,z,-174222,82732,1628) <= 60000 then
		if GetPlayerJob(player) ~= "police" then
			CallRemoteEvent(player, "KNotify:Send", "Only Police can access these doors", "#a11")
			return
		end
	end


	--HOUSING DOORS
	if housing ~= nil then
		local house = housing.checkDoorsInside(door, false)
		if house ~= 0 and house ~= nil then
			local owner = housing.getOwner(house)
			if owner.owner ~= tostring(GetPlayerSteamId(player)) then
				CallRemoteEvent(player, "KNotify:Send", "You do not have the keys to these doors", "#a11")
				return
			end
		end
	end

	SetDoorOpen(door, not IsDoorOpen(door))
end)