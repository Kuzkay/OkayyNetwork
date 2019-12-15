local mode = 0

function OnKeyPress(key)
	if key == "V" and not IsPlayerInVehicle() then
		mode = mode + 1
		if mode >= 6 then
			mode = 0
		end

		if mode == 5 then
			EnableFirstPersonCamera(true)
			SetNearClipPlane(25)
		else
			EnableFirstPersonCamera(false)
			SetNearClipPlane(0)
		end

		if mode == 0 then
			SetCameraViewDistance(150)
		end	
		if mode == 1 then
			SetCameraViewDistance(225)
		end	
		if mode == 2 then
			SetCameraViewDistance(300)
		end
		if mode == 3 then
			SetCameraViewDistance(375)
		end
		if mode == 4 then
			SetCameraViewDistance(450)
		end

		
	end
end
AddEvent("OnKeyPress", OnKeyPress)