local SLOTS = GLOBAL_CLOTHES_SLOTS

local function OnCutLabel(player, items)
    --print("move & cut")
    local inv = player:getInventory()
    for i, item in ipairs(items) do
        local container = item:getContainer()
        if container ~= inv then
            ISTimedActionQueue.add(ISInventoryTransferAction:new(player, item, container, inv))
        elseif item:isEquipped() then
            ISTimedActionQueue.add(ISUnequipAction:new(player, item, 50));
        end
        ISTimedActionQueue.add(ISCutClothesLabel:new(player, item))
    end
end

local function OnCheckLabel(player, items)
    --move & check
    local inv = player:getInventory()
    for i, item in ipairs(items) do
        local container = item:getContainer()
        if container ~= inv then
            ISTimedActionQueue.add(ISInventoryTransferAction:new(player, item, container, inv))
        end
        ISTimedActionQueue.add(ISCheckClothesLabel:new(player, item))
    end
end

local function mayCheckItem(item, is_scissors)
    if instanceof(item, "Clothing") and SLOTS[item:getBodyLocation()] then
        local sz = item:getModData().sz
        if sz then
            if sz < 10 then
                if is_scissors then
                    return true, true  -- item to cut, has size label
                end
            else
                return true, false  -- item to check, has size label
            end
        end
        return true, false  -- item to check, no size label
    end
    return false, false  -- not a valid item
end

local function invContextMenu(playerIndex, context, worldObjects)
    local playerObj = getSpecificPlayer(playerIndex)
    local primary = playerObj:getPrimaryHandItem()
    local secondary = playerObj:getSecondaryHandItem()
    local is_scissors = (primary and primary:getType() == "Scissors") or (secondary and secondary:getType() == "Scissors")

    local cutItems = {}
    local checkItems = {}

    for _, obj in ipairs(worldObjects) do
        if type(obj) == 'table' and obj.items and #obj.items > 1 then
            for i = 2, #obj.items do
                local item = obj.items[i]
                local valid, toCut = mayCheckItem(item, is_scissors)
                if valid then
                    if toCut then
                        table.insert(cutItems, item)
                    else
                        table.insert(checkItems, item)
                    end
                end
            end
        else
            local valid, toCut = mayCheckItem(obj, is_scissors)
            if valid then
                if toCut then
                    table.insert(cutItems, obj)
                else
                    table.insert(checkItems, obj)
                end
            end
        end
    end

    if #checkItems > 0 then
        context:addOption(getText("IGUI_CheckLabel"), playerObj, OnCheckLabel, checkItems)
    end

    if is_scissors and #cutItems > 0 then
        context:addOption(getText("IGUI_CutLabel"), playerObj, OnCutLabel, cutItems)
    end
end

Events.OnFillInventoryObjectContextMenu.Add(invContextMenu)
