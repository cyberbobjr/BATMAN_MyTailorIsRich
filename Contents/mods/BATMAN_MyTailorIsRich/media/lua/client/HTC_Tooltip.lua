----------Clothes tooltips---------

local function getSizeItem(item)
    local data = item:getModData()
    return data.sz
end

do
    local MEMORY = {} --indexed
    local MEMORY_ASS = {}
    local CSIZE = STAR_MODS.SizeLabels.CSIZE
    local CMSIZE = { "(XXS)", "(XS)", "(S)", "(M)", "(L)", "(XL)", "(XXL)", "(XXXL)" }

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

    local COLOR_WHITE = { 1, 1, 1 }

    local cache_item = nil
    local cache_render_text = nil

    local vanilla_render = ISToolTipInv.render

    function ISToolTipInv:render()
        if self.item ~= cache_item then
            cache_item = self.item
            cache_render_text = nil
            local size = cache_item and getSizeItem(cache_item)
            if size then
                -- Display SIZE
                local p = getPlayer()
                local skill = p:getPerkLevel(Perks.Tailoring)
                if size < 10 then
                    cache_render_text = CSIZE[size]
                    if skill < 5 then
                        addMemory(cache_item, size)
                    end
                else
                    local real_size = size > 20 and size - 20 or size - 10
                    local sz_mem = getSizeInMemory(cache_item)
                    local sz_char = getSizeChr(p)
                    local space = nil
                    if skill >= 5 or skill == 4 and sz_char == real_size then
                        cache_render_text = CMSIZE[real_size]
                        addMemory(cache_item, real_size)
                    elseif cache_item:isEquipped() then
                        space = real_size - sz_char
                        space = space >= 1 and 1 or (space <= -1 and -1 or 0)
                    elseif sz_mem then
                        --print(sz_mem)
                        if sz_mem < 10 then
                            cache_render_text = CMSIZE[sz_mem]
                        else
                            space = sz_mem - 50
                        end
                    else
                        space = real_size - sz_char
                        space = space >= 5 - skill and 1 or (space <= -5 + skill and -1 or nil)
                    end
                    if space then
                        addMemory(cache_item, space + 50)
                        if space == 1 then
                            cache_render_text = getText("IGUI_B_Spacious")
                        elseif space == -1 then
                            cache_render_text = getText("IGUI_B_Tight")
                        elseif space == 0 then
                            cache_render_text = getText("IGUI_B_Fit")
                        end
                    end
                end
                if not cache_render_text then
                    cache_render_text = "??"
                end
            end
        end
        if not cache_render_text then
            return vanilla_render(self)
        end
        -- Ninja double injection in injection!
        local stage = 1
        local save_th = 0
        local old_setHeight = self.setHeight
        self.setHeight = function(self, num, ...)
            if stage == 1 then
                stage = 2
                save_th = num
                num = num + 18
            else
                stage = -1 --error
            end
            return old_setHeight(self, num, ...)
        end
        local old_drawRectBorder = self.drawRectBorder
        self.drawRectBorder = function(self, ...)
            if stage == 2 then
                local col = COLOR_WHITE; -- {r,g,b}
                local font = UIFont[getCore():getOptionTooltipFont()];
                self.tooltip:DrawText(font, cache_render_text, 5, save_th - 5, col[1], col[2], col[3], 1);
                stage = 3
            else
                stage = -1 --error
            end
            return old_drawRectBorder(self, ...)
        end
        vanilla_render(self)
        self.setHeight = old_setHeight
        self.drawRectBorder = old_drawRectBorder
    end

end
