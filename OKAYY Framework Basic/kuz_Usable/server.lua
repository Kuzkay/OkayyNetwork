local kes = ImportPackage('kuz_Essentials')
function UseBandage(player, item)
	if GetPlayerHealth(player) >= 100 then
		CallRemoteEvent(player, 'KNotify:Send', "You're too healthy to use a bandage", "#f00")
	else
		if kes.removeItem(player, item, 1) then
			if GetPlayerHealth(player) + 30 <= 100 then 
				SetPlayerHealth(player, GetPlayerHealth(player) + 30)
			else
				SetPlayerHealth(player, 100)
			end
		end
	end
	
end
AddEvent('Kuzkay:UseItem:bandage', UseBandage)



function UseFirework(player, item)
	
	if kes.removeItem(player, item, 1) then
		CreateFireworks(player, 2000)
	end
	
	
end
AddEvent('Kuzkay:UseItem:firework', UseFirework)


function UseBigFirework(player, item)
	
	if kes.removeItem(player, item, 1) then
		local x,y,z = GetPlayerLocation(player)

		CreateFireworks(player, 3000)
		CreateFireworks(player, 5000)
		CreateFireworks(player, 6000)
		CreateFireworks(player, 8000)
		CreateFireworks(player, 9000)
		CreateFireworks(player, 10000)
		CreateFireworks(player, 12000)
		CreateFireworks(player, 13000)
	end
	
	
end
AddEvent('Kuzkay:UseItem:bigfirework', UseBigFirework)


function CreateFireworks(player, delay)
	local x,y,z = GetPlayerLocation(player)
	Delay(delay, function()
		local t = math.random(1,13)
		local rx = math.random(70,110)
		local ry = math.random(-20,20)
		local rz = math.random(-20,20)
		for k,v in pairs(GetAllPlayers()) do
			CallRemoteEvent(v, "CreateFireworks", t,x,y,z,rx,ry,rz)
		end
	end)
end




local repairDuration = 20000
function UseRepairkit(player, item)
	if GetPlayerVehicle(player) == 0 then
		local veh, dist = GetNearestVehicle(player)

		if veh ~= 0 then
			if dist <= 400 then
				if kes.removeItem(player, item, 1) then
					SetPlayerAnimation(player, "THINKING")
					CallEvent("freeze", player)
					SetVehicleHoodRatio(veh, 75)
					CallRemoteEvent(player, "KNotify:AddProgressBar", "Repairing Vehicle", repairDuration / 1000, "#914339", "veh_repair")
					Delay(repairDuration * 0.35, function()
						SetPlayerAnimation(player, "PICKUP_MIDDLE")
					end)
					Delay(repairDuration * 0.55, function()
						SetPlayerAnimation(player, "COMBINE")
					end)
					Delay(repairDuration * 0.85, function()
						SetPlayerAnimation(player, "PICKUP_MIDDLE")
					end)
					Delay(repairDuration, function()
						CallRemoteEvent(player, "KNotify:SetProgressBarText", "veh_repair", "Vehicle has been repaired")
						CallEvent("unfreeze", player)
						SetVehicleHealth(veh, 5000)
						SetVehicleDamage(veh, 1, 0.0)
						SetVehicleDamage(veh, 2, 0.0)
						SetVehicleDamage(veh, 3, 0.0)
						SetVehicleDamage(veh, 4, 0.0)
						SetVehicleDamage(veh, 5, 0.0)
						SetVehicleDamage(veh, 6, 0.0)
						SetVehicleDamage(veh, 7, 0.0)
						SetVehicleDamage(veh, 8, 0.0)
						SetVehicleHoodRatio(veh, 0)
					end)
				end
			else
				CallRemoteEvent(player, "KNotify:Send", "No nearby vehicles", "#f00")
			end
		else
			CallRemoteEvent(player, "KNotify:Send", "No nearby vehicles", "#f00")
		end
	else
		CallRemoteEvent(player, "KNotify:Send", "You can't do this inside the vehicle", "#f00")
	end
	
	
	
end
AddEvent('Kuzkay:UseItem:repairkit', UseRepairkit)


function GetNearestVehicle(player)
	local vehicles = GetStreamedVehiclesForPlayer(player)
	local found = 0
	local nearest_dist = 999999.9
	local x, y, z = GetPlayerLocation(player)

	for _,v in pairs(vehicles) do
		local x2, y2, z2 = GetVehicleLocation(v)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)
		if dist < nearest_dist then
			nearest_dist = dist
			found = v
		end
	end
	return found, nearest_dist
end





