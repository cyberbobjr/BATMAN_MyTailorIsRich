HTCTailoringHelper = {}

HTCTailoringHelper.isModEnabled = function(modname)
    local actmods = getActivatedMods();
    for i = 0, actmods:size() - 1, 1 do
        if actmods:get(i) == modname then
            return true;
        end
    end
    return false;
end

HTCTailoringHelper.getLevelNeeded = function(itemFabricType, itemFabricAmount, threadAmount)
    local itemLevel = 0
    local mult = 0.0
    if itemFabricType == "Cotton" then
        itemLevel = 0
        mult = 0.1
    elseif itemFabricType == "Denim" then
        itemLevel = 1
        mult = 0.2
    elseif itemFabricType == "Leather" then
        itemLevel = 2
        mult = 0.3
    elseif itemFabricType == "Kevlar" or itemFabricType == "zReRubberizedFabrics" then
        -- for mod zReVaccine and zRe ARMOR ABSORB
        itemLevel = 3
        mult = 0.4
    end
    return Math.min(itemLevel + math.floor((itemFabricAmount + threadAmount) * mult), 10)
end