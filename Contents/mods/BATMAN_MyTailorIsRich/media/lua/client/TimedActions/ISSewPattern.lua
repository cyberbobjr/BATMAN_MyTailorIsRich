require "TimedActions/ISBaseTimedAction"

ISSewPattern = ISBaseTimedAction:derive("ISSewPattern")

function ISSewPattern:isValid()
    local playerInv = self.character:getInventory()

    local threadCount = playerInv:getCountType("Base.Thread")
    local needleCount = playerInv:getCountType("Base.Needle")

    return threadCount >= 1 and needleCount >= 1
end

function ISSewPattern:update()
    if self.sewingMachine then
        self.character:faceThisObject(self.sewingMachine)
    end
    self.character:setMetabolicTarget(Metabolics.HeavyDomestic);
end

function ISSewPattern:start()
    self:setActionAnim("Loot")
    self.action:setTime(self.maxTime)
    self.character:reportEvent("EventLootItem");
    if HTCTailoringHelper.isModEnabled("Machines11") then
        self.sound = self.character:playSound("tailoringSewingMachine")
    end
end

function ISSewPattern:stop()
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    ISBaseTimedAction.stop(self);
end

function ISSewPattern:checkDegradation()
    local item = self.sewingPattern
    local tailoringLevel = self.character:getPerkLevel(Perks.Tailoring)
    local maxUses
    if tailoringLevel <= 0 then
        maxUses = 1
    elseif tailoringLevel >= 10 then
        maxUses = 4
    else
        -- Niveau de Tailoring entre 1 et 9
        -- Utilisation d'une interpolation linéaire pour déterminer le nombre d'utilisations max
        maxUses = 1 + math.floor(0.3 * tailoringLevel)
    end

    -- Calcul de la dégradation par utilisation
    local degradationPerUse = 1 / maxUses

    -- Réduit le usedDelta de l'item
    local currentUsedDelta = item:getUsedDelta()
    item:setUsedDelta(math.max(0, currentUsedDelta - degradationPerUse))

    -- Détruire l'item si le usedDelta atteint 0
    if item:getUsedDelta() <= 0 then
        local playerInv = self.character:getInventory()
        playerInv:DoRemoveItem(item)
    end
end

function ISSewPattern:perform()
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    ---@type ItemContainer
    local playerInv = self.character:getInventory()
    local materialTypeNeed = self.sewingModData["itemFabricType"]
    local materialTypeCountNeed = self.sewingModData["itemFabricAmount"]
    local threadCountNeed = self.sewingModData["threadAmount"]
    for i = 1, materialTypeCountNeed do
        playerInv:RemoveOneOf(HTC_MTIR_ContextMenu.MATERIAL_KEY[materialTypeNeed])
    end
    for i = 1, threadCountNeed do
        playerInv:RemoveOneOf("Base.Thread")
    end
    local itemType = self.sewingModData["itemType"]
    local modId = self.sewingModData["modId"]
    if modId then
        itemType = modId .. "." .. itemType
    end
    local newCloth = playerInv:AddItem(itemType)
    if newCloth then
        local clothModData = newCloth:getModData()
        clothModData["sz"] = self.sizelabel
        self.character:getXp():AddXP(Perks.Tailoring, 5);
        self:checkDegradation()
    end
    ISBaseTimedAction.perform(self);
end

function ISSewPattern:new(character, sewingPattern, sewingMachine, sizelabel)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.sewingModData = sewingPattern:getModData()["sewing"]
    o.sewingMachine = sewingMachine
    o.sizelabel = sizelabel
    o.sewingPattern = sewingPattern
    o.ignoreHandsWounds = true
    o.stopOnWalk = true
    o.stopOnRun = true
    o.maxTime = 300
    if character:isTimedActionInstant() then
        o.maxTime = 1
    end
    return o
end
