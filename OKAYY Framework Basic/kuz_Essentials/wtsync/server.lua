local timer = 0
local weatherTimer = 0
local time = 9

local weather = 1

local weathers = {
	1,2,3,7
}

local passTime = 0.00333333333

function OnPackageStart()

	Delay(2500, function()
		local query = mariadb_prepare(sql, "SELECT * FROM `server_info` WHERE `data` = 'time';")
		mariadb_query(sql, query, LoadTime)
	end)
end
AddEvent("OnPackageStart", OnPackageStart)

function LoadTime()
	local result = mariadb_get_assoc(1)
	time = tonumber(result.value)

	print("Loaded time: " .. tonumber(result.value))
	AddTime()
	timer = CreateTimer(AddTime, 60000)
	weatherTimer = CreateTimer(AddWeather, 1200000)
end

function SetTime(setTo)
	time = setTo
	AddTime()
end
AddEvent("SetTime", SetTime)

function SetWeather(setTo)
	weather = setTo
	AddTime()
end
AddEvent("SetWeather", SetWeather)

function AddWeather()
		weather = weathers[math.random(1,#weathers)]
		SyncTime()
end

function AddTime()
	time = time + (passTime * 60)

	if time >= 24 then
		time = 0
	end
	
	
	SyncTime()
	SaveTime()
end

function SyncTime()
	for _, v in pairs(GetAllPlayers()) do
		CallRemoteEvent(v, "Kuzkay:SyncTime", time,weather)
	end
end
AddEvent("OnPlayerJoin", SyncTime)

function SaveTime()
	local query = mariadb_prepare(sql, "UPDATE `server_info` SET `value` = '?' WHERE `data` = 'time';",
	time)

	mariadb_query(sql, query, OnTimeSaved)
end
function OnTimeSaved()
	
end