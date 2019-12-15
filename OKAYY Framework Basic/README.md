# OKAYY Framework (Basic)
This framework is the most basic version which is available for free to download and create scripts for.
This version contains:
* Inventory system
* Vehicle trunk system
* Storage system
* Basic Banking
* Shops
* Very basic anti-cheat
* Couple usable items
* Car speedometer
* Teleport players that fell underground
* Time + Weather sync


# Basics

## Import OKAYY Framework to your own package
Good example of using the kuz_Essentials in an external package is the kuz_Usable package

```lua
	local kes = ImportPackage('kuz_Essentials')
```

# Profile functions

## kes.savePlayer(player)
This function allows you to force save players position, inventory and balance


## kes.getPlayerData(player)
This function returns the player's PlayerData table

## kes.getPlayerRole(player)
This function gets players role (only role in this version is 'criminal' This has no meaning but can be used to setup multiple characters and player saves, just ignore it if you don't understand)

## kes.setPlayerJob(player, job, grade)
This function sets players job.

## kes.getPlayerJob(player)
This function returns players job

## kes.getPlayerJobGrade(player)
This function returns players job grade

## kes.getMoney(player)
This function returns player CASH balance

## kes.addMoney(player, amount)
This function adds onto players CASH balance

## kes.removeMoney(player, amount)
This function removes from player CASH balance

## kes.getBank(player)
This functions returns player BANK balance

## kes.addBank(player, amount)
This function adds onto players BANK balance

## kes.removeBank(player, amount)
This function removes from player BANK balance

## kes.getLevel(player)
This function returns players level

## kes.addLevel(player, amount)
This function add levels to player

## kes.removeLevel(player, amount)
This function lowers players level

## kes.getExperience(player)
This function returns players XP

## kes.addExperience(player, amount)
This function adds XP to the player

## kes.removeExperience(player, amount)
This function removes XP from the player




# Inventory functions


## kes.addItem(player, item, amount)
Adds an item to players inventory, returns true on success and false on failure

## kes.removeItem(player, item, amount)
Removes an item from players inventory, returns true on success and false on failure

## kes.clearPlayerInventory(player)
This function removes all players items

## kes.getItemCount(player, item)
This function gets the amount of item that player has

## kes.getItemNames(item)
This function returns the single and plural item names



# Usable items

When player right clicks and item and presses "Use" the SERVER sided event "Kuzkay:UseItem:{item name}" gets called
for example `Kuzkay:UseItem:bandage` gets called when player uses the item, The first parameter of this event is the player and second parameter is the item(could be used to call same function from different items)

Good example of this can be found in package `kuz_Usable`
