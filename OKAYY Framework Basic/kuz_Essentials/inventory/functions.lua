function AddPlayerItem(player, item, amount)

	local success = false
	if tonumber(amount) <= 0 then
		return false
	else
		local slots = 0



		for _ in pairs(Inventories[player].items) do
				slots = slots + 1
		end

		local allowed = false
		local locations = 0

		local a = 1
		local found = 0
		for _ in pairs(Inventories[player].items) do
			
			if (Inventories[player].items[a].item == item and found == 0) then
				
				if (Inventories[player].items[a].amount < tonumber(Items[item].max)) then
					locations = locations + (tonumber(Items[item].max) - Inventories[player].items[a].amount)
				end
			end
			a = a + 1
		end

		--HAS ENOUGH SPACE TO FILL IN NEW SLOTS
		if (amount / tonumber(Items[item].max) <= (15 - slots)) or (locations + ((15 - slots) * tonumber(Items[item].max)) >= tonumber(amount)) then
			allowed = true
		end

		local added = 0
		if allowed then
			for i=1,amount do

				local itemCount = 1
				
				local foundID = 0
				local rest = 0
				for _ in pairs(Inventories[player].items) do
					
					if (Inventories[player].items[itemCount].item == item and foundID == 0) then
						if (tonumber(Inventories[player].items[itemCount].amount) + 1 <= tonumber(Items[item].max)) and added < tonumber(amount) then
							foundID = itemCount
							Inventories[player].items[itemCount].amount = math.floor(tonumber(Inventories[player].items[itemCount].amount) + 1)
							added = added + 1
						end
					end

					itemCount = itemCount + 1
				end

				if foundID == 0 then
					Inventories[player].items[itemCount] = {}
					Inventories[player].items[itemCount].item = item
					Inventories[player].items[itemCount].amount = 1
				end

			end
			
			success = true
		else
			CallRemoteEvent(player, 'KNotify:Send', "Not enough inventory space", "#f00")
			return false
		end
	end
	if success then
		if tonumber(amount) > 1 then
			CallRemoteEvent(player, 'KNotify:Send', "+ " .. amount .. ' ' .. Items[item].plural, "#0a0")
		else
			CallRemoteEvent(player, 'KNotify:Send', "+ " .. Items[item].title, "#0a0")
		end
		SavePlayerInventory(player)
		SendPlayerInventory(player)
		return true
	else
		CallRemoteEvent(player, 'KNotify:Send', "Something went wrong", "#000")
		return false
	end

end
AddFunctionExport("addItem", AddPlayerItem)




function RemovePlayerItem(player, item, amount)

	if tonumber(amount) <= 0 then
		return false
	else
		local possibleCount = 0
		local amount = tonumber(amount)


		local i = 1
		for _ in pairs(Inventories[player].items) do
					
			if (Inventories[player].items[i].item == item and possibleCount < amount) then
				possibleCount = possibleCount + tonumber(Inventories[player].items[i].amount)
			end

			i = i + 1
		end

		if possibleCount >= amount then
			
			local slots = 0
			for _ in pairs(Inventories[player].items) do
				slots = slots + 1
			end

			local itemID = slots
			local removeLeft = amount
			for i=1, itemID do
				
				if (Inventories[player].items[itemID].item == item and removeLeft > 0) then


					if (tonumber(Inventories[player].items[itemID].amount) <= removeLeft) then
						removeLeft = removeLeft - tonumber(Inventories[player].items[itemID].amount)
						local r = 1
						for _ in pairs(Inventories[player].items) do
							if (r > itemID) then
								if Inventories[player].items[r + 1] ~= nil then
									--Inventories[player].items[r] = Inventories[player].items[r + 1]
								end
							end
							r = r + 1
						end
						Inventories[player].items[r] = nil
						table.remove(Inventories[player].items, itemID)
					else
						if Inventories[player].items[itemID].item == item then
	 						Inventories[player].items[itemID].amount = tonumber(Inventories[player].items[itemID].amount) - removeLeft
						end
						removeLeft = 0
					end


				end

				itemID = itemID - 1
			end
			if tonumber(amount) > 1 then
				CallRemoteEvent(player, 'KNotify:Send', "- " .. amount .. ' ' .. Items[item].plural, "#a00")
			else
				CallRemoteEvent(player, 'KNotify:Send', "- " .. Items[item].title, "#a00")
			end
			SavePlayerInventory(player)
			SendPlayerInventory(player)
			return true
		else
			CallRemoteEvent(player, 'KNotify:Send', "Not enough items", "#f00")
			return false
		end
	end
