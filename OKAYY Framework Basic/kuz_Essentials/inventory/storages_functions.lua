function AddStorageItem(storage, item, amount, player)

	local success = false
	if tonumber(amount) <= 0 then
		return false
	else
		local slots = 0

		for _ in pairs(Storages[storage].items) do
			slots = slots + 1
		end

		local allowed = false
		local locations = 0

		local a = 1
		local found = 0
		for _ in pairs(Storages[storage].items) do
			
			if (Storages[storage].items[a].item == item and found == 0) then
				
				if (Storages[storage].items[a].amount < tonumber(Items[item].max)) then
					locations = locations + (tonumber(Items[item].max) - Storages[storage].items[a].amount)
				end
			end
			a = a + 1
		end

		--HAS ENOUGH SPACE TO FILL IN NEW SLOTS
		if (amount / tonumber(Items[item].max) <= (Storages[storage].slots - slots)) or (locations + ((Storages[storage].slots - slots) * tonumber(Items[item].max)) >= tonumber(amount)) then
			allowed = true
		end

		local added = 0
		if allowed then
			for i=1,amount do

				local itemCount = 1
				
				local foundID = 0
				local rest = 0
				for _ in pairs(Storages[storage].items) do
					
					if (Storages[storage].items[itemCount].item == item and foundID == 0) then
						if (tonumber(Storages[storage].items[itemCount].amount) + 1 <= tonumber(Items[item].max)) and added < tonumber(amount) then
							foundID = itemCount
							Storages[storage].items[itemCount].amount = math.floor(tonumber(Storages[storage].items[itemCount].amount) + 1)
							added = added + 1
						end
					end

					itemCount = itemCount + 1
				end

				if foundID == 0 then
					Storages[storage].items[itemCount] = {}
					Storages[storage].items[itemCount].item = item
					Storages[storage].items[itemCount].amount = 1
				end

			end
			
			success = true
		else
			return false
		end
	end
	if success then
		SaveStorageInventory(storage)
		if player ~= nil then
			SendStorageInventory(player, storage)
		end
		return true
	else
		return false
	end

end
AddFunctionExport("addStorageItem", AddStorageItem)




function RemoveStorageItem(storage, item, amount, player)

	if tonumber(amount) <= 0 then
		return false
	else
		local possibleCount = 0
		local amount = tonumber(amount)


		local i = 1
		for _ in pairs(Storages[storage].items) do
					
			if (Storages[storage].items[i].item == item and possibleCount < amount) then
				possibleCount = possibleCount + tonumber(Storages[storage].items[i].amount)
			end

			i = i + 1
		end

		if possibleCount >= amount then
			
			local slots = 0
			for _ in pairs(Storages[storage].items) do
				slots = slots + 1
			end

			local itemID = slots
			local removeLeft = amount
			for i=1, itemID do
				
				if (Storages[storage].items[itemID].item == item and removeLeft > 0) then


					if (tonumber(Storages[storage].items[itemID].amount) <= removeLeft) then
						removeLeft = removeLeft - tonumber(Storages[storage].items[itemID].amount)
						table.remove(Storages[storage].items, itemID)
						local r = 1
						for _ in pairs(Storages[storage].items) do
							if (r > itemID) then
								if Storages[storage].items[r + 1] ~= nil then
									Storages[storage].items[r] = Storages[storage].items[r + 1]
								end
							end
							r = r + 1
						end
						Storages[storage].items[r] = nil
					else
						Storages[storage].items[itemID].amount = tonumber(Storages[storage].items[itemID].amount) - removeLeft
						removeLeft = 0
					end


				end

				itemID = itemID - 1
			end
			SaveStorageInventory(storage)
			if player ~= nil then
				SendStorageInventory(player, storage)
			end
			return true
		else
			return false
		end
	end
end
AddFunctionExport("removeStorageItem", RemoveStorageItem)

function GetStorageItemCount(storage, item)

	amount = tonumber(amount)
	local itemCount = 0
	local amount = tonumber(amount)


	local i = 1
	for _ in pairs(Storages[storage].items) do
					
		if (Storages[storage].items[i].item == item) then
			itemCount = itemCount + tonumber(Storages[storage].items[i].amount)
		end
		i = i + 1
	end
	return tonumber(itemCount)
end
AddFunctionExport("getStorageItemCount", GetStorageItemCount)

function CreateStorage(storage, player, slots)
	if Storages[storage] == nil then
		CreateStorageInventory(player, storage, nil, slots)
	end
end
AddFunctionExport("createStorage", CreateStorage)


function ClearStorage(storage, player)

	local i = 1
	Storages[storage].items = {}

	SaveStorageInventory(storage)
	if player ~= nil then
		SendStorageInventory(player, storage)
	end
end
AddFunctionExport("clearStorage", ClearStorage)




function split(pString, pPattern)
   local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pPattern
   local last_end = 1
   local s, e, cap = pString:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
     table.insert(Table,cap)
      end
      last_end = e+1
      s, e, cap = pString:find(fpat, last_end)
   end
   if last_end <= #pString then
      cap = pString:sub(last_end)
      table.insert(Table, cap)
   end
   return Table
end


local housing = nil
AddEvent("Kuzkay:HousingLoaded", function()
	housing = ImportPackage("kuz_Housing")
end)


function PutItemInStorage(player, item, amount, storage)
	if string.match(storage, "HOUSING-") then
		local house = split(storage, "-")[2]
		local owner = housing.getOwner(house)
		if owner.owner ~= tostring(GetPlayerSteamId(player)) then
			CallRemoteEvent(player, "KNotify:Send", "You can't access this storage", "#000")
			return
		end
	end

	if GetPlayerItemCount(player, item) >= tonumber(amount) then
		if AddStorageItem(storage, item, tonumber(amount), player) then
			RemovePlayerItem(player, item, amount)
		else
			CallRemoteEvent(player, 'KNotify:Send', "Storage is full", "#f00")
		end
	else
		CallRemoteEvent(player, 'KNotify:Send', "Not enough items", "#f00")
	end
end
AddRemoteEvent("Kuzkay:OnPutItemInStorage", PutItemInStorage)





function PutItemInInventory(player, item, amount, storage)
	if string.match(storage, "HOUSING-") then
		local house = split(storage, "-")[2]
		local owner = housing.getOwner(house)
		if owner.owner ~= tostring(GetPlayerSteamId(player)) then
			CallRemoteEvent(player, "KNotify:Send", "You can't access this storage", "#000")
			return
		end
	end

	if GetStorageItemCount(storage, item) >= tonumber(amount) then
		if AddPlayerItem(player, item, tonumber(amount)) then
			RemoveStorageItem(storage, item, amount, player)
		end
	else
		CallRemoteEvent(player, 'KNotify:Send', "Not enough items in storage", "#f00")
	end
end
AddRemoteEvent("Kuzkay:OnPutItemInInventory", PutItemInInventory)