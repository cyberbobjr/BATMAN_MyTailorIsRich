STAR_MODS = STAR_MODS or {}
STAR_MODS.SizeLabels = STAR_MODS.SizeLabels or {}

--Fixed for female (65 is normal)
local function getFemaleWeight(w)
    if w < 50 then
        w = 50 - (50 - w) * 0.333334
    end
    w = w - 15
    return w
end
STAR_MODS.SizeLabels.getFemaleWeight = getFemaleWeight

local function getWeightFixed(player)
    local weight = player:getNutrition():getWeight()
    if player:isFemale() then
        return getFemaleWeight(weight)
    end
    return weight
end
STAR_MODS.SizeLabels.getWeightFixed = getWeightFixed

-- Simple Status mod compatibility
if SimpleStatus and SimpleStatus.valueFn and SimpleStatus.colorFn then
    local valueFn = SimpleStatus.valueFn
    local old_valueFn = valueFn.weight
    local new_valueFn = function(p)
        return round(getWeightFixed(p), 1)
    end
    valueFn.weight = new_valueFn

    local old_colorFn = SimpleStatus.colorFn.weight
    SimpleStatus.colorFn.weight = function(...)
        valueFn.weight = old_valueFn
        local col = old_colorFn(...)
        valueFn.weight = new_valueFn
        return col
    end

    local ss_barConfigs = SimpleStatus.ss_barConfigs
    if ss_barConfigs then
        local weight = ss_barConfigs.weight or ss_barConfigs[13]
        if weight and weight.name == 'weight' then
            weight.colorFn = SimpleStatus.colorFn.weight --rewrite fn cos it has been changed
        end
    end
end

-- Weight Scale Compatibility
if WeightScale and WeightScale.WindowUI then
    local old_fn = nil
    local old_update = WeightScale.WindowUI.update
    function WeightScale.WindowUI:update()
        if not (self.playerObj and self.playerObj:isFemale() and self.nutritionObj and old_fn == nil) then
            return old_update(self)
        end
        local m = getmetatable(self.nutritionObj).__index
        old_fn = m.getWeight
        m.getWeight = function(...)
            return getFemaleWeight(old_fn(...))
        end
        old_update(self)
        m.getWeight = old_fn
        old_fn = nil
    end
end

local CSIZE = { "XXS", "XS", "S", "M", "L", "XL", "XXL", "XXXL" }
STAR_MODS.SizeLabels.CSIZE = CSIZE
local CMSIZE = { "(XXS)", "(XS)", "(S)", "(M)", "(L)", "(XL)", "(XXL)", "(XXXL)" }
STAR_MODS.SizeLabels.CMSIZE = CMSIZE
local CHANCE = { 40, 140, 220, 330, 170, 50, 30, 20 }
do
    local sum = 0
    for i, v in ipairs(CHANCE) do
        sum = sum + v
        CHANCE[i] = sum
    end
end
local function getRandomCSize()
    local r = ZombRand(1000) --0...999
    for i = 7, 1, -1 do
        if r >= CHANCE[i] then
            return i + 1
        end
    end
    return 1
end
STAR_MODS.SizeLabels.getRandomCSize = getRandomCSize

local CHANCES = {
    ON_WEAR_VERY_TIGHT = 15,
    ON_WEAR_TIGHT = 5,
    BREAKFAST_MULT = 3,

    BREAK_TIGHT = 0.025,
    BREAK_VERY_TIGHT = 0.05,

    DROP_SPACY = 0.03,
    DROP_VERY_SPACY = 0.1,
    DROP_VERYVERY_SPACY = 0.15,
}

--spacy = тянется, breakfast = хлипкая, nofit = допускается только разница 1,
--drop = падает при действиях, nobreak = не рвется вообще
GLOBAL_CLOTHES_SLOTS = {
    BathRobe = { spacy = true },
    Dress = { breakfast = true },
    FullSuit = {},
    Jacket = {},
    JacketHat = {},
    Legs1 = { nofit = true, spacy = true, low = true },
    Pants = { drop = true, low = true },
    Shirt = { breakfast = true },
    Skirt = { breakfast = true, drop = true, low = true },
    Sweater = { spacy = true },
    SweaterHat = { spacy = true },
    TankTop = { nofit = true, breakfast = true },
    Torso1Legs1 = { nofit = true },
    Tshirt = { nofit = true, breakfast = true },
    Underwear = { nofit = true, nobreak = true, low = true },
    ShortSleeveShirt = { breakfast = true },
}
local SLOTS = GLOBAL_CLOTHES_SLOTS

