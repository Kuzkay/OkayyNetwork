local up = false

function OnKeyPress(key)
	if key == "X" and not GetPlayerPropertyValue(GetPlayerId(), 'dead') and not GetPlayerPropertyValue(GetPlayerId(), 'cuffed') then
		ToggleHands()
	end
end
AddEvent("OnKeyPress", OnKeyPress)

function ToggleHands()
	up = not up
	if IsCtrlPressed() then
		CallRemoteEvent("kuzkay:handsup", up, 2)
	else
		CallRemoteEvent("kuzkay:handsup", up, 1)
	end
end