end
AddFunctionExport("removeItem", RemovePlayerItem)

function ClearPlayerInventory(player)
	if Inventories[player].items ~= nil then
		Inventories[player].items = {}
		SavePlayerInventory(player)
		SendPlayerInventory(player)
	end
end
AddFunctionExport("clearPlayerInventory", ClearPlayerInventory)


function GetPlayerItemCount(player, item)

	amount = tonumber(amount)
	local itemCount = 0
	local amount = tonumber(amount)


	local i = 1
	for _ in pairs(Inventories[player].items) do
					
		if (Inventories[player].items[i].item == item) then
			itemCount = itemCount + tonumber(Inventories[player].items[i].amount)
		end
		i = i + 1
	end
	return tonumber(itemCount)
end
AddFunctionExport("getItemCount", GetPlayerItemCount)

function DropPlayerItem(player, item, amount)
	if GetPlayerPropertyValue(player, "dead") then
		return
	end

	amount = tonumber(amount)
	if GetPlayerVehicle(player) ~= 0 then
		CallRemoteEvent(player, 'KNotify:Send', "Can't drop items while inside a vehicle", "#f00")
	else
		if RemovePlayerItem(player, item, tonumber(amount)) then
			local x, y, z = GetPlayerLocation(player)
			local x = x + math.random(-120,120)
			local y = y + math.random(-120,120)
			
			local pickupModel = 509
			if Items[item].model ~= nil and Items[item].model ~= '' then
				pickupModel = tonumber(Items[item].model)
			end
			local pickupModelScale = 0.5
			if Items[item].model_scale ~= nil and Items[item].model_scale ~= '' then
				pickupModelScale = Items[item].model_scale
			end
			local pickup = CreatePickup(pickupModel, x, y, z - 70)


			SetPickupScale(pickup, pickupModelScale, pickupModelScale, pickupModelScale)
			SetPickupPropertyValue(pickup, "loc_x", x, true)
			SetPickupPropertyValue(pickup, "loc_y", y, true)
			SetPickupPropertyValue(pickup, "loc_z", z - 70, true)
			SetPickupPropertyValue(pickup, "type", 'drop', true)
			SetPickupPropertyValue(pickup, "typeDrop", 'item', true)
			SetPickupPropertyValue(pickup, "dropItem", item, true)
			SetPickupPropertyValue(pickup, "dropAmount", amount, true)
			local title = Items[item].title
			if amount > 1 then title = Items[item].plural end
			local text = CreateText3D("[".. title .." x" .. amount .. "]", 15.0, x, y, z, 0,0,0)
			SetText3DAttached(text, 3,pickup,0,0,70)

			SetPickupPropertyValue(pickup, "dropText", text, true)
			SetPlayerAnimation(player, "CHECK_EQUIPMENT")
		end
	end
	
	
end
AddRemoteEvent("Kuzkay:OnDropItem", DropPlayerItem)


