local timer = 0
local time = 9
local weather = 1

local passTime = 0.00333333333

local AUTO_BLUR = false
local inHeli = false
AddRemoteEvent("Kuzkay:SyncTime", function(time_,weather_)
	time = time_
	SetTime(time)
	SetWeather(weather_)
end)




function OnPackageStart()
	timer = CreateTimer(AddTime, 10000)
end
AddEvent("OnPackageStart", OnPackageStart)

function AddTime()

	time = time + (passTime * 10)

	if time >= 24 then
		time = 0
	end

	if (time > 18 or time < 6) and not inHeli then
		if AUTO_BLUR then
			SetPostEffect("DepthOfField", "DepthBlurRadius", 0.0)
		end
	else
		if AUTO_BLUR then
			SetPostEffect("DepthOfField", "DepthBlurRadius", 30.0)
		end
	end

	SetTime(time)
end

AddEvent("OnPlayerEnterVehicle", function(player)
	if AUTO_BLUR then
		veh = GetPlayerVehicle()
		if GetVehicleModel(tonumber(veh)) == 10 or GetVehicleModel(tonumber(veh)) == 20 then
			inHeli = true
			SetPostEffect("DepthOfField", "DepthBlurRadius", 30.0)
			AddPlayerChat('set blurr')
		end
	end
end)

AddEvent("OnPlayerLeaveVehicle", function()
	if AUTO_BLUR then
		inHeli = false
		if (time > 18 or time < 6) then
			SetPostEffect("DepthOfField", "DepthBlurRadius", 0.0)
			AddPlayerChat('set no blurr')
		end
	end
end)