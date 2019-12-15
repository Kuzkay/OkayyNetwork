local Atms = Atm.atms

function OnPackageStart()

	Delay(5000, function ()
		local i = 1
		for _ in pairs(Atms) do
			local obj = CreatePickup(336, Atms[i].x, Atms[i].y, Atms[i].z - 100)
			SetPickupScale(obj, 1.0,1.0,0.5)
			SetPickupPropertyValue(obj, "type", "atm", true)
			SetPickupPropertyValue(obj, "color", "2aeb3d", true)
			i = i + 1
		end
	end)
	
end
AddEvent("OnPackageStart", OnPackageStart)

function WithdrawMoney(player, amount)
	amount = tonumber(amount)
	if GetPlayerBank(player) >= amount then
		RemovePlayerBank(player, amount)
		AddPlayerMoney(player, amount)
	else
		CallRemoteEvent(player, "KNotify:Send", "Not enough money on the bank", "#f00")
	end
end
AddRemoteEvent("Kuzkay:AtmWithdraw", WithdrawMoney)

function DepositMoney(player, amount)
	amount = tonumber(amount)
	if GetPlayerMoney(player) >= amount then
		RemovePlayerMoney(player, amount)
		AddPlayerBank(player, amount)
	else
		CallRemoteEvent(player, "KNotify:Send", "Not enough cash", "#f00")
	end
end
AddRemoteEvent("Kuzkay:AtmDeposit", DepositMoney)