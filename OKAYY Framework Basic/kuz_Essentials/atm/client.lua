local ui = 0
local inside = false
local last_check = false
local refreshTimer = 0

local Atms = nil

local atmOpen = false

local bank = 0
local cash = 0

function AtmLoadedPlayer()
	Delay(3000, function ()
		ui = Gui_main
		Atms = Atm.atms
		ExecuteWebJS(ui, "SetFields('"..bank.."','"..cash.."');")
		refreshTimer = CreateTimer(CheckInAtm, 100)
	end)
end
AddRemoteEvent("Kuzkay:LoadingComplete", AtmLoadedPlayer)

function OpenAtm()
	atmOpen = true
	ExecuteWebJS(ui, "SetAmount('"..math.floor(cash).."');")
	ExecuteWebJS(ui, "ToggleAtm(true);")
	SetWebVisibility(ui, WEB_VISIBLE)
	SetIgnoreLookInput(true)
	SetIgnoreMoveInput(true)
	ShowMouseCursor(true)
	SetInputMode(INPUT_GAMEANDUI)
end
AddRemoteEvent('Kuzkay:AtmOpenUI', OpenAtm)

function CloseAtm()
	atmOpen = false
	ExecuteWebJS(ui, "ToggleAtm(false);")
	SetWebVisibility(ui, WEB_HITINVISIBLE)
	SetIgnoreLookInput(false)
	SetIgnoreMoveInput(false)
	ShowMouseCursor(false)
	SetInputMode(INPUT_GAME)
end
AddRemoteEvent('Kuzkay:AtmCloseUI', CloseAtm)

function CheckInAtm()
	
	inside = false
	local x,y,z = GetPlayerLocation()
	local distance = 0

	local currentAtm = 0

	local i = 1
	for _ in pairs(Atms) do
		if not inside then
			if GetDistance3D(x,y,z,Atms[i].x, Atms[i].y, Atms[i].z) <= 120 then
				distance = GetDistance3D(x,y,z,Atms[i].x, Atms[i].y, Atms[i].z)
				inside = true

				CallEvent("KNotify:SendPress", "Press [E] to open atm")

				currentAtm = i
			end
		end
		i = i + 1
	end

	if not inside or IsPlayerInVehicle() then
		if atmOpen then
			CloseAtm()
		end
	end
	if last_check and not inside then
		CallEvent("KNotify:HidePress")
	end
	last_check = inside
end

function OnKeyPress(key)
	if key == "E" and inside and not GetPlayerPropertyValue(GetPlayerId(), 'cuffed') and not GetPlayerPropertyValue(GetPlayerId(), 'dead') then
		if atmOpen then
			CloseAtm()
		else
			OpenAtm()
		end
	end
end
AddEvent("OnKeyPress", OnKeyPress)

AddEvent("Kuzkay:OnWithdraw", function (amount)
	CallRemoteEvent("Kuzkay:AtmWithdraw", amount)
end)
AddEvent("Kuzkay:OnDeposit", function (amount)
	CallRemoteEvent("Kuzkay:AtmDeposit", amount)
end)

function UpdateAtmData(money_, bank_, role, level, experience)
	bank = bank_
	cash = money_
	ExecuteWebJS(ui, "SetFields('"..math.floor(bank).."','"..math.floor(cash).."');")
end
AddRemoteEvent("Kuzkay:UpdateVisualData", UpdateAtmData)