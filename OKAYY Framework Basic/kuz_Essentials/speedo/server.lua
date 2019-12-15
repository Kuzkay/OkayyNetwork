function GetVehicle(player)
	local vehicle 	= GetPlayerVehicle(player)
	CallRemoteEvent(player, "Kuzkay:ReturnVehicle", vehicle)
end
AddRemoteEvent("Kuzkay:GetVehicle", GetVehicle)



function OnEnterVehicle(player, _vehicle, seat)
	CallRemoteEvent(player, "Kuzkay:ReturnVehicle", _vehicle)
end
AddEvent("OnPlayerEnterVehicle", OnEnterVehicle)

function OnLeaveVehicle(player, _vehicle, seat)
	CallRemoteEvent(player, "Kuzkay:ReturnVehicle", 0)
end
AddEvent("OnPlayerLeaveVehicle", OnLeaveVehicle)




