local ui = 0
local open = false
local pickupTimer = 0
local trunkOpen = false

function OnPackageStart()
	ui = CreateWebUI(0, 0, 0, 0, 5, 50)
	LoadWebFile(ui, "http://asset/kuz_Essentials/inventory/gui/inventory.html")
	SetWebAlignment(ui, 0.0, 0.0)
	SetWebAnchors(ui, 0.0, 0.0, 1.0, 1.0)
	SetWebVisibility(ui, WEB_HIDDEN)
	pickupTimer = CreateTimer(OnPickupUpdate, 5)

end
AddEvent("OnPackageStart", OnPackageStart)

function ShowSelectionScreen()
	
	
end
AddRemoteEvent("Kuzkay:SteamReady", ShowSelectionScreen)

function OnKeyPress(key)
	if key == "F2" and not GetPlayerPropertyValue(GetPlayerId(), 'dead') and not GetPlayerPropertyValue(GetPlayerId(), 'cuffed') then
		ToggleInventory()
		ExecuteWebJS(ui, 'ClearStorageItems();')
		ExecuteWebJS(ui, 'ShowStorage(false);')
	end
	if key == "Escape" then
		open = false
		if trunkOpen then
			trunkOpen = false
			local veh, distance = GetNearestVehicle()
			CallRemoteEvent('Kuzkay:ToggleTrunk', veh, false)
		end
		SetWebVisibility(ui, WEB_HIDDEN)
		SetIgnoreLookInput(false)
		ShowMouseCursor(false)
		SetInputMode(INPUT_GAME)
	end
end
AddEvent("OnKeyPress", OnKeyPress)



function GetNearPlayers(players_)
	local players = players_


	ExecuteWebJS(ui, 'ClearPlayers();')
	Delay(100, function()
		for _,v in pairs(players) do
			if v ~= GetPlayerId() then --
				local playerName = GetPlayerPropertyValue(v, "playerName")

				local playerID = tonumber(v)
				
				Delay(10, function()
					ExecuteWebJS(ui, 'InsertPlayer('.. playerID ..',"'.. playerName .. '");')
				end)
			end
		end
	end)
end
AddRemoteEvent("Kuzkay:getNearbyPlayers", GetNearPlayers)

function OnPlayerUseItem(item)
	CallRemoteEvent('Kuzkay:UseItem', item)
end
AddEvent('Kuzkay:CallUseItem', OnPlayerUseItem)

function SetInventoryOpen(bool)
	open = not bool
	ToggleInventory()
end

function ToggleInventory()
	open = not open

	if open then
		CallRemoteEvent("Kuzkay:getNearbyPlayers", 500)
		SetWebVisibility(ui, WEB_VISIBLE)
		SetIgnoreLookInput(true)
		ShowMouseCursor(true)
		SetInputMode(INPUT_GAMEANDUI)
	else
		if trunkOpen then
			trunkOpen = false
			local veh, distance = GetNearestVehicle()
			CallRemoteEvent('Kuzkay:ToggleTrunk', veh, false)
		end
		SetWebVisibility(ui, WEB_HIDDEN)
		SetIgnoreLookInput(false)
		ShowMouseCursor(false)
		SetInputMode(INPUT_GAME)
	end
end

function ClearInventoryUi()
	ExecuteWebJS(ui, 'ClearItems();')
end
AddRemoteEvent("Kuzkay:ClearClientItems", ClearInventoryUi)

function AddClientItem(item, id, title, order)
	ExecuteWebJS(ui, "InsertItem('".. id .."','".. item.item .."','".. item.amount .."','".. title .."','".. order .."');")
end
AddRemoteEvent("Kuzkay:AddClientItem", AddClientItem)


function OnDropItem(item, amount)
	CallRemoteEvent('Kuzkay:OnDropItem', item, amount)
end
AddEvent('Kuzkay:DropItem', OnDropItem)




local pickupID = 0
local pickupText = nil

function OnPickupUpdate()

	local pickups = GetStreamedPickups()
	local x, y, z = GetPlayerLocation()
	local set = false

	

	local i = 1
	for _ in pairs(pickups) do
		local xp, yp, zp = GetPickupLocation(pickups[i])
		if GetDistance3D(xp, yp, zp, x,y,z) < 150 and GetPickupPropertyValue(pickups[i], 'type') == 'drop' then
			pickupID = pickups[i]
			set = true
			local a,sx,sy = WorldToScreen(xp, yp, zp, true)
			if pickupText ~= nil then
				DestroyTextBox(pickupText)
			end
			pickupText = CreateTextBox(math.floor(sx), math.floor(sy), '<span size="16" color="#ffffff">PRESS </><span size="16" color="#e69d0b">[</><span size="16">E</><span size="16" color="#e69d0b">]</><span size="16"> TO PICKUP</>', "center")
		end
		i = i + 1
	end
	if not set then
		pickupID = 0
		if pickupText ~= nil then
			DestroyTextBox(pickupText)
			pickupText = nil
		end
	end
