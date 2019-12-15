AddEvent("OnObjectNetworkUpdatePropertyValue", function(object, property, texture)
	if property == "texture" then
		if IsObjectValid(object) then
			SetObjectTexture(object, texture, 0)
		end
	end
end)

AddEvent("OnObjectStreamIn", function(object)
	local color = GetObjectPropertyValue(object, "color")
	if color~= nil and color ~= "" then
			if GetObjectPropertyValue(object, "color_slot") == nil then
				SetObjectColor(object, color, 0)
			else
				SetObjectColor(object, color, GetObjectPropertyValue(object, "color_slot"))
			end
	end
	local texture = GetObjectPropertyValue(object, "texture")

	if texture ~= nil and texture ~= "" then
		SetObjectTexture(object, texture, 0)
	end

	local tint = GetObjectPropertyValue(object, "tint")
	if tint ~= nil and tint ~= "" then
		SetObjectTint(object, GetObjectPropertyValue(object, "tint"), GetObjectPropertyValue(object, "tint_slot"))
	end
end)







AddEvent("OnPickupNetworkUpdatePropertyValue", function(pickup, property, color)
	if property == "color" then
		SetPickupColor(pickup, color)
	end
end)

AddEvent("OnPickupStreamIn", function(pickup)
	local color = GetPickupPropertyValue(pickup, "color")
	if color ~= nil and color ~= "" then
		SetPickupColor(pickup, color)
	end
end)

function SetObjectTint(object, HexColor, slot)
	local Mesh = GetObjectStaticMeshComponent(object)
	local Material = Mesh:CreateDynamicMaterialInstance(slot)
	local color = "0x" .. HexColor
	local r, g, b, a = HexToRGBAFloat(color)

	local power = 0.3
	if GetObjectPropertyValue(object, "tint_power") ~= nil then
		power = GetObjectPropertyValue(object, "tint_power")
	end
	if Material ~= nil then
		Material:SetColorParameter("Diffuse color", FLinearColor(r, g, b, power))
		Material:SetColorParameter("MW_TextureBaseColor", FLinearColor(r, g, b, power))
		Material:SetColorParameter("BaseColor", FLinearColor(r, g, b, power))
		Material:SetColorParameter("EmissiveColor", FLinearColor(r, g, b, power))
	end
end

function SetPickupColor(pickup, HexColor)
	local color = "0x" .. HexColor
    local StaticMeshComponent = GetPickupStaticMeshComponent(pickup)
    StaticMeshComponent:SetMaterial(0, UMaterialInterface.LoadFromAsset("/Game/Scripting/Materials/MI_TranslucentLit"))
    local MaterialInstance = StaticMeshComponent:CreateDynamicMaterialInstance(0)
    local r, g, b, a = HexToRGBAFloat(color)
    MaterialInstance:SetColorParameter("BaseColor", FLinearColor(r, g, b, 0.4))
end


AddEvent("OnNPCNetworkUpdatePropertyValue", function(npc, property, model)
	if property == "model" then
		SetNPCClothingPreset(npc, tonumber(model))
	end
end)

AddEvent("OnNPCStreamIn", function(npc)

	local model = GetNPCPropertyValue(npc, "model")
	if model ~= nil and model ~= "" then
		SetNPCClothingPreset(npc, tonumber(model))
	end
end)




AddRemoteEvent("CopyToClipboard", function(message)
	CopyToClipboard(message)
end)







AddRemoteEvent("unfreeze", function()
	SetIgnoreMoveInput(false)
end)

AddRemoteEvent("keepfrozen", function()
	SetIgnoreMoveInput(true)
end)


function OnScriptError(message)
	if IsGameDevMode() then
		--AddPlayerChat('<span color="#ff0000bb" style="bold" size="10">'..message..'</>')
	end
end
AddEvent("OnScriptError", OnScriptError)


function GetClientInfo()
	AddPlayerChat("Timers: " .. GetTimerCount() .. " | Web UIs: " .. GetWebUICount())
end
AddRemoteEvent("Kuzkay:GetClientInfo", GetClientInfo)

