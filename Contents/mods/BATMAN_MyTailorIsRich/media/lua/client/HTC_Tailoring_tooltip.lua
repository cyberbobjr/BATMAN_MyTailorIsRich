require("sizeLabels")
-- File: Combined_Tooltip.lua

-- Déclarations de localisation et de couleur pour différents types de tissu
local LOC_KEY = {
    Cotton = "IGUI_SM_Cotton",
    Denim = "IGUI_SM_Denim",
    Leather = "IGUI_SM_Leather",
    Kevlar = "IGUI_SM_Kevlar",
    zReRubberizedFabrics = "IGUI_SM_zReRubberizedFabrics",
}

local TYPE_COLOR = {
    Cotton = { .7, .7, .7 },
    Denim = { .4, .7, 1 },
    Leather = { 1, .6, .2 },
    Kevlar = { 1, .7, 0 },
    zReRubberizedFabrics = { 1, .7, 0 },
    RED_UNKNOWN = { 1, .4, .4 }, -- Si un nouveau type de tissu est ajouté
}

-- Variables de cache pour optimiser le rendu
local cache_render_item = nil
local cache_render_material_text = nil
local cache_render_size_text = nil
local cache_render_type = nil

-- Fonctions auxiliaires de HTC_Tooltip.lua
local function getSizeItem(item)
    local data = item:getModData()
    return data.sz
end

local MEMORY = {} -- indexed
local MEMORY_ASS = {}
local CSIZE = STAR_MODS.SizeLabels.CSIZE
local CMSIZE = STAR_MODS.SizeLabels.CMSIZE

local function addMemory(item, size)
    local id = item:getID()
    if not MEMORY_ASS[id] then
        local data = { id = id, size = size }
        MEMORY_ASS[id] = data
        table.insert(MEMORY, data)
        if #MEMORY > 30 then
            data = table.remove(MEMORY, 1)
            MEMORY_ASS[data.id] = nil
        end
        return
    end
    for i = #MEMORY, -1, 1 do
        local data = MEMORY[i]
        if data.id == id then
            data.size = size
            if i == #MEMORY then
                return
            end
            table.remove(MEMORY, i)
            table.insert(MEMORY, data)
            return
        end
    end
end

local function getSizeInMemory(item)
    local id = item:getID()
    local data = MEMORY_ASS[id]
    return data and data.size
end

local function getMaterialText(item)
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
        cache_render_type = fabric
        if key then
            local trans = getText(key)
            if trans ~= key then
                -- la traduction existe
                localization = trans
            end
        end
        return getText("IGUI_SM_Fabric") .. localization
    end
    return nil
end

local function getSizeText(item)
    local itemSize = item and getSizeItem(item)
    local cache_render_text_size = nil
    if itemSize then
        local p = getPlayer()
        local skill = p:getPerkLevel(Perks.Tailoring)
        if itemSize < 10 then
            -- itemSize compris entre 1 et 8 ???
            cache_render_text_size = CSIZE[itemSize]
            if skill < 5 then
                addMemory(item, itemSize)
            end
        else
            local real_size = itemSize > 20 and itemSize - 20 or itemSize - 10
            local sz_mem = getSizeInMemory(item)
            local sz_char = getSizeChr(p)
            local space = nil
            if skill >= 5 or skill == 4 and sz_char == real_size then
                cache_render_text_size = CMSIZE[real_size]
                addMemory(item, real_size)
            elseif cache_item:isEquipped() then
                space = real_size - sz_char
                space = space >= 1 and 1 or (space <= -1 and -1 or 0)
            elseif sz_mem then
                if sz_mem < 10 then
                    cache_render_text_size = CMSIZE[sz_mem]
                else
                    space = sz_mem - 50
                end
            else
                space = real_size - sz_char
                space = space >= 5 - skill and 1 or (space <= -5 + skill and -1 or nil)
            end
            if space then
                addMemory(item, space + 50)
                if space == 1 then
                    cache_render_text_size = getText("IGUI_B_Spacious")
                elseif space == -1 then
                    cache_render_text_size = getText("IGUI_B_Tight")
                elseif space == 0 then
                    cache_render_text_size = getText("IGUI_B_Fit")
                end
            end
        end
        if not cache_render_text_size then
            cache_render_text_size = "??"
        end
    end
    return cache_render_text_size
end

local old_render = ISToolTipInv.render
function ISToolTipInv:render(...)
    -- Sewing Pattern Tooltip
    if self.item:getFullType() == "HTCTailoring.sewingpattern" then
        local sewingModData = self.item:getModData()["sewing"]
        if sewingModData then
            if old_render then
                old_render(self, ...) -- execute vanilla code
            end
            local allScriptItems = getScriptManager():getItemsByType(sewingModData["itemType"])
            local scriptItem = allScriptItems:get(0)
            if scriptItem then
                -- might  be nil if mod is added to an existing game and jar has been created before the mod was added
                local hght = self.tooltip:getHeight();
                local yPos = hght + 2;
                local font = UIFont.Small;
                local boxHght = (getTextManager():getFontHeight(UIFont.Small) * 2) + 5
                self:drawRect(0, self.height, self.width, boxHght, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
                self:drawRectBorder(0, self.height, self.width, boxHght, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
                local tooltip_text = scriptItem:getDisplayName()
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
                self:drawText(tooltip_text, 13, yPos, 1, 1, 0.8, 1, font);
                yPos = yPos + getTextManager():getFontHeight(UIFont.Small)
                self:drawText(type_tooltip_text, 13, yPos, TYPE_COLOR[itemFabricType][1], TYPE_COLOR[itemFabricType][2], TYPE_COLOR[itemFabricType][3], 1, font);
            end
        end
        return
    end

    -- Fabric and Size Tooltip
    local final_tooltip_text = nil
    if self.item ~= cache_render_item then
        cache_render_item = self.item
        cache_render_material_text = nil
        cache_render_size_text = nil
        cache_render_type = nil
        -- Display MATERIAL
        if cache_render_item and cache_render_item.getFabricType then
            cache_render_material_text = getMaterialText(cache_render_item)
        end
        -- Display SIZE
        if cache_render_item then
            cache_render_size_text = getSizeText(cache_render_item)
        end
    end

    if cache_render_material_text then
        final_tooltip_text = cache_render_material_text
    end
    if cache_render_size_text then
        final_tooltip_text = final_tooltip_text .. " / " .. getText("IGUI_SM_Size") .. cache_render_size_text
    end
    if not final_tooltip_text then
        return old_render(self)
    end
    -- Ninja double injection dans l'injection
    local stage = 1
    local save_th = 0
    local old_setHeight = self.setHeight
    self.setHeight = function(self, num, ...)
        if stage == 1 then
            stage = 2
            save_th = num
            num = num + 18
        else
            stage = -1 -- erreur
        end
        return old_setHeight(self, num, ...)
    end
    local old_drawRectBorder = self.drawRectBorder
    self.drawRectBorder = function(self, ...)
        if stage == 2 then
            local font = UIFont[getCore():getOptionTooltipFont()]
            local color = TYPE_COLOR[cache_render_type] or TYPE_COLOR.RED_UNKNOWN;
            self.tooltip:DrawText(font, final_tooltip_text, 5, save_th - 5, color[1], color[2], color[3], 1)
            stage = 3
        else
            stage = -1 -- erreur
        end
        return old_drawRectBorder(self, ...)
    end
    old_render(self)
    self.setHeight = old_setHeight
    self.drawRectBorder = old_drawRectBorder
end
