require("ItemTooltipAPI/Main")

local ItemTooltipAPI = CommunityAPI.Client.ItemTooltip
local TYPE_COLOR = {
    Cotton = { .7, .7, .7 },
    Denim = { .4, .7, 1 },
    Leather = { 1, .6, .2 },
    Kevlar = { 1, .7, 0 },
    zReRubberizedFabrics = { 1, .7, 0 },
    RED_UNKNOWN = { 1, .4, .4 }, -- Si un nouveau type de tissu est ajouté
}

---@type InventoryTooltipInstance
local ItemTooltip = ItemTooltipAPI.CreateToolTipByFullType("HTCTailoring.sewingpattern")

local function getSewingPatternLabel(result, item)
    local sewingModData = item:getModData()["sewing"] -- Use the InventoryItem to check data
    if sewingModData then
        local allScriptItems = getScriptManager():getItemsByType(sewingModData["itemType"])
        local scriptItem = allScriptItems:get(0)
        if scriptItem then
            local itemFabricAmount = sewingModData["itemFabricAmount"]
            local itemFabricType = sewingModData["itemFabricType"]
            local threadAmount = sewingModData["threadAmount"]
            local type_tooltip_text = ""
            if itemFabricType and itemFabricAmount then
                type_tooltip_text = type_tooltip_text .. itemFabricAmount .. " " .. getText("IGUI_SM_" .. HTC_MTIR_ContextMenu.MATERIAL_KEY[itemFabricType])
            end
            if threadAmount then
                type_tooltip_text = type_tooltip_text .. " / " .. threadAmount .. " " .. getText("IGUI_SM_Thread") .. "(s)"
            end
            result.value = type_tooltip_text -- Set the value
            result.labelColor = { r = TYPE_COLOR[itemFabricType][1], g = TYPE_COLOR[itemFabricType][2], b = TYPE_COLOR[itemFabricType][3], a = 1.0 } -- Set the label color
        end
    end
end

ItemTooltip:addLabel(getSewingPatternLabel)