--FIX items with missing FabricType

local items_to_fix_cotton = {
    "Trousers_Shellsuit_Black",
    "Trousers_Shellsuit_Blue",
    "Trousers_Shellsuit_Green",
    "Trousers_Shellsuit_Pink",
    "Trousers_Shellsuit_Teal",
    "Bikini_Pattern01",
    "SwimTrunks_Blue",
    "SwimTrunks_Green",
    "SwimTrunks_Red",
    "SwimTrunks_Yellow",
    "BunnyTail",
    "BunnySuitBlack",
    "BunnySuitPink",

    -- HATS
    "Hat_Bandana",
    "Hat_BandanaTINT",
    "Hat_BaseballCap",
    "Hat_BaseballCapKY",
    "Hat_BaseballCapKY_Red",
    "Hat_BaseballCapBlue",
    "Hat_BaseballCapRed",
    "Hat_BaseballCapGreen",
    "Hat_BaseballCapArmy",
    "Hat_Beany",
    "Hat_Beret",
    "Hat_BeretArmy",
    "Hat_ChefHat",
    "Hat_EarMuffs",
    "Hat_EarMuff_Protectors",
    "Hat_FastFood",
    "Hat_FastFood_IceCream",
    "Hat_FastFood_Spiffo",
    "Hat_Fedora",
    "Hat_Fedora_Delmonte",
    "Hat_GolfHat",
    "Hat_Police",
    "Hat_Police_Grey",
    "Hat_Ranger",
    "Hat_SantaHat",
    "Hat_SantaHatGreen",
    "Hat_ShowerCap",
    "Hat_SummerHat",
    "Hat_SurgicalCap_Blue",
    "Hat_SurgicalCap_Green",
    "Hat_Sweatband",
    "Hat_WeddingVeil",
    "Hat_BucketHat",
    "Hat_BonnieHat",
    "Hat_BonnieHat_CamoGreen",
    "Hat_VisorBlack",
    "Hat_VisorRed",
    "Hat_PeakedCapArmy",
    "Hat_BandanaTied",
    "Hat_NewspaperHat",
    "Hat_PartyHat_Stars",
    "Hat_TinFoilHat",
    "Hat_BunnyEarsBlack",
    "Hat_BunnyEarsWhite",
    "Hat_GoldStar",
    "Hat_Antlers",
    "Hat_Jay",
    "Hat_FurryEars",
    "Hat_JokeArrow",
    "Hat_JokeKnife",

    -- STFR
    "STFR.Hat_BaseballCap_DOC_Meade",
    "STFR.Hat_BaseballCap_DOC_Jefferson",
    "STFR.Hat_BaseballCap_EMS_Meade",
    "STFR.Hat_BaseballCap_EMS_Jefferson",
    "STFR.Hat_BaseballCap_EMS_Louisville",
    "STFR.Hat_BaseballCap_USPS",
    "STFR.Hat_BaseballCap_Police_Louisville_Officer_SWAT_Black",
    "STFR.Hat_BaseballCap_Police_Louisville_Officer_SWAT_Camo",
    "STFR.Hat_BaseballCap_Police_Jefferson_Officer_SWAT_Blue",
    "STFR.Hat_BaseballCap_Sheriff_Jefferson_Officer_SWAT_Green",
    "STFR.Hat_BaseballCap_Sheriff_Rosewood_Officer_SWAT_Green",
    "STFR.Hat_BaseballCap_Sheriff_Rosewood_Officer_SWAT_Orange",
    "STFR.Hat_BaseballCap_Police_WestPoint_Officer_SWAT_Navy",
    "STFR.Hat_BaseballCap_Police_KSP_Officer_SWAT_Blue",
    "STFR.Hat_BaseballCap_Police_KSP_Officer_SWAT_Camo",
    "STFR.Hat_BaseballCap_Sheriff_Meade_Officer_SWAT_Tan",
    "STFR.Hat_BaseballCap_Police_Riverside_Officer_SWAT_Blue",
    "STFR.Hat_HardHat_Sheriff_Rosewood_SWAT_Orange",
    "STFR.Hat_BonnieHat_Police_Louisville_Officer_SWAT_Black",
    "STFR.Hat_BonnieHat_Police_Louisville_Officer_SWAT_Camo",
    "STFR.Hat_BonnieHat_Police_Jefferson_Officer_SWAT_Blue",
    "STFR.Hat_BonnieHat_Sheriff_Jefferson_Officer_SWAT_Green",
    "STFR.Hat_BonnieHat_Sheriff_Rosewood_Officer_SWAT_Green",
    "STFR.Hat_BonnieHat_Police_WestPoint_Officer_SWAT_Navy",
    "STFR.Hat_BonnieHat_Police_KSP_Officer_SWAT_Blue",
    "STFR.Hat_BonnieHat_Police_KSP_Officer_SWAT_Camo",
    "STFR.Hat_BonnieHat_Sheriff_Meade_Officer_SWAT_Tan",
    "STFR.Hat_BonnieHat_Police_Riverside_Officer_SWAT_Blue",

    -- KATTAJ1
    "Base.Military_Mask_Balaclava1-Black",
    "Base.Military_Mask_Balaclava1-Desert",
    "Base.Military_Mask_Balaclava1-Green",
    "Base.Military_Mask_Balaclava1-White",
    "Base.Military_Mask_Balaclava2-Black",
    "Base.Military_Mask_Balaclava2-Desert",
    "Base.Military_Mask_Balaclava2-Green",
    "Base.Military_Mask_Balaclava2-White",
    "Base.Military_Mask_Balaclava3-Black",
    "Base.Military_Mask_Balaclava3-Desert",
    "Base.Military_Mask_Balaclava3-Green",
    "Base.Military_Mask_Balaclava3-White",
    "Base.Military_Mask_BandanaMask-Black",
    "Base.Military_Mask_BandanaMask-Desert",
    "Base.Military_Mask_BandanaMask-Green",
    "Base.Military_Mask_BandanaMask-White",

}

