local timer = 0

function OnPackageStart()
	timer = CreateTimer(Refresh, 500)
end
AddEvent("OnPackageStart", OnPackageStart)

local cooldown = false
local action = nil
local attr = nil
local callType = nil
function OnKeyPress(key)
	if key == "E" and action ~= nil and not cooldown and not GetPlayerPropertyValue(GetPlayerId(), 'cuffed') and not GetPlayerPropertyValue(GetPlayerId(), 'dead') then

		if callType == nil or callType == "server" then
			if attr ~= nil then
				CallRemoteEvent(action, attr)
			else
				CallRemoteEvent(action)
			end
		else
			if attr ~= nil then
				CallEvent(action, attr)
			else
				CallEvent(action)
			end
		end
		cooldown = true
		Delay(1000, function()
			cooldown = false
		end)
	end
end
AddEvent("OnKeyPress", OnKeyPress)



local last = false
function Refresh()
	local got = false


	local pickups = GetStreamedPickups()
	local x,y,z = GetPlayerLocation()
	for k,v in pairs(pickups) do
		if GetPickupPropertyValue(v, "action") ~= nil then
			local px,py,pz = GetPickupLocation(v)
			if GetDistance3D(x,y,z,px,py,pz) <= GetPickupPropertyValue(v, "action_range") then
				got = true
				action = GetPickupPropertyValue(v, "action")

				if GetPickupPropertyValue(v, "action_attr") ~= nil then
					attr = GetPickupPropertyValue(v, "action_attr")
				end

				if GetPickupPropertyValue(v, "action_type") ~= nil then
					callType = GetPickupPropertyValue(v, "action_type")
				end

				CallEvent("KNotify:SendPress", GetPickupPropertyValue(v, "action_text"))
			end
		end
	end


	local objects = GetStreamedObjects()
	local x,y,z = GetPlayerLocation()
	for k,v in pairs(objects) do
		if GetObjectPropertyValue(v, "action") ~= nil then
			local px,py,pz = GetObjectLocation(v)
			if GetDistance3D(x,y,z,px,py,pz) <= GetObjectPropertyValue(v, "action_range") then
				got = true
				action = GetObjectPropertyValue(v, "action")

				if GetObjectPropertyValue(v, "action_attr") ~= nil then
					attr = GetObjectPropertyValue(v, "action_attr")
				end

				if GetObjectPropertyValue(v, "action_type") ~= nil then
					callType = GetObjectPropertyValue(v, "action_type")
				end

				CallEvent("KNotify:SendPress", GetObjectPropertyValue(v, "action_text"))
			end
		end
	end

	if not got and last then
		CallEvent("KNotify:HidePress")
		action = nil
		attr = 0
		callType = nil
	end
	last = got

end