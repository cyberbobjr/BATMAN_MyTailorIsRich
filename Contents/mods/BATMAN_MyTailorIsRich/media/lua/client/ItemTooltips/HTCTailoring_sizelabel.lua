require("ItemTooltipAPI/Main")

local ItemTooltipAPI = CommunityAPI.Client.ItemTooltip
local CSIZE = { "XXS", "XS", "S", "M", "L", "XL", "XXL", "XXXL" }
local CMSIZE = { "(XXS)", "(XS)", "(S)", "(M)", "(L)", "(XL)", "(XXL)", "(XXXL)" }

local MEMORY = {} -- indexed
local MEMORY_ASS = {}

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

local function getSizeItem(item)
    local data = item:getModData()
    return data.sz
end

local function getSizeText(result, item)
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
            local sz_char = STAR_MODS.SizeLabels.getSizeChr(p)
            local space = nil
            if skill >= 5 or skill == 4 and sz_char == real_size then
                cache_render_text_size = CMSIZE[real_size]
                addMemory(item, real_size)
            elseif item:isEquipped() then
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
    result.value = cache_render_text_size
end

local function predicateItem(item)
    return item and getSizeItem(item)
end

local ItemTooltipPredicate = ItemTooltipAPI.CreateToolTipByPredicate("sizeLabel", predicateItem)
ItemTooltipPredicate:addField(getText("IGUI_SM_Size"), getSizeText) -- Fixed field value
