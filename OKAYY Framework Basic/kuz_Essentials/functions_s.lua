local DEBUG = false
local frozen = {}


local freezeTimer = 0
AddEvent("OnPackageStart", function()
	freezeTimer = CreateTimer(FreezeRun, 250)
end)


function FreezeRun()
	for _, v in pairs(GetAllPlayers()) do
		if GetPlayerPropertyValue(v, "freeze") then
			local x,y,z = GetPlayerLocation(v)
			CallRemoteEvent(v, "keepfrozen")
			if GetDistance3D(x,y,z,frozen[v].x, frozen[v].y, frozen[v].z) >= 30 then
				CallEvent("SafeTeleport",v, frozen[v].x, frozen[v].y, frozen[v].z)
			end
		end
	end
end



function unfreeze(player)
	SetPlayerPropertyValue(player, "freeze", false, true)
	CallRemoteEvent(player, "unfreeze")
end
AddEvent("unfreeze", unfreeze)

function freeze(player)
	frozen[player] = {}
	frozen[player].x, frozen[player].y, frozen[player].z = GetPlayerLocation(player)
	SetPlayerPropertyValue(player, "freeze", true, true)
end
AddEvent("freeze", freeze)


function GetNearbyPlayers(player, range)
	local x, y, z = GetPlayerLocation(player)
	local players = GetPlayersInRange3D(x,y,z,range)
	CallRemoteEvent(player, "Kuzkay:getNearbyPlayers", players)
end
AddRemoteEvent("Kuzkay:getNearbyPlayers", GetNearbyPlayers)



function SaveAdminLog(player, command, message)
	local query = mariadb_prepare(sql, "INSERT INTO `admin_commands` (`steamid`, `name`, `command`, `message`) VALUES ('?', '?', '?', '?');",
		tostring(GetPlayerSteamId(player)),
		GetPlayerName(player),
		command,
		message)
		mariadb_query(sql, query)
end
AddEvent("SaveAdminLog", SaveAdminLog)






local offsets = {
    ["1111"] = { -- Fishing Rod
        hand_r = {-8,6.5,-8,0,180,15}
    },
    ["1047"] = { -- Chainsaw
        hand_r = {-25,13,18,70,150,0}
    },
    ["620"] = { -- Trashsack
        hand_r = {-95,9,5,-90,60,-60}
    },
    ["654"] = { -- Package
        hand_r = {-40,20,0,90,90,0}
    },
    ["1075"] = { -- Saw
        hand_r = {-10,0,0,-30,30,50}
    },
    ["552"] = { -- Cutter
        hand_r = {-14,3,10,60,-130,0}
    },
    ["1630"] = { --Beer
    	hand_r = {-5,1,-9,30,0,12}
    },
    ["1613"] = { --Vodka
    	hand_r = {-3,3,-9,30,0,10}
    },
    ["1238"] = { --Tequilla
    	hand_r = {-3,3,-9,30,0,10}
    }
}

local objects = {}

function SetAttachedItem(player, slot, type)
    if objects[player] ~= nil then
        if objects[player][slot] ~= nil then
            DestroyObject(objects[player][slot])
            objects[player][slot] = nil
        end
    else
        objects[player] = {}
    end
    if type == 0 then
        return
    end
    local offset = {0,0,0,0,0,0}
    if offsets[tostring(type)] ~= nil then
        if offsets[tostring(type)][slot] ~= nil then
            offset = offsets[tostring(type)][slot]
        end
    end
    local x, y, z = GetPlayerLocation(player)
    objects[player][slot] = CreateObject(type, x, y, z)
    Delay(100, function()
        SetObjectAttached(objects[player][slot], 1, player, offset[1], offset[2], offset[3], offset[4], offset[5], offset[6], slot)
    end)
    return tonumber(objects[player][slot])
end
AddFunctionExport("setAttachedItem", SetAttachedItem)

function GetAttachedItem(player, slot)
    if objects[player] == nil then
        return 0
    end
    if objects[player][slot] == nil then
        return 0
    end
    return tonumber(objects[player][slot])
end
AddFunctionExport("getAttachedItem", GetAttachedItem)

AddEvent("OnPlayerQuit", function(player)
    if objects[player] == nil then
        return
    end
    for k,v in pairs(objects[player]) do
        DestroyObject(objects[player][k])
    end
    objects[player] = nil
end)




function SetAttachedItemTest(player, slot, type, ox, oy, oz, rx, ry, rz)
    if objects[player] ~= nil then
        if objects[player][slot] ~= nil then
            DestroyObject(objects[player][slot])
        end
    else
        objects[player] = {}
    end
    if type == 0 then
        return
    end
    local x, y, z = GetPlayerLocation(player)
    objects[player][slot] = CreateObject(type, x, y, z)
    Delay(100, function()
        SetObjectAttached(objects[player][slot], 1, player, ox, oy, oz, rx, ry, rz, slot)
    end)
end

if DEBUG then
    AddCommand("item", function(player, slot, type)
        SetAttachedItem(player, slot, tonumber(type))
        AddPlayerChat(player, "Set item!")
    end)

    AddCommand("itemtest", function(player, slot, type, x, y, z, rx, ry, rz)
        SetAttachedItemTest(player, slot, tonumber(type), x, y, z, rx, ry, rz)
        AddPlayerChat(player, "Set item!")
    end)
end









local ratio = {}
function UpdateTrunkRatio(vehicle, toggle)
    if GetVehicleModel(vehicle) ~= 0 then
        
        local curr = GetVehicleTrunkRatio(vehicle)
        if ratio[vehicle] >= curr and toggle then
            SetVehicleTrunkRatio(vehicle, curr + 1)
            if GetVehicleTrunkRatio(vehicle) > 0 then
                SetVehicleTrunkRatio(vehicle, curr + 1)
                Delay(10, UpdateTrunkRatio, vehicle, toggle)
            end
        else 
            if ratio[vehicle] < curr and not toggle then
                SetVehicleTrunkRatio(vehicle, curr - 1)
                Delay(10, UpdateTrunkRatio, vehicle, toggle)
            end
        end
        
    end
end

function ToggleTrunk(player, vehicle, toggle)
    if GetVehicleModel(vehicle) ~= 0 then
        if toggle then
            ratio[vehicle] = 65
            UpdateTrunkRatio(vehicle, toggle)
        else
            ratio[vehicle] = 0
            UpdateTrunkRatio(vehicle, toggle)
        end
    end
end
AddRemoteEvent("Kuzkay:ToggleTrunk", ToggleTrunk)
