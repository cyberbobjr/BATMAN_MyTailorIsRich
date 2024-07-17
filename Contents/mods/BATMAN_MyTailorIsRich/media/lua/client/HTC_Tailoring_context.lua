local MAXIMUM_RENAME_LENGTH = 28
local function inBrackets(_string)
    return "[" .. tostring(_string) .. "]";
end;

local function generateTooltipLine(itemTxt, isOk, qty, qtyNeeded)
    if isOk then
        return " <RGB:0,1,0> " .. itemTxt .. " : " .. qty .. "/" .. qtyNeeded .. " <LINE> "
    else
        return " <RGB:1,0,0> " .. itemTxt .. " : " .. qty .. "/" .. qtyNeeded .. " <LINE> "
    end
end

local function getSewingMachine(playerObj, dir)
    local square = playerObj:getSquare():getAdjacentSquare(dir)
    for i = 1, square:getObjects():size() do
        local isoObject = square:getObjects():get(i - 1)
        local sprite = isoObject:getTextureName()
        if isoObject and (sprite == "machinestile_17" or sprite == "machinestile_16") then
            return isoObject
        end
    end
    return nil
end

HTC_MTIR_ContextMenu = {}

HTC_MTIR_ContextMenu.sew = function(sewingpattern, playerObject, sewingMachine)
    openISSewChooseLabelUI(playerObject, sewingpattern, sewingMachine)
end

HTC_MTIR_ContextMenu.MATERIAL_KEY = {
    Cotton = "RippedSheets",
    Denim = "DenimStrips",
    Leather = "LeatherStrips",
    Kevlar = "zReKevlar",
    zReRubberizedFabrics = "zReRubberizedFabrics",
}

HTC_MTIR_ContextMenu.checkingredientforsewing = function(playerObj, tooltipDescription, materialTypeNeed, materialTypeCountNeed, threadNeed)
    local playerInv = playerObj:getInventory()
    local materialCount = playerInv:getCountType(HTC_MTIR_ContextMenu.MATERIAL_KEY[materialTypeNeed])
    local threadCount = playerInv:getCountType("Base.Thread")
    local needleCount = playerInv:getCountType("Base.Needle")
    local materialCountAvailable = materialCount >= materialTypeCountNeed
    local threadCountAvailable = threadCount >= threadNeed
    local levelAvailable = true
    local directions = { IsoDirections.N, IsoDirections.NE, IsoDirections.E, IsoDirections.SE, IsoDirections.S, IsoDirections.SW, IsoDirections.W, IsoDirections.NW }
    local foundMachine = nil
    if HTCTailoringHelper.isModEnabled("Machines11") then
        for _, dir in ipairs(directions) do
            foundMachine = getSewingMachine(playerObj, dir)
            if foundMachine then
                break
            end
        end
    else
        foundMachine = false
    end

    tooltipDescription = tooltipDescription .. generateTooltipLine(getText("IGUI_SM_" .. HTC_MTIR_ContextMenu.MATERIAL_KEY[materialTypeNeed]), materialCountAvailable, materialCount, materialTypeCountNeed)
    tooltipDescription = tooltipDescription .. generateTooltipLine(getText("IGUI_SM_Thread"), threadCountAvailable, threadCount, threadNeed)
    tooltipDescription = tooltipDescription .. generateTooltipLine(getText("IGUI_SM_Needle"), needleCount >= 1, needleCount, 1)
    if foundMachine ~= nil then
        tooltipDescription = tooltipDescription .. " <RGB:0,1,0> "
    else
        tooltipDescription = tooltipDescription .. " <RGB:1,0,0> "
    end
    tooltipDescription = tooltipDescription .. getText("ContextMenu_SewingMachine") .. " <LINE> "

    local level = HTCTailoringHelper.getLevelNeeded(materialTypeNeed, materialTypeCountNeed, threadNeed)
    if playerObj:getPerkLevel(Perks.Tailoring) < level then
        levelAvailable = false
        tooltipDescription = tooltipDescription .. getText("IGUI_HTCTailoring_CantLearn") .. " (" .. getText("IGUI_CraftCategory_Tailoring") .. " LV." .. level .. ")"
    end
    return (materialCountAvailable and threadCountAvailable and (foundMachine ~= nil) and levelAvailable), tooltipDescription, foundMachine