local function getSizeMale(weight)
    if weight > 120 then
        return 8
    elseif weight > 105 then
        return 7
    elseif weight > 91 then
        return 6
    elseif weight > 76 then
        return 5
    elseif weight > 63 then
        return 4
    elseif weight > 55 then
        return 3
    elseif weight > 46 then
        return 2
    end
    return 1
end
local function getSizeFemale(weight)
    if weight > 105 then
        return 8
    elseif weight > 95 then
        return 7
    elseif weight > 79 then
        return 6
    elseif weight > 67 then
        return 5
    elseif weight > 60 then
        return 4
    elseif weight > 49 then
        return 3
    elseif weight > 44 then
        return 2
    end
    return 1
end

local function getSizeChr(chr)
    local weight = getWeightFixed(chr)
    return chr:isFemale() and getSizeFemale(weight) or getSizeMale(weight)
end
STAR_MODS.SizeLabels.getSizeChr = getSizeChr

--CSize Player Panel
do
    local IGUI_char_Sex = getText("IGUI_char_Sex")
    local IGUI_char_Weight = getText("IGUI_char_Weight")
    local TM = getTextManager()

    local old_drawTextRight, old_drawText, old_drawTexture, is_found_weight, is_found_icon
    --local smallFontHgt

    function ISCharacterScreen:drawCSize(x, y, font)
        local sz = getSizeChr(self.char)
        old_drawText(self, CMSIZE[sz], x + 2, y, 1, 1, 1, 1, font or UIFont.Small);
        if STAR_MODS.NutritionIndicator then
            STAR_MODS.NutritionIndicator.sizeLabelsOffset = x + 2 + TM:MeasureStringX(font or UIFont.Small, CMSIZE[sz]);
        end
    end

    local function new_drawTextRight(self, val, x, y, ...)
        if val == IGUI_char_Weight then
            is_found_weight = true
            local nut = self.char:getNutrition()
            if nut:isIncWeight() or nut:isIncWeightLot() or nut:isDecWeight() then
                --after icon
                is_found_icon = true
            end
        end
        return old_drawTextRight(self, val, x, y, ...)
    end

    local weightStr, saved_x, saved_y, saved_font, weightWid
    local function new_drawText(self, s, x, y, a, b, c, d, font, ...)
        if is_found_weight then
            is_found_weight = false
            if self.char:isFemale() then
                local w = round(getWeightFixed(self.char), 0)
                s = tostring(w)
            end
            weightStr = s; --tostring(round(self.char:getNutrition():getWeight(), 0))
            weightWid = TM:MeasureStringX(UIFont.Small, weightStr);
            if is_found_icon then
                saved_x = x
                saved_y = y
                saved_font = font
            else
                self:drawCSize(x + weightWid, y, font);
            end
        end
        return old_drawText(self, s, x, y, a, b, c, d, font, ...)
    end

    local function new_drawTexture(self, ...)
        if is_found_icon and not is_found_weight then
            is_found_icon = false
            local nutritionWidth = weightWid + 13 + 2;
            self:drawCSize(saved_x + nutritionWidth, saved_y, saved_font);
        end
        return old_drawTexture(self, ...)
    end

    local in_progress = false
    local old_render = ISCharacterScreen.render
    function ISCharacterScreen:render()
        if in_progress then
            if old_drawText then
                if old_drawTextRight and self.drawTextRight == new_drawTextRight then
                    self.drawTextRight = old_drawTextRight
                end
                if old_drawText and self.drawText == new_drawText then
                    self.drawText = old_drawText
                end
                if old_drawTexture and self.drawTexture == new_drawTexture then
                    self.drawTexture = old_drawTexture
                end
                old_drawTextRight = nil
                old_drawText = nil
                old_drawTexture = nil
            end
            return old_render(self)
        end
        is_found_weight = false
        is_found_icon = false
        old_drawTextRight = self.drawTextRight
        old_drawText = self.drawText
        old_drawTexture = self.drawTexture
        self.drawTextRight = new_drawTextRight
        self.drawText = new_drawText
        self.drawTexture = new_drawTexture
        in_progress = true
        old_render(self)
        in_progress = false
        if old_drawText then
            self.drawTextRight = old_drawTextRight
            self.drawText = old_drawText
            self.drawTexture = old_drawTexture
        end
    end
