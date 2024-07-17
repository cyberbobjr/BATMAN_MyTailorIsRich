require "ISUI/ISCollapsableWindow"
require "ISUI/ISTextEntryBox"
require "ISUI/ISLabel"

local tailoringAdminUI = nil
local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)

ISTailoringAdminUI = ISCollapsableWindow:derive("ISTailoringAdminUI");

function ISTailoringAdminUI:initialise()
    ISCollapsableWindow.initialise(self);
end

function ISTailoringAdminUI:onCancel()
    closeISTailoringAdminUI()
end

function ISTailoringAdminUI:onAccept(button, x, y)
    if self.modIdInputText:getText() ~= "" and self.itemTypeInputText:getText() ~= "" then
        local modData = self.item:getModData()["sewing"]
        modData["modId"] = self.modIdInputText:getText()
        modData["itemType"] = self.itemTypeInputText:getText()
    end
    closeISTailoringAdminUI()
end

function ISTailoringAdminUI:createChildren()
    ISCollapsableWindow.createChildren(self)
    local th = self:titleBarHeight();
    local myh = th
    if self.item then
        local modData = self.item:getModData()["sewing"]
        self.modIdInputTextLabel = ISLabel:new(self.padding, myh + self.padding, FONT_HGT_MEDIUM, "modId : ", 1, 1, 1, 1, UIFont.Small, true);
        self:addChild(self.modIdInputTextLabel);

        self.modIdInputText = ISTextEntryBox:new(modData["modId"], self.padding + self.modIdInputTextLabel:getWidth(), myh + self.padding, self.width - (self.padding * 2), FONT_HGT_MEDIUM)
        self.modIdInputText:initialise();
        self.modIdInputText:instantiate();
        self.modIdInputText.font = UIFont.Medium
        self.modIdInputText.drawBorder = true
        self.modIdInputText.SMALL_FONT_HGT = self.FONT_HGT_SMALL
        self.modIdInputText.MEDIUM_FONT_HGT = self.FONT_HGT_MEDIUM
        self:addChild(self.modIdInputText)
        myh = myh + self.modIdInputText:getHeight() + (self.padding * 2)

        self.itemTypeInputTextLabel = ISLabel:new(self.padding, myh, FONT_HGT_MEDIUM, "modId : ", 1, 1, 1, 1, UIFont.Small, true);
        self:addChild(self.itemTypeInputTextLabel);
        self.itemTypeInputText = ISTextEntryBox:new(modData["itemType"], self.padding + self.itemTypeInputTextLabel:getWidth(), myh, self.width - (self.padding * 2), FONT_HGT_MEDIUM)
        self.itemTypeInputText:initialise();
        self.itemTypeInputText:instantiate();
        self.itemTypeInputText.font = UIFont.Medium
        self.itemTypeInputText.drawBorder = true
        self.itemTypeInputText.SMALL_FONT_HGT = self.FONT_HGT_SMALL
        self.itemTypeInputText.MEDIUM_FONT_HGT = self.FONT_HGT_MEDIUM
        self:addChild(self.itemTypeInputText)
        myh = myh + self.itemTypeInputText:getHeight() + self.padding
    end
    --
    self.acceptButton = ISButton:new(0, myh, self.width / 2, self.btnHgt, getText("IGUI_OK"), self, self.onAccept)
    self.acceptButton:initialise();
    self.acceptButton:instantiate();
    self.acceptButton.borderColor = { r = 0.7, g = 0.7, b = 0.7, a = 0.5 }; -- Optional
    self:addChild(self.acceptButton);

    self.cancelButton = ISButton:new(self.width / 2, myh, self.width / 2, self.btnHgt, getText("IGUI_CANCEL"), self, self.onCancel)
    self.cancelButton:initialise();
    self.cancelButton:instantiate();
    self.cancelButton.borderColor = { r = 0.7, g = 0.7, b = 0.7, a = 0.5 }; -- Optional
    self:addChild(self.cancelButton);

    myh = myh + self.acceptButton:getHeight()

    self:setHeight(myh)
end

function ISTailoringAdminUI:new(item)
    local o = {};
    self.btnHgt = math.max(25, FONT_HGT_SMALL + 3 * 2)
    self.padding = 5
    self.width = 500
    self.item = item
    self.height = 150 + self.btnHgt
    self.x = (getCore():getScreenWidth() - self.width) / 2
    self.y = (getCore():getScreenHeight() - self.height) / 2
    o = ISCollapsableWindow:new(self.x, self.y, self.width + (self.padding * 2), self.height)
    setmetatable(o, self)
    self.__index = self
    o.title = getText("IGUI_CHANGE_MODDATA")
    o.pin = true
    o.resizable = false
    return o;
end

function openISTailoringAdminUI(item)
    --if not tailoringAdminUI then
    --end
    tailoringAdminUI = ISTailoringAdminUI:new(item)
    tailoringAdminUI:initialise();
    tailoringAdminUI:setVisible(true);
    tailoringAdminUI:addToUIManager();
end

function closeISTailoringAdminUI()
    if tailoringAdminUI then
        tailoringAdminUI:setVisible(false);
        tailoringAdminUI:removeFromUIManager();
    end
    tailoringAdminUI = nil
end