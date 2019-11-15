# Kuz_UI
Use CallRemoteEvent when from the server


#Callable Events:

## Create new menu:
```
'KUI:Create' (id, name)
```
* id - id which you will use to recieve events from the menu<br/>
* name - Title which you want to be shown on top of the menu<br/>

![image](https://i.imgur.com/XmDLn7r.png)

## Add option to your menu:
```
'KUI:AddOption' (id, title, description, button_text)
```
* id - id which you will recieve once player presses the button on this option<br/>
* title - title which will be the big text on the option<br/>
* description - small text which shows on the option<br/>
* button_text - text which will appear on the buttons for the option<br/>

## Show the menu (do this after creating it and adding options)
```
'KUI:Show' (id, bool)
```

* id - id of the menu you wish to show/hide<br/>
* bool - true = show the menu, false = hide the menu<br/>



#Recieving events:

## On option click:
```
'KUI:OptionClick_' + your menu_id  (menu_id, option_id)
```
* menu_id - id of the menu which was defined in KUI:Create<br/>
* option_id - id which of the option which was defined in KUI:AddOption<br/>

## On menu close:
```
'KUI:Closed_' + your menu_id  (menu_id)
```
* menu_id - id of the menu which was defined in KUI:Create<br/>



#Example: 

```lua
function OpenJobCenter(player)
	
	--Start by creating a new menu with "job_selection" as the id
	CallRemoteEvent(player, "KUI:Create", "job_selection", "JOB CENTER")
	
	--in this case we loop through all jobs and add option for each job and use jobs[i].job_name for the option title and i as the option id
	local i = 1
	for _ in pairs(jobs) do
		CallRemoteEvent(player, "KUI:AddOption", i, jobs[i].job_name, 'job description goes here', "Select")
		i = i + 1
	end
	--After we added all the options we show the menu
	CallRemoteEvent(player, "KUI:Show", "job_selection", true)
end
AddCommand('job', OpenJobCenter)

--player = player that clicked the option, selection = id of the option which has been pressed
function JobSelected(player, selection)
	kes.setPlayerJob(player, jobs[tonumber(selection)].job, 1)
end
--This event gets called when player click on any option in the "job_selection" menu
AddRemoteEvent("KUI:OptionClick_job_selection", JobSelected)
```

