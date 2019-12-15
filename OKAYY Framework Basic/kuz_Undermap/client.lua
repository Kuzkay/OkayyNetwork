local checkTimer = 0
function OnPackageStart()
	Delay(5000, function()
		checkTimer = CreateTimer(Check, 5000)
		Check()
	end)
	
end
AddEvent("OnPackageStart", OnPackageStart)

function Check()
	local x, y, z = GetPlayerLocation()

	local terrain = GetTerrainHeight(x, y, 99999.9)

	if z < 0 and terrain -400 > z and not IsPlayerInVehicle() then
		CallRemoteEvent("Kuzkay:UnderMapFix", terrain)
		CallEvent('KNotify:Send', "You've been teleported as we detected you were underground", "#f00")
	end
	
end