function OnPickupConfirm(player, pickup)

	local x = GetPickupPropertyValue(pickup, "loc_x")
	local y = GetPickupPropertyValue(pickup, "loc_y")
	local z = GetPickupPropertyValue(pickup, "loc_z")
	--print(pickup)
	local px,py,pz = GetPlayerLocation(player)
	if GetDistance3D(x,y,z, px, py, pz) < 150 and GetPickupPropertyValue(pickup, "type") == "drop" and GetPickupPropertyValue(pickup, "typeDrop") == "item" then
		SetPlayerAnimation(player, "STOP")
		if AddPlayerItem(player, GetPickupPropertyValue(pickup, "dropItem"), GetPickupPropertyValue(pickup, "dropAmount")) then

			SetPickupPropertyValue(pickup, 'type', 'used')
			Delay(1000, DestroyDrop, pickup)

			local heading = math.deg(math.atan(py - y, px - x)) + 180
			SetPlayerHeading(player, heading)
			SetPlayerAnimation(player, "PICKUP_LOWER")
		end
	else
		if GetDistance3D(x,y,z, px, py, pz) < 150 and GetPickupPropertyValue(pickup, "type") == "drop" and GetPickupPropertyValue(pickup, "typeDrop") == "weapon" then
			local weapon_type = GetPickupPropertyValue(pickup, "dropWeapon")
				if (weapon_type ~= 21 and weapon_type ~= 4 and weapon_type ~= 6 and weapon_type ~= 11 and weapon_type ~= 17) or (GetPlayerJob(player) == "police") then
				SetPlayerAnimation(player, "STOP")
				local s1, a1 = GetPlayerWeapon(player, 1)
				local s2, a2 = GetPlayerWeapon(player, 2)
				local s3, a3 = GetPlayerWeapon(player, 3)

				local useSlot = 0
				if s1 == 1 then
					useSlot = 1
				else
					if s2 == 1 then
						useSlot = 2
					else
						if s3 == 1 then
							useSlot = 3
						end 
					end
				end

				if useSlot ~= 0 then
					SetPickupPropertyValue(pickup, 'type', 'used')
					Delay(1000, DestroyDrop, pickup)

					local weapon = GetPickupPropertyValue(pickup, "dropWeapon")
					local ammo = GetPickupPropertyValue(pickup, "dropAmmo")
					SetPlayerWeapon(player, weapon, ammo, false, useSlot)
					local heading = math.deg(math.atan(py - y, px - x)) + 180
					SetPlayerHeading(player, heading)
					SetPlayerAnimation(player, "PICKUP_LOWER")
					
					SavePlayerInventory(player)
				else
					CallRemoteEvent(player, 'KNotify:Send', "No free space for the weapon", "#f00")
				end
			else
				CallRemoteEvent(player, 'KNotify:Send', "This is a police only weapon!", "#f00")
			end
		end
	end
end
AddRemoteEvent("Kuzkay:ConfirmPickup", OnPickupConfirm)

function UseItem(player, item)
	if GetPlayerItemCount(player, item) > 0 then
		CallEvent('Kuzkay:UseItem:' .. item, player, item)
	end
end
AddRemoteEvent("Kuzkay:UseItem", UseItem)

function DestroyDrop(pickup)
	if GetPickupPropertyValue(pickup, "dropText") ~= nil then
		DestroyText3D(GetPickupPropertyValue(pickup, "dropText"))
	end
	DestroyPickup(pickup)
end



function GiveItemToPlayer(player, item, amount, toplayer)
	amount = tonumber(amount)
	toplayer = tonumber(toplayer)
	if amount <= 0 then
		CallRemoteEvent(player, 'KNotify:Send', "Try me bitch", "#000")
	else
		if RemovePlayerItem(player, item, amount) then
		if AddPlayerItem(toplayer, item, amount) then
			if tonumber(amount) > 1 then
				CallRemoteEvent(player, 'KNotify:Send', "You gave " .. amount .. ' ' .. Items[item].plural .. " to " .. GetPlayerName(toplayer), "#77f")
			else
				CallRemoteEvent(player, 'KNotify:Send', "You gave " .. Items[item].title .. " to " .. GetPlayerName(toplayer), "#77f")
			end

			if tonumber(amount) > 1 then
				CallRemoteEvent(toplayer, 'KNotify:Send', "You recieved " .. amount .. ' ' .. Items[item].plural .. " from " .. GetPlayerName(player), "#77f")
			else
				CallRemoteEvent(toplayer, 'KNotify:Send', "You recieved " .. Items[item].title .. " from " .. GetPlayerName(player), "#77f")
			end
		else
			AddPlayerItem(player, item, amount)
			CallRemoteEvent(player, 'KNotify:Send', "Player does'nt have enough inventory space", "#f00")
		end
	end
	end
	
end
AddRemoteEvent("Kuzkay:GiveItemToPlayer", GiveItemToPlayer)




function GetItemNames(item)
	return Items[item].title, Items[item].plural
end
AddFunctionExport("getItemNames", GetItemNames)





