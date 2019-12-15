local Shops = Shop.Shops
local Selling = Shop.Selling
local Buying = Shop.Buying

function OnPackageStart()

	Delay(5000, function ()
		local i = 1
		for _ in pairs(Shops) do
			Shops[i].npc = CreateNPC(Shops[i].x, Shops[i].y, Shops[i].z, Shops[i].h)

			SetNPCPropertyValue(Shops[i].npc, 'model', Shops[i].npc_model, true)

			SetNPCAnimation(Shops[i].npc, "CROSSARMS", true)
			SetNPCHealth(Shops[i].npc, 999999999)
			CreateText3D(Shops[i].name, 16, Shops[i].x, Shops[i].y, Shops[i].z + 130, 0,0,0)
			i = i + 1
		end
	end)
	
end
AddEvent("OnPackageStart", OnPackageStart)



function OpenShopMenu(player, shop_type)
	local range = false
	local hasType = false
	local x,y,z = GetPlayerLocation(player)
	for k,v in pairs(Shops) do
		if v.type == shop_type then
			hasType = true
			if GetDistance3D(v.x, v.y, v.z, x, y, z) <= 500 then
				range = true
			end
		end
	end
	if not range and hasType then
		return
	end

	CallRemoteEvent(player, "KUI:Create", "shop", "STORE")

	local i = 1
	for _ in pairs(Selling[shop_type]) do

		local buy = Selling[shop_type][i]

		local color = "lightgreen"
		if GetPlayerMoney(player) < tonumber(buy.price) then
			color = "red"
		end
		

		local item = {item=buy.item,shop_type=shop_type,type="buy"}
		CallRemoteEvent(player, "KUI:AddOption", jsonencode(item), buy.label, '<label style="font-size:165%; color: '..color..'; margin-left: -0.55vh;">$'..buy.price..'</label>', "Purchase")
		i = i + 1
	end


	local i = 1
	for _ in pairs(Buying[shop_type]) do

		local sell = Buying[shop_type][i]

		local color = "gold"	

		local item = {item=sell.item,shop_type=shop_type,type="sell"}
		CallRemoteEvent(player, "KUI:AddOption", jsonencode(item), sell.label, '<label style="font-size:165%; color: '..color..'; margin-left: -0.55vh;">$'..sell.price..'</label>', "Sell")
		i = i + 1
	end
	

	CallRemoteEvent(player, 'KUI:Show', 'shop', true)

end
AddRemoteEvent("Kuzkay:ShopOpenShopMenu", OpenShopMenu)
AddEvent("Kuzkay:ShopOpenShopMenu", OpenShopMenu)

function OnShopOptionPress(player, params_)
	local params = jsondecode(params_)
	local item = params.item
	local shop_type = params.shop_type
	local type = params.type

	if type == "buy" then
		PurchaseItem(player, item, shop_type)
	else
		SellItem(player, item, shop_type)
	end

end
AddRemoteEvent("KUI:OptionClick_shop", OnShopOptionPress)

function PurchaseItem(player, item, shop_type)
	amount = 1
	local i = 1
	for _ in pairs(Selling[shop_type]) do
		local itemData = Selling[shop_type][i]
		
		local hasType = false
		local verified = false
		local x,y,z = GetPlayerLocation(player)
		local k = 1
		for _ in pairs(Shops) do
			if Shops[k].type == shop_type then
				if GetDistance3D(x,y,z, Shops[k].x,Shops[k].y,Shops[k].z) <= 600 then
					verified = true
				end
				hasType = true
			end
			k = k + 1
		end
		if not hasType then
			verified = true
		end

		if itemData.item == item and amount >= 1 and verified then
			if GetPlayerMoney(player) >= (tonumber(itemData.price) * amount) then
				if AddPlayerItem(player, item, amount) then
					RemovePlayerMoney(player, math.floor(itemData.price * amount))
				end
			else
				CallRemoteEvent(player, 'KNotify:Send', "You can't afford this", "#f00")
			end
		end
		i = i + 1
	end
end
AddRemoteEvent("Kuzkay:ShopsBuy", PurchaseItem)

function SellItem(player, item, shop_type)
	amount = 1
	local i = 1
	for _ in pairs(Buying[shop_type]) do
		local itemData = Buying[shop_type][i]
		
		if itemData.item == item and amount >= 1 then
			if RemovePlayerItem(player, item, amount) then
				AddPlayerMoney(player, math.floor(amount * tonumber(itemData.price)))
			end
		end
		i = i + 1
	end
end
AddRemoteEvent("Kuzkay:ShopsSell", SellItem)

AddEvent("Kuzkay:RobberyStarted", function(id)
	local i = 1
	for _ in pairs(Shops) do
		if Shops[i].robbery_id == id then
			SetNPCAnimation(Shops[i].npc, "HANDSUP_KNEEL", true)
		end
		i = i + 1
	end
end)

AddEvent("Kuzkay:RobberyEnded", function(id)
	Delay(5000, function()
		local i = 1
		for _ in pairs(Shops) do
			if Shops[i].robbery_id == id then
				SetNPCAnimation(Shops[i].npc, "CROSSARMS", true)
			end
			i = i + 1
		end
	end)
end)