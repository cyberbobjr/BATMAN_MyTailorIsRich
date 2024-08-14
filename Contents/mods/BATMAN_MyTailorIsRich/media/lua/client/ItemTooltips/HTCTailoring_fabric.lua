require("ItemTooltipAPI/Main")

local ItemTooltipAPI = CommunityAPI.Client.ItemTooltip
local LOC_KEY = {
    Cotton = "IGUI_SM_Cotton",
    Denim = "IGUI_SM_Denim",
    Leather = "IGUI_SM_Leather",
    Kevlar = "IGUI_SM_Kevlar",
    zReRubberizedFabrics = "IGUI_SM_zReRubberizedFabrics",
}
local TYPE_COLOR = {
    Cotton = { r = .7, g = .7, b = .7, a = 1 },
    Denim = { r = .4, g = .7, b = 1, a = 1 },
    Leather = { r = 1, g = .6, b = .2, a = 1 },
    Kevlar = { r = 1, g = .7, b = 0, a = 1 },
    zReRubberizedFabrics = { r = 1, g = .7, b = 0, a = 1 },
    RED_UNKNOWN = { r = 1, g = .4, b = .4, a = 1 }, -- Si un nouveau type de tissu est ajouté
}

local function getMaterialText(result, item)
    local fabric = item:getFabricType()
    if item:getTags():contains("zReRepairableVest") then
        fabric = "Kevlar"
    end
    if item:getTags():contains("zReRepairableChemsuit") then
        fabric = "zReRubberizedFabrics"
    end
    if fabric then
        local localization = fabric
        local key = LOC_KEY[fabric]
        if key then
            local trans = getText(key)
            if trans ~= key then
                -- la traduction existe
                localization = trans
            end
        end
        result.value = localization
        result.color = TYPE_COLOR[fabric]
        result.labelColor = TYPE_COLOR[fabric]
    end
end

local function predicateItem(item)
    if item.getFabricType then
        local fabric = item:getFabricType()
        if item:getTags():contains("zReRepairableVest") then
            fabric = "Kevlar"
        end
        if item:getTags():contains("zReRepairableChemsuit") then
            fabric = "zReRubberizedFabrics"
        end
        return fabric ~= nil
    end
    return false
end

local ItemTooltipPredicate = ItemTooltipAPI.CreateToolTipByPredicate("fabricType", predicateItem)
ItemTooltipPredicate:addField(getText("IGUI_SM_Fabric"), getMaterialText) -- Fixed field value
