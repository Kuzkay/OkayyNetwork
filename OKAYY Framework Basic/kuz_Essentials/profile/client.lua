local roleSelect = 0
local mainGui = 0

Gui_main = 0

function OnPackageStart()
	StartCameraFade(1.0, 1.0, 600.0, '#000')
end
AddEvent("OnPackageStart", OnPackageStart)

function ShowSelectionScreen()
	roleSelect = CreateWebUI(0, 0, 0, 0, 5, 30)
	LoadWebFile(roleSelect, "http://asset/kuz_Essentials/profile/login_gui/roleSelect.html")
	SetWebAlignment(roleSelect, 0.0, 0.0)
	SetWebAnchors(roleSelect, 0.0, 0.0, 1.0, 1.0)
	SetWebVisibility(roleSelect, WEB_VISIBLE)
	
	SetIgnoreMoveInput(true)
	SetIgnoreLookInput(true)
	Delay(1000, function ()
		SetInputMode(INPUT_GAMEANDUI)
		ShowMouseCursor(true)
	end)
	
end
AddRemoteEvent("Kuzkay:SteamReady", ShowSelectionScreen)

function SelectRole(role, location)
	CallRemoteEvent('Kuzkay:OnRoleSelect', role, location)
end
AddEvent("Kuzkay:OnSelectRole", SelectRole)


function OnLoadingComplete()
	StartCameraFade(1.0, 0.0, 4.0, "#000")
	SetIgnoreMoveInput(false)
	SetIgnoreLookInput(false)
	ShowMouseCursor(false)
	SetInputMode(INPUT_GAME)
	SetWebVisibility(roleSelect, WEB_HIDDEN)
	DestroyWebUI(roleSelect)
	ShowMainUi()


	SetPostEffect("Global", "Gamma", 0.95,0.95,0.95,0.9)
	SetPostEffect("Global", "Gain", 0.95,0.95,0.95,1.0)
	SetPostEffect("Global", "Saturation", 1.05,1.05,1.05,1.05)

	SetPostEffect("WhiteBalance", "Temp", 7500)
	SetPostEffect("WhiteBalance", "Tint", 0.0)

	
	SetPostEffect("Chromatic", "Intensity", 0.0)
	SetPostEffect("Chromatic", "StartOffset", 0.0)

	SetPostEffect("MotionWhiteBalanceBlur", "Temp", 7500)

	SetPostEffect("MotionBlur", "Amount", 0.05)
	SetPostEffect("MotionBlur", "Max", 1.0)

	SetPostEffect("Bloom", "Insensity", 1.0)

	SetPostEffect("DepthOfField", "DepthBlurRadius", 0.02)
	SetPostEffect("DepthOfField", "Distance", 500.0)
	SetPostEffect("DepthOfField", "DepthBlurSmoothKM", 0.5)

	SetPostEffect("ImageEffects", "GrainIntensity", 0.0)
	SetPostEffect("ImageEffects", "GrainJitter", 1.0)
	SetPostEffect("ImageEffects", "VignetteIntensity", 0.4)
end
AddRemoteEvent("Kuzkay:LoadingComplete", OnLoadingComplete)


function ShowMainUi()
	mainGui = CreateWebUI(0, 0, 0, 0, 5, 45)
	LoadWebFile(mainGui, "http://asset/kuz_Essentials/profile/main_gui/main.html")
	SetWebAlignment(mainGui, 0.0, 0.0)
	SetWebAnchors(mainGui, 0, 0, 1.0, 1.0)
	SetWebVisibility(mainGui, WEB_HITINVISIBLE)
	Gui_main = mainGui
	
end

local _money = 0
local _bank = 0
local _role = ""
local _level = 0
local _experience = 0

function UpdateVisualData(money, bank, role, level, experience)
	if mainGui ~= 0 then
		_money = money
		_bank = bank
		_role = role
		_level = level
		_experience = experience
		UpdateWebData()
	else
		Delay(1000, UpdateVisualData, money, bank, role, level, experience)
	end
end
AddRemoteEvent("Kuzkay:UpdateVisualData", UpdateVisualData)

AddEvent("OnWebLoadComplete", function(ui)
	if ui == mainGui then
		UpdateWebData()
		CallEvent("Kuzkay:MainGuiLoaded", mainGui)
	end
end)

function UpdateWebData()
	ExecuteWebJS(mainGui, "UpdateData('".. math.floor(_money) .."','".. math.floor(_bank) .."','".. _role .."','".. math.floor(_level) .."','".. math.floor(_experience) .."');")
	if not Config.ShowJob then
		ExecuteWebJS(mainGui, "hideJob();")
	end
	if not Config.ShowLevel then
		ExecuteWebJS(mainGui, "hideLevel();")
	end
	SetWebVisibility(mainGui, WEB_HITINVISIBLE)
end


local blind = false

function ToggleBlindness(key)
	if key == "F8" then
		blind = not blind
		if blind then
			StopCameraFade()
		else
			StartCameraFade(1.0,1.0,5,"ffffff")
		end
	end
end
AddEvent('OnKeyPress', ToggleBlindness)



