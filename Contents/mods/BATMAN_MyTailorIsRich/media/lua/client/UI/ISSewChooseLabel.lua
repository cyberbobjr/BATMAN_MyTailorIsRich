require "ISUI/ISCollapsableWindow"
require "ISUI/ISScrollingListBox"

local sewChooseLabelUI = nil
local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)

ISSewChooseLabelUI = ISCollapsableWindow:derive("ISSewChooseLabelUI");

function ISSewChooseLabelUI:initialise()
    ISCollapsableWindow.initialise(self);
end

function ISSewChooseLabelUI:onCancel()
    closeISSewChooseLabelUI()
end

function ISSewChooseLabelUI:onAccept(button, x, y)
    local selectedRow = self.labelsList
    if selectedRow.selected == 0 then
        return
    end
    local selectedSlot = self.labelsList.items[selectedRow.selected]
    ISTimedActionQueue.add(ISSewPattern:new(self.playerObject, self.sewingpattern, self.sewingMachine, selectedSlot.item))
    closeISSewChooseLabelUI()
end

function ISSewChooseLabelUI:createChildren()
    ISCollapsableWindow.createChildren(self)
    local th = self:titleBarHeight();

    self.labelsList = ISScrollingListBox:new(0, th, self.width, self.height - self.btnHgt - self.padding)
    self.labelsList:initialise();
    self.labelsList:instantiate();
    self.labelsList:setAnchorRight(false)
    self.labelsList:setAnchorBottom(true)
    self.labelsList.itemheight = FONT_HGT_MEDIUM + self.itemheight
    self.labelsList.selected = 1
    self.labelsList.font = UIFont.Medium
    self.labelsList.drawBorder = true
    self.labelsList.SMALL_FONT_HGT = self.FONT_HGT_SMALL
    self.labelsList.MEDIUM_FONT_HGT = self.FONT_HGT_MEDIUM
    for index, sizeLabel in ipairs(STAR_MODS.SizeLabels.CSIZE) do
        self.labelsList:addItem(sizeLabel, index)
    end

    self:addChild(self.labelsList)
    local myh = self.labelsList:getHeight()
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

function ISSewChooseLabelUI:new(playerObject, sewingpattern, sewingMachine)
    local o = {};
    self.btnHgt = math.max(25, FONT_HGT_SMALL + 3 * 2)
    self.padding = 20
    self.width = 500
    self.playerObject = playerObject
    self.sewingpattern = sewingpattern
    self.sewingMachine = sewingMachine
    self.itemheight = 14
    self.height = (#STAR_MODS.SizeLabels.CSIZE * (FONT_HGT_MEDIUM + self.itemheight)) + self.btnHgt
    self.x = (getCore():getScreenWidth() - self.width) / 2
    self.y = 100
    o = ISCollapsableWindow:new(self.x, self.y, self.width + (self.padding * 2), self.height)
    setmetatable(o, self)
    self.__index = self
    o.title = getText("IGUI_CHOOSE_SIZELABEL")
    o.pin = true
    o.resizable = false
    return o;
end

function openISSewChooseLabelUI(playerObject, sewingpattern, sewingMachine)
    if not sewChooseLabelUI then
        sewChooseLabelUI = ISSewChooseLabelUI:new(playerObject, sewingpattern, sewingMachine)
        sewChooseLabelUI:initialise();
    end
    sewChooseLabelUI:setVisible(true);
    sewChooseLabelUI:addToUIManager();
end

function closeISSewChooseLabelUI()
    if sewChooseLabelUI then
        sewChooseLabelUI:setVisible(false);
        sewChooseLabelUI:removeFromUIManager();
    end
    sewChooseLabelUI = nil
end