local items_to_fix_denim = {
    "Vest_Hunting_Grey",
    "Vest_Hunting_Orange",
    "Vest_Hunting_Camo",
    "Vest_Hunting_CamoGreen",
    "Vest_Foreman",
    "Vest_HighViz",
    -- HATS
    "Hat_WinterHat",
    "Hat_WoolyHat",

}
local items_to_fix_leather = {
    "Ghillie_Top",
    "Jacket_Fireman",
    "Jacket_Padded",
    "PonchoGreen",
    "PonchoYellow",
    "Jacket_Shellsuit_Black",
    "Jacket_Shellsuit_Blue",
    "Jacket_Shellsuit_Green",
    "Jacket_Shellsuit_Pink",
    "Jacket_Shellsuit_Teal",
    "SpiffoSuit",
    "SpiffoTail",
    "HazmatSuit",
    -- HATS
    "Hat_Cowboy",
    "Hat_Raccoon",

    -- STFR
    "STFR.Hat_Police_Muldraugh_Officer",
    "STFR.Hat_Police_Muldraugh_SGT",
    "STFR.Hat_Police_Muldraugh_CPT",
    "STFR.Hat_Sheriff_Meade_Officer",
    "STFR.Hat_Police_WestPoint_Officer",
    "STFR.Hat_Police_WestPoint_SGT",
    "STFR.Hat_Police_WestPoint_CPT",
    "STFR.Hat_Police_Riverside_Officer",
    "STFR.Hat_Police_Riverside_SGT",
    "STFR.Hat_Police_Riverside_CPT",
    "STFR.Hat_Sheriff_Rosewood_Officer",
    "STFR.Hat_Sheriff_Rosewood_SGT",
    "STFR.Hat_Sheriff_Rosewood_CPT",
    "STFR.Hat_Police_Louisville_Officer",
    "STFR.Hat_Police_Louisville_SGT",
    "STFR.Hat_Police_Louisville_CPT",
    "STFR.Hat_Police_Jefferson_Officer",
    "STFR.Hat_Police_Jefferson_SGT",
    "STFR.Hat_Police_Jefferson_CPT",
    "STFR.Hat_Sheriff_Jefferson_Officer",
    "STFR.Hat_Police_KSP_Officer",
    "STFR.Hat_Ranger_Federal",
    "STFR.Hat_Ranger_State_Park",
    "STFR.Hat_Ranger_Conservation",
    "STFR.Hat_EMS_Jefferson",
    "STFR.Hat_EMS_Louisville",
    "STFR.Hat_EMS_Meade",
    "STFR.Hat_Fire_Louisville",
    "STFR.Hat_Fire_Louisville_Supervisor_White",
    "STFR.Hat_Fire_Louisville_Supervisor_Black",
    "STFR.Hat_Security_Bank",
    "STFR.Hat_Security_Hotel_Havisham",
    "STFR.Hat_Security_Mall_Grand_Ohio",
    "STFR.Hat_Security_Mall_Valley_Station",
    "STFR.Hat_Security_Mall_Louisville",

    -- KATTAJ1 - Military
    "Base.Military_ArmsProtectionLower_Patriot_Light-Black",
    "Base.Military_ArmsProtectionLower_Patriot_Light-Desert",
    "Base.Military_ArmsProtectionLower_Patriot_Light-Green",
    "Base.Military_ArmsProtectionLower_Patriot_Light-White",
    "Base.Military_ArmsProtectionLower_Defender_Medium-Black",
    "Base.Military_ArmsProtectionLower_Defender_Medium-Desert",
    "Base.Military_ArmsProtectionLower_Defender_Medium-Green",
    "Base.Military_ArmsProtectionLower_Defender_Medium-White",
    "Base.Military_ArmsProtectionLower_Vanguard_Heavy-Black",
    "Base.Military_ArmsProtectionLower_Vanguard_Heavy-Desert",
    "Base.Military_ArmsProtectionLower_Vanguard_Heavy-Green",
    "Base.Military_ArmsProtectionLower_Vanguard_Heavy-White",
    "Base.Military_ArmsProtectionUpper_Patriot_Light-Black",
    "Base.Military_ArmsProtectionUpper_Patriot_Light-Desert",
    "Base.Military_ArmsProtectionUpper_Patriot_Light-Green",
    "Base.Military_ArmsProtectionUpper_Patriot_Light-White",
    "Base.Military_ArmsProtectionUpper_Defender_Medium-Black",
    "Base.Military_ArmsProtectionUpper_Defender_Medium-Desert",
    "Base.Military_ArmsProtectionUpper_Defender_Medium-Green",
    "Base.Military_ArmsProtectionUpper_Defender_Medium-White",
    "Base.Military_ArmsProtectionUpper_Defender_Medium-Press",
    "Base.Military_ArmsProtectionUpper_Vanguard_Heavy-Black",
    "Base.Military_ArmsProtectionUpper_Vanguard_Heavy-Desert",
    "Base.Military_ArmsProtectionUpper_Vanguard_Heavy-Green",
    "Base.Military_ArmsProtectionUpper_Vanguard_Heavy-White",
    "Base.Military_LegsProtectionLower_Patriot_Light-Black",
    "Base.Military_LegsProtectionLower_Patriot_Light-Desert",
    "Base.Military_LegsProtectionLower_Patriot_Light-Green",
    "Base.Military_LegsProtectionLower_Patriot_Light-White",
    "Base.Military_LegsProtectionLower_Defender_Medium-Black",
    "Base.Military_LegsProtectionLower_Defender_Medium-Desert",
    "Base.Military_LegsProtectionLower_Defender_Medium-Green",
    "Base.Military_LegsProtectionLower_Defender_Medium-White",
    "Base.Military_LegsProtectionLower_Vanguard_Heavy-Black",
    "Base.Military_LegsProtectionLower_Vanguard_Heavy-Desert",
    "Base.Military_LegsProtectionLower_Vanguard_Heavy-Green",
    "Base.Military_LegsProtectionLower_Vanguard_Heavy-White",
    "Base.Military_LegsProtectionUpper_Patriot_Light-Black",
    "Base.Military_LegsProtectionUpper_Patriot_Light-Desert",
    "Base.Military_LegsProtectionUpper_Patriot_Light-Green",
    "Base.Military_LegsProtectionUpper_Patriot_Light-White",
    "Base.Military_LegsProtectionUpper_Defender_Medium-Black",
    "Base.Military_LegsProtectionUpper_Defender_Medium-Desert",
    "Base.Military_LegsProtectionUpper_Defender_Medium-Green",
    "Base.Military_LegsProtectionUpper_Defender_Medium-White",
    "Base.Military_LegsProtectionUpper_Defender_Medium-Press",
    "Base.Military_LegsProtectionUpper_Vanguard_Heavy-Black",
    "Base.Military_LegsProtectionUpper_Vanguard_Heavy-Desert",
    "Base.Military_LegsProtectionUpper_Vanguard_Heavy-Green",
    "Base.Military_LegsProtectionUpper_Vanguard_Heavy-White",

}