end
function OnKeyPress(key)
	if key == "E" and pickupID ~= 0 and not GetPlayerPropertyValue(GetPlayerId(), 'dead') and not IsPlayerReloading() then
		CallRemoteEvent("Kuzkay:ConfirmPickup", pickupID)
	end
end
AddEvent("OnKeyPress", OnKeyPress)


function OnGiveMoney(amount, toplayer)
	CallRemoteEvent('Kuzkay:GiveMoneyToPlayer', amount, toplayer)
end
AddEvent('Kuzkay:OnGiveMoney', OnGiveMoney)

function OnGiveItem(item, amount, toplayer)
	CallRemoteEvent('Kuzkay:GiveItemToPlayer', item, amount, toplayer)
end
AddEvent('Kuzkay:OnGiveItem', OnGiveItem)







function OnKeyPress(key)
	if key == "U" and not IsPlayerInVehicle() and not GetPlayerPropertyValue(GetPlayerId(), 'dead')  then
		local veh, distance = GetNearestVehicle()
		if veh ~= 0 and distance <= 400 then
			local vx, vy, vz = GetVehicleForwardVector(veh)
			local x, y, z = GetVehicleLocation(veh)
			local px, py, pz = GetPlayerLocation()
			if GetDistance3D(x - (vx * 150), y - (vy * 150), z +100, px, py, pz) <= 300 then
				OpenTrunk(GetVehicleLicensePlate(veh))
			end
		end
	end
end
AddEvent("OnKeyPress", OnKeyPress)


local checkTrunkTimer = 0
function CheckTrunk(veh)
	if GetWebVisibility(ui) and GetVehicleModel(veh) ~= 0 then

		local vx, vy, vz = GetVehicleForwardVector(veh)
		local x, y, z = GetVehicleLocation(veh)
		local px, py, pz = GetPlayerLocation()
		if trunkOpen and GetDistance3D(x - (vx * 150), y - (vy * 150), z +100, px, py, pz) > 300 then
			ExecuteWebJS(ui, 'ShowStorage(false);')
			CallRemoteEvent('Kuzkay:ToggleTrunk', veh, false)
			open = false
			trunkOpen = false
			SetWebVisibility(ui, WEB_HIDDEN)
			SetIgnoreLookInput(false)
			ShowMouseCursor(false)
			SetInputMode(INPUT_GAME)
		end

	else
		if checkTrunkTimer ~= 0 then
			DestroyTimer(checkTrunkTimer)
		end
	end
end


function OpenTrunk(plate)

	local veh, distance = GetNearestVehicle()

	if not GetVehiclePropertyValue(veh, "locked") then
		if checkTrunkTimer ~= 0 then
			DestroyTimer(checkTrunkTimer)
		end

		checkTrunkTimer = CreateTimer(CheckTrunk, 200, veh)
		ExecuteWebJS(ui, "SetStorageID('Vehicle-"..plate.."');")
		CallRemoteEvent('Kuzkay:StorageRequest', "Vehicle-" .. plate, veh)
		ExecuteWebJS(ui, 'ShowStorage(true);')
		ToggleInventory()
		trunkOpen = open
		CallRemoteEvent('Kuzkay:ToggleTrunk', veh, open)
	else
		CallEvent('KNotify:Send', "This vehicle is locked!", "#f00")
	end
end

function ShowStorage(storage)
	ExecuteWebJS(ui, 'ShowStorage(true);')
	ExecuteWebJS(ui, "SetStorageID('"..storage.."');")
	SetInventoryOpen(true)
end
AddRemoteEvent("Kuzkay:showStorage", ShowStorage)

function HideInventory()
	SetInventoryOpen(false)
end
AddRemoteEvent("Kuzkay:HideInventory", HideInventory)

function ClearStorageUi(slots)
	ExecuteWebJS(ui, 'ClearStorageItems("'..slots..'");')
end
AddRemoteEvent("Kuzkay:ClearClientStorage", ClearStorageUi)



function AddClientStorage(item, id, title, order, storage, slots)
	ExecuteWebJS(ui, "InsertStorageItem('".. id .."','".. item.item .."','".. item.amount .."','".. title .."','".. order .."','".. storage .."','"..slots.."');")
end
AddRemoteEvent("Kuzkay:AddClientStorage", AddClientStorage)

function GetNearestVehicle()
	local vehicles = GetStreamedVehicles()
	local found = 0
	local nearest_dist = 999999.9
	local x, y, z = GetPlayerLocation()

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


function PutItemInStorage(item, amount, storage)
	CallRemoteEvent("Kuzkay:OnPutItemInStorage", item, amount, storage)
end
AddEvent("Kuzkay:PutItemInStorage", PutItemInStorage)

function PutItemInInventory(item, amount, storage)
	CallRemoteEvent("Kuzkay:OnPutItemInInventory", item, amount, storage)
end
AddEvent("Kuzkay:PutItemInInventory", PutItemInInventory)