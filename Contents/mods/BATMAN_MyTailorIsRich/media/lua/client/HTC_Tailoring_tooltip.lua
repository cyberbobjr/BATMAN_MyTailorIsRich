----------------------------------------------------------------------------------------------
-- Shuru's Tailoring Expanded - By Shurutsue / Yuhiko
-- Huge thanks to Chuck! Without his help i'd most likely still sit here working on it, or i'd have given up by now.
-- Things that're still planned:
--		* Requiring some table nearby for sewing
--		* Rebalaning requirements to learn clothing
--		* Maybe rebalance cost of the clothing
--		* Possibly optimize the scripts
--		* Add optional "special" support for Size mod and the ability to "choose" the size one wants to sew for (otherwise make it the size of the player)
--		* Open for ideas, though no promises
----------------------------------------------------------------------------------------------
local TYPE_COLOR = {
    Cotton = { .7, .7, .7 },
    Denim = { .4, .7, 1 },
    Leather = { .9, .9, 0 },
    Kevlar = { 1, .7, 0 },
    zReRubberizedFabrics = { 1, .7, 0 },
    RED_UNKNOWN = { 1, .4, .4 }, -- if devs add new type of fabric, this color will be chosen
}
do
    local vanilla_render = nil
    vanilla_render = ISToolTipInv.render
    function ISToolTipInv:render(...)
        if vanilla_render then
            vanilla_render(self, ...) -- execute vanilla code
        end
        if not ISContextMenu.instance or not ISContextMenu.instance.visibleCheck then
            -- render the tool tip only if there's no context menu showed
            if self.item:getFullType() == "HTCTailoring.sewingpattern" then
                local sewingModData = self.item:getModData()["sewing"]
                if sewingModData then
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
            end
        end
    end
end