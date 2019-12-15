local ui = 0
local inside = false
local last_check = false
local refreshTimer = 0

local Shops = nil
local Selling = nil
local Buying = nil

local currentType

function OnPackageStart()
	ui = CreateWebUI(0, 0, 0, 0, 5, 60)
	LoadWebFile(ui, "http://asset/kuz_Essentials/shops/gui/shops.html")
	SetWebAlignment(ui, 0.0, 0.0)
	SetWebAnchors(ui, 0.0, 0.0, 1.0, 1.0)
	SetWebVisibility(ui, WEB_HIDDEN)
	

	Delay(10000, function ()
		refreshTimer = CreateTimer(CheckInShop, 500)
		Shops = Shop.Shops
		Selling = Shop.Selling
		Buying = Shop.Buying
	end)
	
end
AddEvent("OnPackageStart", OnPackageStart)


function CheckInShop()
	
	
	local x,y,z = GetPlayerLocation()
	local got = false
	
	
	local i = 1
	for _ in pairs(Shops) do
		if GetDistance3D(x,y,z,Shops[i].x, Shops[i].y, Shops[i].z) <= 200 then
			inside = true
			got = true
				
			CallEvent("KNotify:SendPress", "Press [E] to open shop")
			currentType = Shops[i].type
		end
		i = i + 1
	end

	

	if last_check and not inside then
		CallEvent("KNotify:HidePress")
	end

	if not got then
		inside = false
	end

	if not inside then
		currentType = 0
	end

	last_check = inside
end

local cooldown = false
function OnKeyPress(key)
	if key == "E" and inside and currentType ~= 0 and not cooldown then
		cooldown = true
		CallRemoteEvent("Kuzkay:ShopOpenShopMenu", currentType)
		Delay(500, function()
			cooldown = false
		end)
	end
end
AddEvent("OnKeyPress", OnKeyPress)