end

function HTC_MTIR_ContextMenu:onRenameItemClick(button, player, item)
    local playerNum = player:getPlayerNum()
    if button.internal == "OK" then
        local length = button.parent.entry:getInternalText():len()
        if button.parent.entry:getText() and button.parent.entry:getText() ~= "" then
            if length <= MAXIMUM_RENAME_LENGTH then
                item:setName(button.parent.entry:getText());
                item:setCustomName(true);
                local pdata = getPlayerData(playerNum);
                pdata.playerInventory:refreshBackpacks();
                pdata.lootInventory:refreshBackpacks();
                local x = math.floor(player:getX())
                local y = math.floor(player:getY())
                local z = math.floor(player:getZ())
                ISLogSystem.sendLog(player,
                        "tracking",
                        inBrackets(player:getUsername()) ..
                                inBrackets("ItemRenamed") ..
                                item:getType() ..
                                "," ..
                                button.parent.entry:getText())
            else
                player:Say(getText("IGUI_PlayerText_ItemNameTooLong", MAXIMUM_RENAME_LENGTH));
            end
        end
    end
    if JoypadState.players[playerNum + 1] then
        setJoypadFocus(playerNum, getPlayerInventory(playerNum))
    end
end

HTC_MTIR_ContextMenu.onRenameItem = function(sewingPatternItem, playerNum)
    local modal = ISTextBox:new(0, 0, 280, 180, getText("ContextMenu_RenameItem"), sewingPatternItem:getName(), nil, HTC_MTIR_ContextMenu.onRenameItemClick, playerNum, getSpecificPlayer(playerNum), sewingPatternItem);
    modal:initialise();
    modal:addToUIManager();
    if JoypadState.players[playerNum + 1] then
        setJoypadFocus(playerNum, modal)
    end
end

HTC_MTIR_ContextMenu.onEditModData = function(sewingPatternItem, playerNum)
    local sewingModData = sewingPatternItem:getModData()["sewing"]
    if sewingModData then
        openISTailoringAdminUI(sewingPatternItem)
    end
end

HTC_MTIR_ContextMenu.BuildContext = function(_plID, _context, _items)
    local playerObj = getPlayer(_plID);
    ---@type InventoryItem
    local itemObj

    for i, items in ipairs(_items) do
        if not instanceof(items, "InventoryItem") then
            itemObj = items.items[1];
        else
            itemObj = items;
        end
        if itemObj then
            local fullType = itemObj:getFullType()
            if fullType == "HTCTailoring.sewingpattern" then
                _context:addOption(getText("ContextMenu_RenameItem"), itemObj, HTC_MTIR_ContextMenu.onRenameItem, _plID)

                local sewingModData = itemObj:getModData()["sewing"]
                local itemType = sewingModData["itemType"]
                local allScriptItems = getScriptManager():getItemsByType(itemType)
                local scriptItem = allScriptItems:get(0)
                if scriptItem then
                    local available = true
                    local foundMachine = nil
                    local tooltipDescription = (getTextOrNull("ContextMenu_Need") or "Need : ") .. "<LINE> "
                    available, tooltipDescription, foundMachine = HTC_MTIR_ContextMenu.checkingredientforsewing(playerObj, tooltipDescription, sewingModData["itemFabricType"], sewingModData["itemFabricAmount"], sewingModData["threadAmount"])

                    local title = (getTextOrNull("ContextMenu_Sew") or "Sew") .. " " .. scriptItem:getDisplayName()
                    local option = _context:addOption(title, itemObj, HTC_MTIR_ContextMenu.sew, playerObj, foundMachine)
                    local tooltip = ISInventoryPaneContextMenu.addToolTip(option)
                    tooltip.description = tooltipDescription
                    option.toolTip = tooltip
                    option.notAvailable = not available
                end

                if isDebugEnabled() or isAdmin() then
                    _context:addOption(getText("ContextMenu_EditModData"), itemObj, HTC_MTIR_ContextMenu.onEditModData, _plID)
                end
            end
        end
    end
end

return HTC_MTIR_ContextMenu