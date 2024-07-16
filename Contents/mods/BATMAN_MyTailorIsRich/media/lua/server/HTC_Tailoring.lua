require "recipecode"

function Recipe.OnGiveXP.Tailoring1(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Tailoring, 1);
end
function Recipe.OnGiveXP.Tailoring2(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Tailoring, 2);
end
function Recipe.OnGiveXP.Tailoring3(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Tailoring, 3);
end
function Recipe.OnGiveXP.Tailoring5(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Tailoring, 5);
end
function Recipe.OnGiveXP.Tailoring10(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Tailoring, 10);
end

function Recipe.OnCreate.HTC_MTIR_CreateSewingPatternFromItem(items, result, player, selectedItem)
    local itemType = selectedItem:getType()
    local modId = selectedItem:getModID()
    local clothingItemName = selectedItem:getClothingItemName()
    local itemFabricType = selectedItem:getFabricType()

    if selectedItem:getTags():contains("zReRepairableVest") then
        itemFabricType = "Kevlar"
    end

    if selectedItem:getTags():contains("zReRepairableChemsuit") then
        itemFabricType = "zReRubberizedFabrics"
    end
    if itemFabricType == nil then
        itemFabricType = "Cotton"
    end

    local itemFabricAmount = math.floor(selectedItem:getNbrOfCoveredParts() * 1.25)

    if not itemFabricAmount or itemFabricAmount == 0 then
        itemFabricAmount = 3 -- Base cost for items that do not have possible holes / an inspect menu. Subject to change in the future, maybe
    end

    local threadAmount = math.ceil(itemFabricAmount * 0.5) -- we half that amount to get the amount of thread required for sewing it
    local level = HTCTailoringHelper.getLevelNeeded(itemFabricType, itemFabricAmount, threadAmount)
    if player:getPerkLevel(Perks.Tailoring) < level then
        local phrase = getText("IGUI_HTCTailoring_CantLearn") .. " (" .. getText("IGUI_CraftCategory_Tailoring") .. " LV." .. level .. ")"
        player:Say(phrase)
        player:getInventory():Remove(result)
        return
    end

    local sewingPattern = player:getInventory():AddItem("HTCTailoring.sewingpattern")
    if sewingPattern then
        sewingPattern:setName(getText("IGUI_Sewingpattern") .. selectedItem:getDisplayName());
        sewingPattern:setCustomName(true);
        local sewingPatternModData = sewingPattern:getModData()
        sewingPatternModData["sewing"] = {
            itemType = itemType,
            modId = modId,
            clothingItemName = clothingItemName,
            itemFabricType = itemFabricType,
            itemFabricAmount = itemFabricAmount,
            threadAmount = threadAmount,
        }
        player:getInventory():Remove(selectedItem)
    end
end