local fix_category_items = {
    Clothing = {
        "Military_Jacket_WinterHood-Green_DOWN",
        "Military_Jacket_Classic-Desert_Open",
        "Military_Sheath_Defender-Black_Back",
        "Military_Sheath_Defender-Black_HipArmorLeft",
        "Military_Sheath_Defender-White_HipArmorLeft",
        "Military_Jacket_WinterHood-Desert_Up",
        "Military_Holster_Defender-Desert_BeltLeft",
        "Military_Sheath_Defender-Black",
        "Military_Sheath_Defender-Black_HipArmorLeft",
        "STFR.Jacket_Police_Louisville_SGT_OPEN",
        "STFR.Jacket_Police_Muldraugh_SGT_OPEN",
        "STFR.Jacket_Sheriff_Rosewood_Officer_OPEN",
        "STFR.Jacket_Fireman_Khaki_Meade_OPEN",
        "STFR.Jacket_Ranger_State_Park_OPEN",
        "STFR.Jacket_Police_Louisville_Officer_OPEN",
        "STFR.Jacket_Police_Jefferson_SGT_OPEN",
        "STFR.Jacket_Ranger_Federal_OPEN",
        "STFR.Jacket_Sheriff_Jefferson_SGT_OPEN",
        "STFR.Jacket_Fireman_Black_Meade_OPEN",
        "STFR.Jacket_Sheriff_Meade_Officer_OPEN",
        "STFR.Jacket_Police_KSP_SGT_OPEN",
        "STFR.Jacket_DOC_RavenCreek_OPEN",
        "STFR.Jacket_Sheriff_Rosewood_SGT_OPEN",
        "STFR.Jacket_Fireman_Black_LVIA_OPEN",
        "STFR.Jacket_Sheriff_Jefferson_CPT_OPEN",
        "STFR.Jacket_Police_Riverside_SGT_OPEN",
        "STFR.Jacket_EMS_Louisville_OPEN",
        "STFR.Jacket_EMS_RavenCreek_OPEN",
        "STFR.Jacket_Fireman_Khaki_Rosewood_OPEN",
        "STFR.Jacket_Sheriff_Rosewood_CPT_OPEN",
        "STFR.Jacket_Police_Muldraugh_CPT_OPEN",
        "STFR.Jacket_Police_WestPoint_Officer_OPEN",
        "STFR.Jacket_Police_KSP_Officer_OPEN",
        "STFR.Jacket_Police_Jefferson_CPT_OPEN",
        "STFR.Jacket_Police_Riverside_CPT_OPEN",
        "STFR.Jacket_Fireman_Black_Louisville_OPEN",
        "STFR.Jacket_Fireman_Black_RavenCreek_OPEN",
        "STFR.Jacket_DOC_Jefferson_OPEN",
        "STFR.Jacket_EMS_Meade_OPEN",
        "STFR.Jacket_EMS_Jefferson_OPEN",
    },
    Container = {
        "Military_BagBack_StormPack_Small-Green",
        "Military_BagBack_StormPack_Small-Black",
        "Military_BagBack_StormPack_Medium-Desert"
    },
    Weapon = {
        "Federal_INC"
    }
}
local fixXPGaining = {
    { item = "RippedSheets", xp = "Recipe.OnGiveXP.Tailoring1" },
    { item = "DenimStrips", xp = "Recipe.OnGiveXP.Tailoring3" },
    { item = "LeatherStrips", xp = "Recipe.OnGiveXP.Tailoring5" }
}

for _, recipeType in ipairs(fixXPGaining) do
    local recipes = getScriptManager():getAllRecipesFor(recipeType.item)
    for i = 0, recipes:size() - 1 do
        local recipe = recipes:get(i)
        if recipe:getOriginalname() == "Rip Clothing" then
            recipe:setLuaGiveXP(recipeType.xp)
        end
    end
end
for n, i in pairs(items_to_fix_cotton) do
    local item = ScriptManager.instance:getItem(i)
    if item then
        item:DoParam("FabricType = Cotton")
    end
end
for n, i in pairs(items_to_fix_denim) do
    local item = ScriptManager.instance:getItem(i)
    if item then
        item:DoParam("FabricType = Denim")
    end
end
for n, i in pairs(items_to_fix_leather) do
    local item = ScriptManager.instance:getItem(i)
    if item then
        item:DoParam("FabricType = Leather")
    end
end
for category, items in pairs(fix_category_items) do
    for _, itemName in ipairs(items) do
        local item = ScriptManager.instance:getItem(itemName)
        if item then
            item:DoParam("DisplayCategory = " .. category)
        end
    end
end