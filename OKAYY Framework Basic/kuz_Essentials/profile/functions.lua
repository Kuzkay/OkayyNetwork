function SavePlayer(player)
	SavePlayerData(player)
	SavePlayerInventory(player)
	SendPlayerInventory(player)
end
AddFunctionExport("savePlayer", SavePlayer)

--PlayerData

function GetPlayerData(player)
	return PlayerData[player]
end
AddFunctionExport("getPlayerData", GetPlayerData)

--ROLE
function GetPlayerRole(player)
	if PlayerData[player] ~= nil then
		return PlayerData[player].role
	else
		return ""
	end
end
AddFunctionExport("getPlayerRole", GetPlayerRole)

--JOB
function SetPlayerJob(player, job, grade)
	grade = tonumber(grade)
	if Jobs[job] ~= nil and Jobs[job].grades[grade] ~= nil and PlayerData[player] ~= nil then
		PlayerData[player].job = job
		PlayerData[player].job_grade = grade
		PlayerData[player].job_title 			= Jobs[job].title
		PlayerData[player].job_grade_title 		= Jobs[job].grades[tonumber(grade)].grade_title
		CallEvent("OnJobChange", player, job, grade)
		CallRemoteEvent(player, "OnJobChange", job, grade)
		SavePlayerData(player)
		return true
	else
		return false
 	end
end
AddFunctionExport("setPlayerJob", SetPlayerJob)

function GetPlayerJob(player)
	if PlayerData[player] ~= nil then
		
		if PlayerData[player].job ~= nil then
			return PlayerData[player].job
		else
			return ''
		end
	else
		return ''
	end
end
AddFunctionExport("getPlayerJob", GetPlayerJob)

function GetPlayerJobGrade(player)
	if PlayerData[player] ~= nil then
		
		if PlayerData[player].job_grade ~= nil then
			return tonumber(PlayerData[player].job_grade)
		else
			return 1
		end
	else
		return 1
	end
end
AddFunctionExport("getPlayerJobGrade", GetPlayerJobGrade)

--MONEY

function GetPlayerMoney(player)
	return tonumber(PlayerData[player].money)
end
AddFunctionExport("getMoney", GetPlayerMoney)


function AddPlayerMoney(player, amount)
	amount = tonumber(amount)
	if amount > 0 then
		amount = math.floor(amount)
		PlayerData[player].money = PlayerData[player].money + amount
		SavePlayerData(player)
	end
end
AddFunctionExport("addMoney", AddPlayerMoney)


function RemovePlayerMoney(player, amount)
	amount = tonumber(amount)
	if amount > 0 then
		amount = math.floor(amount)
		PlayerData[player].money = PlayerData[player].money - amount
		SavePlayerData(player)
	end
end
AddFunctionExport("removeMoney", RemovePlayerMoney)


--BANK

function GetPlayerBank(player)
	return tonumber(PlayerData[player].bank)
end
AddFunctionExport("getBank", GetPlayerBank)


function AddPlayerBank(player, amount)
	amount = tonumber(amount)
	if amount > 0 then
		amount = math.floor(amount)
		PlayerData[player].bank = PlayerData[player].bank + amount
		SavePlayerData(player)
	end
end
AddFunctionExport("addBank", AddPlayerBank)


function RemovePlayerBank(player, amount)
	amount = tonumber(amount)
	if amount > 0 then
		amount = math.floor(amount)
		PlayerData[player].bank = PlayerData[player].bank - amount
		SavePlayerData(player)
	end
end
AddFunctionExport("removeBank", RemovePlayerBank)


-- LEVEL

function GetPlayerLevel(player)
	return PlayerData[player].level
end
AddFunctionExport("getLevel", GetPlayerLevel)


function AddPlayerLevel(player, amount)
	amount = tonumber(amount)
	if amount > 0 then
		amount = math.floor(amount)
		PlayerData[player].level = PlayerData[player].level + amount
		SavePlayerData(player)
	end
end
AddFunctionExport("addLevel", AddPlayerLevel)


function RemovePlayerLevel(player, amount)
	amount = tonumber(amount)
	if amount > 0 then
		amount = math.floor(amount)
		PlayerData[player].level = PlayerData[player].level - amount
		PlayerData[player].experience = 0
		SavePlayerData(player)
	end
end
AddFunctionExport("removeLevel", RemovePlayerLevel)


-- EXPERIENCE

function GetPlayerExperience(player)
	return PlayerData[player].experience
end
AddFunctionExport("getExperience", GetPlayerExperience)


function AddPlayerExperience(player, amount)
	amount = tonumber(amount)
	if amount > 0 then

		if (PlayerData[player].experience + amount) >= (PlayerData[player].level * (PlayerData[player].level/2) * 50) then

			local restXP = (PlayerData[player].experience + amount) - (PlayerData[player].level * (PlayerData[player].level/2) * 50)
			print(restXP)
			PlayerData[player].level = PlayerData[player].level + 1
			PlayerData[player].experience = restXP
			SavePlayerData(player)
		else
			amount = math.floor(amount)
			PlayerData[player].experience = PlayerData[player].experience + amount
			SavePlayerData(player)
		end

		
	end
end
AddFunctionExport("addExperience", AddPlayerExperience)


function RemovePlayerExperience(player, amount)
	amount = tonumber(amount)
	if amount > 0 then
		amount = math.floor(amount)
		PlayerData[player].experience = PlayerData[player].experience - amount
		SavePlayerData(player)
	end
end
AddFunctionExport("removeExperience", RemovePlayerExperience)



function GiveMoneyToPlayer(player, amount, toplayer)
	amount = tonumber(amount)
	toplayer = tonumber(toplayer)
	if amount <= 0 then
		CallRemoteEvent(player, 'KNotify:Send', "Try me bitch", "#000")
	else
		if GetPlayerMoney(player) >= amount then
			RemovePlayerMoney(player, amount)
			AddPlayerMoney(toplayer, amount)
			CallRemoteEvent(player, 'KNotify:Send', "You gave $" .. amount .. ' to ' .. GetPlayerName(toplayer), "#77f")
			CallRemoteEvent(toplayer, 'KNotify:Send', "You recieved $" .. amount .. ' to ' .. GetPlayerName(player), "#77f")
		else
			CallRemoteEvent(player, 'KNotify:Send', "You don't have enough cash", "#f00")
		end
	end
	
end
AddRemoteEvent("Kuzkay:GiveMoneyToPlayer", GiveMoneyToPlayer)


