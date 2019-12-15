local timer 	= 0
local checkTime = 500

-------------------------------------
---         ANTI TELEPORT         ---
-------------------------------------
local ANTI_TELEPORT 	= true

local distanceThreshold = 900
local aimingThreshold 	= 255
local vehicleThreshold 	= 12000
--UNEDITABLE
local lastLocations = {}
-------------------------------------



function OnPackageStart()
	Delay(2000, function()
		timer = CreateTimer(AcMain, checkTime)
	end)
end
AddEvent("OnPackageStart", OnPackageStart)


function AddOACMessage(player, message)
	--AddPlayerChat(player, '<span color="#ffffff">[</><span color="#f58a07">OAC</><span color="#ffffff">] </><span color="#cf4036">'..message..'</>')
end


function SafeTeleport(player, x,y,z)
	PauseTimer(timer)
	Delay(10, function()
		lastLocations[player] = {}
		lastLocations[player].x = x
		lastLocations[player].y = y
		lastLocations[player].z = z
		SetPlayerLocation(player, x,y,z)
		Delay(100, function()
			UnpauseTimer(timer)
		end)
	end)
	
	
end
AddEvent("SafeTeleport", SafeTeleport)


function SafeTeleportVehicle(player, vehicle, x,y,z)
	PauseTimer(timer)
	Delay(10, function()
		lastLocations[player] = {}
		lastLocations[player].x = x
		lastLocations[player].y = y
		lastLocations[player].z = z
		SetVehicleLocation(vehicle, x,y,z)
		Delay(100, function()
			UnpauseTimer(timer)
		end)
	end)
	
	
end
AddEvent("SafeTeleportVehicle", SafeTeleportVehicle)

local lastVeh = {}
local lastAim = {}
function AcMain()
	for _,v in pairs(GetAllPlayers()) do
		--ANTI TELEPORT // SPEED HACK MODULE 
		if ANTI_TELEPORT and GetPlayerPropertyValue(v, "loaded") ~= nil then

			local x,y,z = GetPlayerLocation(v)
			if lastLocations[v] ~= nil then
				local l = lastLocations[v]
				local inVeh = false

				local distance = distanceThreshold
				if GetPlayerVehicle(v) ~= 0 or lastVeh[v] then
					distance = vehicleThreshold
					inVeh = true
					lastVeh[v] = true
				else
					lastVeh[v] = false
				end

				if IsPlayerAiming(v) then
					if lastAim[v] then
						distance = aimingThreshold
					end
					lastAim[v] = true
				else
					lastAim[v] = false
				end

				if GetDistance3D(x,y,0,l.x,l.y,0) >= distance then
					if inVeh then
						CallEvent("SafeTeleportVehicle", v, GetPlayerVehicle(v), l.x,l.y,l.z + 100)
						--print("(".. v ..") " .. GetPlayerName(v) .. " moved too quickly: " .. math.floor(GetDistance3D(x,y,0,l.x,l.y,0) / 100) .. " meters in " .. (checkTime / 1000) .." seconds")
						AddOACMessage(v, "You moved too quickly!")
					else
						CallEvent("SafeTeleport", v, l.x,l.y,l.z + 50)
						--print("(".. v ..") " .. GetPlayerName(v) .. " moved too quickly: " .. math.floor(GetDistance3D(x,y,0,l.x,l.y,0) / 100) .. " meters in " .. (checkTime / 1000) .." seconds")
						AddOACMessage(v, "You moved too quickly!")
					end
				end	

			end
			lastLocations[v] = {}	
			lastLocations[v].x = x
			lastLocations[v].y = y
			lastLocations[v].z = z
		end
	end
end

AddEvent("OnPlayerQuit", function(player)
	lastLocations[player] = nil
end)