Jobs = {}

PlayerData = {}
loaded = {}

local saveTimer = 0
local paycheckTimer = 0

local ALLOWED_ROLES = {
	"criminal"
}


local locations = {}

locations[1] = "162720,205073,1358,21"
locations[2] = "-19138,-3601,2081,23"
locations[3] = "-170655, -37717, 1146, 17"

function OnPackageStart()
	

	Delay(5000, function()
		saveTimer = CreateTimer(SaveAllData, Config.saveTime)
		
		local query = mariadb_prepare(sql, "SELECT * FROM `jobs`;")
		mariadb_query(sql, query, GetAllJobs)

	end)
end
AddEvent("OnPackageStart", OnPackageStart)



function GetAllJobs()
	local i = 1
	for i = 1,mariadb_get_row_count() do
		local result = mariadb_get_assoc(i)
		
		Jobs[result.name] = {}

		Jobs[result.name].name = result.name
		Jobs[result.name].title = result.title
		Jobs[result.name].grades = {}
		i = i + 1
	end
	
	local query = mariadb_prepare(sql, "SELECT * FROM `jobs_grades`;")
	mariadb_query(sql, query, GetAllJobGrades)
end

function GetAllJobGrades()
	local i = 1
	for i = 1,mariadb_get_row_count() do
		local result = mariadb_get_assoc(i)
		
		if Jobs[result.job] == nil then
			print(result.job .. " doesn't exist in 'jobs' table <found in job_grades>")
		end
		Jobs[result.job].grades[tonumber(result.job_grade)] = {}
			
		Jobs[result.job].grades[tonumber(result.job_grade)].grade = result.job_grade
		Jobs[result.job].grades[tonumber(result.job_grade)].grade_title = result.job_grade_title
		Jobs[result.job].grades[tonumber(result.job_grade)].paycheck 	= result.paycheck

		i = i + 1
	end
	paycheckTimer = CreateTimer(SendPaychecks, Config.PaycheckTime)
	print("kuz_Essentials: Loaded all jobs and job grades")

end

AddEvent("OnPlayerJoin", function (player)
	loaded[player] = false
	local fullName = GetPlayerName(player)
    	local name = fullName:gsub( "%W", "" )
    	SetPlayerName(player, name)
end)

function SendPaychecks()
	for _, v in pairs(GetAllPlayers()) do
		local job = GetPlayerJob(v)
		local grade = GetPlayerJobGrade(v)
		local paycheck = tonumber(Jobs[job].grades[tonumber(grade)].paycheck)
		if paycheck > 0 then
			AddPlayerBank(v, paycheck)
			CallRemoteEvent(v, "KNotify:Send", "Recieved paycheck [$" .. paycheck .. "]", "#e69c09")
		end
	end
end



function SteamAuthenticated(player)
	CallRemoteEvent(player, "Kuzkay:SteamReady")
end
AddEvent("OnPlayerSteamAuth", SteamAuthenticated)

function OnRoleSelect(player, role, location)
	loaded[player] = false
	if role == "criminal" then
		CreatePlayerData(player)
		
		SetPlayerPropertyValue(player, "playerName", GetPlayerName(player), true)
		print(GetPlayerPropertyValue(player, "playerName") .. " loaded in as a " .. role)

		PlayerData[player].role = role
		PlayerData[player].load_location = location
		local query = mariadb_prepare(sql, "SELECT `id` FROM `profiles` WHERE `steamid` = '?' AND `role` = '?' LIMIT 1;",
			tostring(GetPlayerSteamId(player)),
			PlayerData[player].role)

			mariadb_query(sql, query, GetPlayerProfile, player, location)

			SetPlayerSpawnLocation(player, Config.criminal.x, Config.criminal.y, Config.criminal.z + 200, Config.criminal.h)
	end
end
AddRemoteEvent("Kuzkay:OnRoleSelect", OnRoleSelect)

function GetPlayerProfile(player, location)
	
	if (mariadb_get_row_count() == 0) then
		CreateProfile(player)
	else
		Delay(500,LoadProfile,player)
	end
end


function LoadProfile(player)
	local query = mariadb_prepare(sql, "SELECT * FROM profiles WHERE steamid = '?' AND `role` = '?' LIMIT 1;", 
		tostring(GetPlayerSteamId(player)),
		PlayerData[player].role
		)

		mariadb_query(sql, query, OnProfileLoaded, player)
end

function OnProfileLoaded(player)

	local result = mariadb_get_assoc(1)
	
	local location = PlayerData[player].load_location

	PlayerData[player].money 		= result['money']
	PlayerData[player].bank 		= result['bank']
	PlayerData[player].level		= result['level']
	PlayerData[player].experience	= result['experience']

	PlayerData[player].dead			= result['dead']
	PlayerData[player].donator		= result['donator']

	

	if Jobs[result['job']] ~= nil then
		PlayerData[player].job					= result['job']
		PlayerData[player].job_grade			= result['job_grade']
		PlayerData[player].job_title 			= Jobs[result['job']].title
		PlayerData[player].job_grade_title 		= Jobs[result['job']].grades[tonumber(result['job_grade'])].grade_title

		CallEvent("OnJobChange", player, PlayerData[player].job, PlayerData[player].job_grade)
		CallRemoteEvent(player, "OnJobChange", PlayerData[player].job, PlayerData[player].job_grade)
		
	else
		PlayerData[player].job					= "unemployed"
		PlayerData[player].job_grade			= 1
		PlayerData[player].job_title 			= Jobs['unemployed'].title
		PlayerData[player].job_grade_title 		= Jobs['unemployed'].grades[1].grade_title
	end

	if location == "last_location" then
		PlayerData[player].position 	= result['position']
	else
		PlayerData[player].position 	= locations[tonumber(location)]
	end
	ApplyData(player)
