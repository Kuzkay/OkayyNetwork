local ui = 0
local timer = 0

function OnPackageStart()
	ui = CreateWebUI(0, 0, 0, 0, 5, 30)
	LoadWebFile(ui, "http://asset/kuz_Notifications/gui/notify.html")
	SetWebAlignment(ui, 0.0, 0.0)
	SetWebAnchors(ui, 0.0, 0.0, 1.0, 1.0)
	SetWebVisibility(ui, WEB_HIDDEN)
end
AddEvent("OnPackageStart", OnPackageStart)

function SendNotification(text, color)
	SetWebVisibility(ui, WEB_HITINVISIBLE)
	if IsValidTimer(timer) then
		DestroyTimer(timer)
	end
	timer = CreateTimer(HideUI, 8000)
	if color == nil then color = "#999" end
	ExecuteWebJS(ui, 'SendNotification("'..text..'","'..color..'")')
end
AddEvent('KNotify:Send', SendNotification)
AddRemoteEvent('KNotify:Send', SendNotification)


function SendPress(text)
	SetWebVisibility(ui, WEB_HITINVISIBLE)
	if IsValidTimer(timer) then
		DestroyTimer(timer)
	end
	timer = CreateTimer(HideUI, 8000)
	ExecuteWebJS(ui, 'SendPress("'..text..'")')
end
AddEvent('KNotify:SendPress', SendPress)
AddRemoteEvent('KNotify:SendPress', SendPress)

function HidePress()
	ExecuteWebJS(ui, 'HidePress()')
end
AddEvent('KNotify:HidePress', HidePress)
AddRemoteEvent('KNotify:HidePress', HidePress)

function HideUI()
	ExecuteWebJS(ui, 'HidePress()')
end


local progressBars = {}
function AddProgressBar(text, duration, color, id, automatic)
	RemoveProgressBar(id)
	local time = tonumber(duration - 1) * 10
	ExecuteWebJS(ui, 'AddProgressBar("'..text..'", "'..color..'","'..id..'")')

	if automatic or automatic == nil then
		progressBars[id] = {}
		progressBars[id].progress = 1
		progressBars[id].timer = CreateTimer(MoveProgressBar, time, id)
	end
end
AddEvent('KNotify:AddProgressBar', AddProgressBar)
AddRemoteEvent('KNotify:AddProgressBar', AddProgressBar)

function MoveProgressBar(id)
	if progressBars[id].progress >= 100 then
		if progressBars[id].timer ~= 0 then
			DestroyTimer(progressBars[id].timer)
			progressBars[id].timer = 0
		end
		Delay(5000, function()
			if progressBars[id].timer == 0 then
				RemoveProgressBar(id)
			end
		end)
	else
		progressBars[id].progress = progressBars[id].progress + 1
		SetProgressBar(id, progressBars[id].progress)
	end
end

function SetProgressBarText(id, text)
	ExecuteWebJS(ui, 'SetProgressBarText("'..id..'","'..text..'")')
end
AddEvent('KNotify:SetProgressBarText', SetProgressBarText)
AddRemoteEvent('KNotify:SetProgressBarText', SetProgressBarText)


function SetProgressBar(id, progress)
	ExecuteWebJS(ui, 'MoveProgressBar("'..id..'","'..progress..'")')
end
AddEvent('KNotify:SetProgressBar', SetProgressBar)
AddRemoteEvent('KNotify:SetProgressBar', SetProgressBar)

function RemoveProgressBar(id)
	if progressBars[id] ~= nil then
		if IsValidTimer(progressBars[id].timer) then
			DestroyTimer(progressBars[id].timer)
		end
	end
	ExecuteWebJS(ui, 'RemoveProgressBar("'..id..'")')
end
AddEvent('KNotify:RemoveProgressBar', RemoveProgressBar)
AddRemoteEvent('KNotify:RemoveProgressBar', RemoveProgressBar)



