local SERVER_ID = 1

Items = {}

Inventories = {}

Storages = {}

local wep_loaded = {}

function OnPackageStart()
	Delay(1000, function()
		local query = mariadb_prepare(sql, "SELECT * FROM items ORDER BY title;")
		mariadb_query(sql, query, GetAllItems)

		local query = mariadb_prepare(sql, "SELECT * FROM `storages` WHERE `server` = '?';", SERVER_ID)
		mariadb_query(sql, query, GetStorages)
	end)
	
end
AddEvent("OnPackageStart", OnPackageStart)


function OnRoleSelect(player, role)

	SetPlayerPropertyValue(player, "playerName", GetPlayerName(player), true)
	Inventories[player] = {}
	Inventories[player].items = {}
	Inventories[player].weapons = {}
	local query = mariadb_prepare(sql, "SELECT inventory FROM profiles WHERE `steamid` = '?' AND `role` = '?'  LIMIT 1;", 
		tostring(GetPlayerSteamId(player)), 
		role)

		
		mariadb_query(sql, query, GetPlayerInventory, player)
end
AddEvent("Kuzkay:RoleSelected", OnRoleSelect)

function GetAllItems()
	local i = 1
	for i = 1,mariadb_get_row_count() do
		local result = mariadb_get_assoc(i)

		Items[result.item] = {}

		Items[result.item].item = result.item
		Items[result.item].title = result.title
		Items[result.item].plural = result.title_plural
		Items[result.item].max = result.max
		Items[result.item].order = i;
		Items[result.item].model = result.model
		Items[result.item].model_scale = result.model_scale
		i = i + 1
	end
end

function GetPlayerInventory(player)
	if mariadb_get_row_count() > 0 then
		local result = mariadb_get_assoc(1)
		if result.inventory ~= nil then
			Inventories[player] = jsondecode(result.inventory)

			if Inventories[player].items ~= nil then
				local i = 1
				for _ in pairs(Inventories[player].items) do
					if Items[Inventories[player].items[i].item] == nil then
						print("removed bugged item: " .. Inventories[player].items[i].item)
						table.remove(Inventories[player].items, i)
					end
					i = i + 1
				end
			end
			
		end
			wep_loaded[player] = false
			if Inventories[player].items == nil then
				Inventories[player].items = {}
			end
			Delay(8000, SetPlayerWeapons, player)
			Delay(10500, SendPlayerInventory, player)
	end
end



function SendPlayerInventory(player)
	CallRemoteEvent(player, "Kuzkay:ClearClientItems")

	if Inventories[player].items ~= nil then
		local i = 1
		for _ in pairs(Inventories[player].items) do
			CallRemoteEvent(player, "Kuzkay:AddClientItem", Inventories[player].items[i], i, Items[Inventories[player].items[i].item].title, Items[Inventories[player].items[i].item].order) 
			i = i + 1
		end
	end
	SavePlayerInventory(player)
end

function SetPlayerWeapons(player)
	if Inventories[player] ~= nil then
		if Inventories[player].weapons ~= nil then
			if Inventories[player].weapons[1] ~= nil then
				SetPlayerWeapon(player, Inventories[player].weapons[1].weapon, Inventories[player].weapons[1].ammo, true, 1)
			else
				SetPlayerWeapon(player, 1, 1, true, 1)			
			end

			if Inventories[player].weapons[2] ~= nil then
				SetPlayerWeapon(player, Inventories[player].weapons[2].weapon, Inventories[player].weapons[2].ammo, false, 2)
			else
				SetPlayerWeapon(player, 1, 1, false, 2)		
			end

			if Inventories[player].weapons[3] ~= nil then
				SetPlayerWeapon(player, Inventories[player].weapons[3].weapon, Inventories[player].weapons[3].ammo, false, 3)
			else
				SetPlayerWeapon(player, 1, 1, false, 3)		
			end
		end
		
	end

	wep_loaded[player] = true
end

