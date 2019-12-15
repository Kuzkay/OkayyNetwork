local speed_timer = 0


local vehicle = nil


function OnPackageStart()
	Delay(1000, function()
		speed_timer = CreateTimer(GetSpeedData, 150)
	end)
	
end
AddEvent("OnPackageStart", OnPackageStart)


function GetSpeedData()
	if vehicle ~= 0 and vehicle ~= nil and vehicle ~= '0' then
		local speed = math.floor(GetVehicleForwardSpeed(vehicle))
		local rpm = math.floor(GetVehicleEngineRPM(vehicle))
		ExecuteWebJS(Gui_main, "SetVehicleSpeed('".. speed .."','".. rpm .."')")
	end

end


function OnGetVehicle(_vehicle)
	vehicle = _vehicle
	if vehicle ~= 0 then
		ExecuteWebJS(Gui_main, "ToggleSpeedo(true);")
	else
		ExecuteWebJS(Gui_main, "ToggleSpeedo(false);")
	end

end
AddRemoteEvent("Kuzkay:ReturnVehicle", OnGetVehicle)

function EnableSpeedStep(key)
	if key == "W" and IsPlayerInVehicle() then
		speedStep = true
	end
end
AddEvent('OnKeyPress', EnableSpeedStep)
function DisableSpeedStep(key)
	if key == "W" and IsPlayerInVehicle() then
		speedStep = false
	end
end
AddEvent('OnKeyRelease', DisableSpeedStep)