end

function ApplyData(player)
	
		
	local position = PlayerData[player].position
	local x, y, z, h = position:match("([^,]+),([^,]+),([^,]+),([^,]+)")
	CallEvent("SafeTeleport", player, x, y, z + 200)
	SetPlayerHeading(player, h)
	SetPlayerPropertyValue(player, 'job', PlayerData[player].job, true)

	CallEvent("Kuzkay:RoleSelected", player, PlayerData[player].role)

	loaded[player] = true
	Delay(8000, function ()
		CallRemoteEvent(player, "Kuzkay:UpdateVisualData", PlayerData[player].money, PlayerData[player].bank, (PlayerData[player].job_title .. " - " .. PlayerData[player].job_grade_title), PlayerData[player].level, PlayerData[player].experience)
		SetPlayerPropertyValue(player, 'loaded', true, true)
		CallRemoteEvent(player, 'Kuzkay:LoadingComplete')
		CallEvent("Kuzkay:LoadingComplete", player)
		if tonumber(PlayerData[player].dead) == 1 then
			CallEvent("Kuzkay:RejoinDeath", player)
		end
		if tonumber(PlayerData[player].donator) >= 1 then
			CallRemoteEvent(player, "Kuzkay:EnableVIPAnimations")
		end
	end)


end

function CreateProfile(player)

	local job = "unemployed"

	local savePosition = Config.criminal.x .. ',' .. Config.criminal.y .. ',' .. Config.criminal.z .. ',' .. Config.criminal.h
	if PlayerData[player].role == 'police' then
		job = "police"
		savePosition = Config.police.x .. ',' .. Config.police.y .. ',' .. Config.police.z .. ',' .. Config.police.h
	end

	

	local fullName = GetPlayerName(player)
   	local name = fullName:gsub( "%W", "" )
	print("creating")
	local query = mariadb_prepare(sql, "INSERT INTO `profiles` (`steamid`, `name`, `money`, `bank`, `level`, `experience`, `position`, `inventory`, `role`, `job`, `donator`) VALUES ('?', '?', '?', '?', '?', '?', '?', '?', '?', '?', '?');",
		tostring(GetPlayerSteamId(player)),
		fullName,
		Config.StartMoney,
		Config.StartBank,
		1,
		0,
		savePosition,
		"[]",
		PlayerData[player].role,
		job,
		0
		)
		mariadb_query(sql, query, OnProfileCreated, player)
		
end
function OnProfileCreated(player)
	LoadProfile(player)
end



function SaveAllData()
	for _, player in ipairs(GetAllPlayers()) do
		if loaded[player] then
			SavePlayerData(player)
			Delay(5000, SavePlayerInventory, player)
		end
	end
end

function SavePlayerData(player)
	if loaded[player] then
		local x,y,z = GetPlayerLocation(player)
		local h = GetPlayerHeading(player)

		local position = x .. ',' .. y .. ',' .. z .. ',' .. h
		
		
		
		local query = mariadb_prepare(sql, "UPDATE `profiles` SET `money` = '?', `bank` = '?' , `position` = '?', `level` = '?', `experience` = '?', `job` = '?', `job_grade` = '?' WHERE `steamid` = '?' and `role` = '?';",
			math.floor(PlayerData[player].money),
			math.floor(PlayerData[player].bank),
			position,
			PlayerData[player].level,
			PlayerData[player].experience,
			PlayerData[player].job,
			PlayerData[player].job_grade,

			tostring(GetPlayerSteamId(player)),
			PlayerData[player].role)
			
			mariadb_query(sql, query, OnSavePlayerData, player)
			
	end
end
function OnSavePlayerData(player)
	CallRemoteEvent(player, "Kuzkay:UpdateVisualData", PlayerData[player].money, PlayerData[player].bank , (PlayerData[player].job_title .. " - " .. PlayerData[player].job_grade_title), PlayerData[player].level, PlayerData[player].experience)
end

function CreatePlayerData(player)
	PlayerData[player] = {}
	PlayerData[player].money 			= 0
	PlayerData[player].bank				= 0
	PlayerData[player].level			= 1
	PlayerData[player].experience		= 0
	PlayerData[player].position 		= ''
	PlayerData[player].role				= ''
	PlayerData[player].job 				= ''
	PlayerData[player].job_grade		= 0
	PlayerData[player].job_title 		= ''
	PlayerData[player].job_grade_title 	= ''
	PlayerData[player].dead 			= 0
	PlayerData[player].donator 			= 0
end


function OnPlayerQuit(player)
	SavePlayerData(player)
	Delay(50, function()
		PlayerData[player] = nil
		loaded[player] = false
	end)
end
AddEvent("OnPlayerQuit", OnPlayerQuit)