function SavePlayerInventory(player)
	if loaded[player] and wep_loaded[player] then
		Inventories[player].weapons = {}
		local w, a= GetPlayerWeapon(player, 1)
		Inventories[player].weapons[1] = {}
		Inventories[player].weapons[1].weapon = w
		Inventories[player].weapons[1].ammo = a
		local w, a = GetPlayerWeapon(player, 2)
		Inventories[player].weapons[2] = {}
		Inventories[player].weapons[2].weapon = w
		Inventories[player].weapons[2].ammo = a
		local w, a= GetPlayerWeapon(player, 3)
		Inventories[player].weapons[3] = {}
		Inventories[player].weapons[3].weapon = w
		Inventories[player].weapons[3].ammo = a


		local query = mariadb_prepare(sql, "UPDATE `profiles` SET `inventory` = '?' WHERE `steamid` = '?' and `role` = '?';",
		jsonencode(Inventories[player]),
		

		tostring(GetPlayerSteamId(player)),
		PlayerData[player].role)
		mariadb_query(sql, query)
	end
end


function OnPlayerQuit(player)
	SavePlayerInventory(player)
	Delay(50, function()
		Inventories[player] = nil
	end)
	
end
AddEvent("OnPlayerQuit", OnPlayerQuit)



function SendStorageInventory(player, storage, vehicle)
	if Storages[storage] == nil and Storages ~= {} then
		CreateStorageInventory(player, storage, vehicle)
	else
		if vehicle ~= nil then
			CallRemoteEvent(player, "Kuzkay:ClearClientStorage", Config.VehicleSlots[GetVehicleModel(vehicle)])
		else
			CallRemoteEvent(player, "Kuzkay:ClearClientStorage", Storages[storage].slots)
		end
		if vehicle ~= nil then
			Storages[storage].vehicle = vehicle
		end
		local i = 1
		for _ in pairs(Storages[storage].items) do
			if vehicle ~= nil then
				Storages[storage].slots = Config.VehicleSlots[GetVehicleModel(vehicle)]
			end
			CallRemoteEvent(player, "Kuzkay:AddClientStorage", Storages[storage].items[i], i, Items[Storages[storage].items[i].item].title, Items[Storages[storage].items[i].item].order, storage, Storages[storage].slots)
			i = i + 1
		end
		SaveStorageInventory(storage)
		
	end
	
end
AddRemoteEvent("Kuzkay:StorageRequest", SendStorageInventory)
AddEvent("Kuzkay:StorageRequest", SendStorageInventory)

function GetStorages()
	local i = 1
	for i = 1,mariadb_get_row_count() do
		local result = mariadb_get_assoc(i)

		Storages[result.storage]			= {}
		if result.inventory ~= nil then
			Storages[result.storage]			= jsondecode(result.inventory)
		end
		Storages[result.storage].slots		= result.slots
		Storages[result.storage].vehicle   = 0

		i = i + 1

	end
	print("kuz_Essentials: Done loading all storages")
end


function SaveStorageInventory(storage)

	local query = mariadb_prepare(sql, "UPDATE `storages` SET `inventory` = '?' WHERE `storage` = '?' AND `server` = '?';",
	jsonencode(Storages[storage]),
	

	storage,
	SERVER_ID)
	mariadb_query(sql, query, OnSaveStorageInventory, storage)
end
function OnSaveStorageInventory(storage)
	
end

function CreateStorageInventory(player, storage, vehicle, slots_)
	local slots = 12
	if vehicle ~= nil then
		slots = Config.VehicleSlots[GetVehicleModel(vehicle)]
	end
	if slots_ ~= nil then
		slots = slots_
	end

	if Storages[storage] == nil and storage ~= nil then
		Storages[storage] = {}
		Storages[storage].items = {}
		Storages[storage].slots = slots
		local query = mariadb_prepare(sql, "INSERT INTO `storages` (`server`, `inventory`, `storage`, `slots`) VALUES ('?', '?', '?', '?');",
		SERVER_ID,
		jsonencode(Storages[storage]),
		storage,
		slots)
		mariadb_query(sql, query, OnCreateStorageInventory, storage)

		CallRemoteEvent(player, "Kuzkay:ClearClientStorage", Storages[storage].slots)
	end
end
function OnCreateStorageInventory(storage)
	print('Created storage save for ' .. storage)
end