end



----------Clothes tooltips---------

local TIME_INST
local lastRip = 0
--Рвёт одежду
local function RipClothes(item, player)
    local tm = TIME_INST:getWorldAgeHours()
    local diff = tm - lastRip
    if diff < 0.25 then
        --15 минут еще не прошло
        return --print('15 minutes!')
    end
    --Ищем дырку
    if not item:getCanHaveHoles() then
        return --print("cant make hole")
    end
    local coveredParts = BloodClothingType.getCoveredParts(item:getBloodClothingType())
    if not coveredParts then
        return --print('no parts')
    end
    local found = {}
    local vis = item:getVisual()
    for i = 1, coveredParts:size() do
        local part = coveredParts:get(i - 1)
        if vis:getHole(part) == 0 then
            table.insert(found, part)
        end
    end
    if #found == 0 then
        return --print('no parts without hole')
    end
    local part = found[ZombRand(#found) + 1]
    vis:setHole(part);
    -----> NEW HOLE 100% !!
    lastRip = tm
    --print('set hole!')
    local cond = item:getCondition() - (item:getCondLossPerHole() or 0)
    if cond < 0 then
        cond = 0
    end
    item:setCondition(cond)
    if player then
        player:getEmitter():playSound("ClothesRipping");
    end
    return true
end

local function DropItem(item, player)
    -- 1: kept, 0: dropped
    if item:isFavorite() then
        item:setFavorite(false)
    end
    local sq = player:getCurrentSquare()
    local dropX, dropY, dropZ = ISInventoryTransferAction.GetDropItemOffset(player, sq, item)
    local inv = player:getInventory()
    player:removeWornItem(item)
    triggerEvent("OnClothingUpdated", player) --see ISUnequipAction:68
    inv:Remove(item)
    sq:AddWorldInventoryItem(item, dropX, dropY, dropZ)
    player:getEmitter():playSound("stab1")
    return true
end



--Проверяет всю надетую одежду. Рвёт, если надо.
--Неинициалиированная одежда получает размер персонажа.
--TODO: оптимизировать
local function CheckAllClothes(player, mult)
    --print('CheckAllClothes!!!',mult)
    local size = getSizeChr(player)
    local list = player:getWornItems()
    local items = {} --узкая
    local is_belt = false
    for i = 0, list:size() - 1 do
        local item = list:getItemByIndex(i);
        local loc = item:getBodyLocation()
        if loc == "Belt" then
            is_belt = true
        end
        local data = SLOTS[loc]
        if data then
            local sz = item:getModData().sz
            if not sz then
                --worn!
                sz = size
                item:getModData().sz = sz
            end
            while sz > 10 do
                sz = sz - 10
            end
            if sz + (data.spacy and 1 or 0) < size then
                --tight
                table.insert(items, item)
            end
        end
    end
    mult = mult or 1
    while #items > 0 do
        local item = table.remove(items, ZombRand(#items) + 1)
        local data = SLOTS[item:getBodyLocation()]
        local sz = item:getModData().sz
        while sz > 10 do
            sz = sz - 10
        end
        local diff = size - (sz + (data.spacy and 1 or 0))
        local chance = diff == 1 and CHANCES.BREAK_TIGHT or CHANCES.BREAK_VERY_TIGHT
        chance = chance * mult
        if data.breakfast then
            chance = chance * CHANCES.BREAKFAST_MULT
        end
        if ZombRand(10000) < chance * 100 then
            print('Rip Clothes! Chance was: ', tostring(chance) .. '%')
            return RipClothes(item, player)
        end
    end
    if is_belt then
        return
    end
    local busy_hands = (player:getPrimaryHandItem() and 1 or 0) + (player:getSecondaryHandItem() and 1 or 0)
    if busy_hands < 2 then
        return
    end
    --Ремня точно нет. И руки заняты.
    items = {} --просторная
    for i = 0, list:size() - 1 do
        local item = list:getItemByIndex(i);
        local loc = item:getBodyLocation()
        local data = SLOTS[loc]
        if data and data.drop then
            local sz = item:getModData().sz
            while sz > 10 do
                sz = sz - 10
            end
            if sz > size then
                --spacy
                table.insert(items, item)
            end
        end
    end
    while #items > 0 do
        local item = table.remove(items, ZombRand(#items) + 1)
        local data = SLOTS[item:getBodyLocation()]
        local sz = item:getModData().sz
        while sz > 10 do
            sz = sz - 10
        end
        local diff = sz - size
        local chance = diff == 1 and CHANCES.DROP_SPACY or
                (diff == 2 and CHANCES.DROP_VERY_SPACY or CHANCES.DROP_VERYVERY_SPACY)
        chance = chance * mult
        if ZombRand(10000) < chance * 100 then
            print('Drop Clothes! Chance was: ', tostring(chance) .. '%')
            return DropItem(item, player)
        end
    end
end

local function setRightInsulation(item, diff)
    local ins = ScriptManager.instance:getItem(item:getFullType()):getInsulation()
    if not item:isEquipped() or diff == 0 then
        item:setInsulation(ins)
        return
    end
    if diff == 1 then
        ins = ins * 0.8
    elseif diff == 2 then
        ins = ins * 0.7
    elseif diff == 3 then
        ins = ins * 0.6
    else
        ins = ins * 0.5
    end
    item:setInsulation(ins) --until reload the game
end

local function CheckInsulation(player)
    local size = getSizeChr(player)
    local list = player:getWornItems()
    for i = 0, list:size() - 1 do
        local item = list:getItemByIndex(i);
        local data = SLOTS[item:getBodyLocation()]
        if data then
            local sz = item:getModData().sz
            if not sz then
                print("ERROR: no sz ", item:getType())
            else
                while sz > 10 do
                    sz = sz - 10
                end
                if sz >= size then
                    --free space, lower insulation
                    --print('free space',sz,size,item)
                    local diff = sz - size
                    setRightInsulation(item, diff)
                end
            end
        end
    end
end

--Player enters the world
Events.OnCreatePlayer.Add(function(id)
    local player = getSpecificPlayer(id)
    TIME_INST = GameTime:getInstance()
    lastRip = TIME_INST:getWorldAgeHours()
    CheckAllClothes(player)
    CheckInsulation(player)
end)

local STATES = {}
STATES[ClimbThroughWindowState.instance()] = true
STATES[ClimbOverFenceState.instance()] = true
STATES[ClimbOverWallState.instance()] = 1
STATES[ClimbSheetRopeState.instance()] = true
STATES[ClimbDownSheetRopeState.instance()] = true

local lastTick = 0
Events.EveryOneMinute.Add(function()
    --print('------- PER MINUTE ----')
    local tm = TIME_INST:getWorldAgeHours()
    local diff = tm - lastTick
    --print('diff',diff,tm,lastTick)
    if diff < 0.005 then
        --пол секунды
        return --print('OBLOM!')
    end
    lastTick = tm
    local player = getPlayer()
    if player:isAsleep() then
        return
    end
    if player:getVehicle() then
        return
    end
    local run, sprint = player:IsRunning(), player:isSprinting()
    local state = STATES[player:getCurrentState()]
    if run or sprint or state then
        local wall = state == 1
        local window = state and not wall
        local sneak = player:isSneaking()
        local mult = 1
                + (run and 1 or 0) + (sneak and 2 or 0) + (sprint and 2.5 or 0)
                + (window and 100 or 0) + (wall and 300 or 0)
        CheckAllClothes(player, mult)
    end
    CheckInsulation(player)
end)


--Момент надевания одежды.
do
    local old_wear_perform = ISWearClothing.perform
    function ISWearClothing:perform()
        local data = SLOTS[self.item:getBodyLocation()]
        if not data then
            return old_wear_perform(self)
        end
        local mod_data = self.item:getModData()
        local sz = mod_data.sz
        while sz > 10 do
            sz = sz - 10
        end
        local space = sz - getSizeChr(self.character)
        if space > -1 then
            return old_wear_perform(self)
        end
        if space < -2 + (data.nofit and 1 or 0) - (data.spacy and 1 or 0) then
            self.item:getContainer():setDrawDirty(true);
            self.item:setJobDelta(0.0);
            self.character:Say(getText("IGUI_SL_CantWear"))
            return --запрет одевания
        end
        local diff = -space - (data.spacy and 1 or 0)
        if diff > 0 then
            --1 or 2
            local chance = diff == 2 and CHANCES.ON_WEAR_VERY_TIGHT or CHANCES.ON_WEAR_TIGHT
            if data.breakfast then
                chance = chance * CHANCES.BREAKFAST_MULT
            end
            if ZombRand(100) < chance then
                RipClothes(self.item, self.character)
            end
            setRightInsulation(self.item, diff)
        end
        return old_wear_perform(self)
    end

    local old_wear_new = ISWearClothing.new
    function ISWearClothing:new(character, item, time, ...)
        local data = SLOTS[item:getBodyLocation()]
        if not data then
            return old_wear_new(self, character, item, time, ...)
        end
        local mod_data = item:getModData()
        local sz = mod_data.sz
        if not sz then
            --possible if spawned by admin
            sz = getRandomCSize()
            mod_data.sz = sz + 10
        end
        while sz > 10 do
            sz = sz - 10
        end
        local space = sz - getSizeChr(character)
        if space > -1 then
            return old_wear_new(self, character, item, time, ...)
        end
        if space == -1 then
            time = time * 3
        elseif space == -2 then
            time = time * 4
        else
            time = time * 5
        end
        return old_wear_new(self, character, item, time, ...)
    end

end

--Момент снимания одежды (конец)
do
    local old_perform = ISUnequipAction.perform
    function ISUnequipAction:perform()
        old_perform(self)
        if instanceof(self.item, "Clothing") and SLOTS[self.item:getBodyLocation()] then
            setRightInsulation(self.item, 0)
        end
    end
end


--Начало перетаскивания
do

    local old_start = ISInventoryTransferAction.start
    function ISInventoryTransferAction:start()
        if self.srcContainer then
            local typ = self.srcContainer:getType()
            local item = self.item
            if self.srcContainer == self.character:getInventory() then
                if instanceof(item, "Clothing") and item:isEquipped() and SLOTS[item:getBodyLocation()] then
                    setRightInsulation(item, 0)
                end
            elseif typ == "inventorymale" or typ == "inventoryfemale" then
                if not instanceof(item, "Clothing") then
                    return old_start(self) --Не шмотки игнорируем
                end
                local is_good = SLOTS[item:getBodyLocation()]
                if not is_good then
                    return old_start(self)
                end
                local sz = item:getModData().sz
                if sz then
                    return old_start(self) --Если уже есть размер, то нельзя его копировать
                end
                sz = getRandomCSize()
                local list = self.srcContainer:getItemsFromCategory("Clothing")
                for i = 0, list:size() - 1 do
                    local item = list:get(i)
                    local good = SLOTS[item:getBodyLocation()]
                    if good then
                        local data = item:getModData()
                        if not data.sz then
                            data.sz = sz + 10
                        end
                    end
                end
            end
        end
        return old_start(self)
    end

end

--Fix extra option
do
    local old_createItem = ISClothingExtraAction.createItem
    function ISClothingExtraAction:createItem(item, itemType, ...)
        local result = old_createItem(self, item, itemType, ...)
        if instanceof(item, "Clothing") and instanceof(result, "Clothing") then
            local old_sz = item:getModData().sz --print('found sz')
            if not old_sz then
                old_sz = getRandomCSize()
            end
            result:getModData().sz = old_sz
        end
        return result
    end
end



