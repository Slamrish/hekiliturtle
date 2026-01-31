-- Compatibility.lua
-- Provides Classic/Vanilla WoW API compatibility layer for Turtle WoW
-- Replaces Retail C_* namespace functions with Classic equivalents

local addon, ns = ...
local Hekili = _G[addon]

-- Detect game version
local _, _, _, buildNum = GetBuildInfo()
-- Build number ranges:
-- Vanilla/Classic Era: < 20000
-- TBC Classic: 20000-29999
-- Wrath Classic: 30000-39999
-- Retail (Cata+): >= 40000
local isRetail = buildNum >= 90000
local isClassic = buildNum < 20000 or (buildNum >= 30000 and buildNum < 40000)
local isVanilla = buildNum < 20000

-- Set flavor for Turtle WoW (Vanilla-based)
if isVanilla or isClassic then
    Hekili.IsTurtleWoW = true
    Hekili.Flavor = "Classic"
end

-- ============================================================================
-- C_Spell API Compatibility
-- ============================================================================

if not C_Spell then
    C_Spell = {}
end

-- GetSpellCooldown wrapper
if not C_Spell.GetSpellCooldown then
    C_Spell.GetSpellCooldown = function(spellID)
        local start, duration, enabled, modRate = GetSpellCooldown(spellID)
        return {
            startTime = start or 0,
            duration = duration or 0,
            isEnabled = enabled ~= 0,
            modRate = modRate or 1
        }
    end
end

-- GetSpellCharges wrapper
if not C_Spell.GetSpellCharges then
    C_Spell.GetSpellCharges = function(spellID)
        -- Classic doesn't have native spell charge support
        -- Return nil to indicate no charge system
        return nil
    end
end

-- GetSpellInfo wrapper
if not C_Spell.GetSpellInfo then
    C_Spell.GetSpellInfo = function(spellID)
        local name, rank, icon, castTime, minRange, maxRange, id = GetSpellInfo(spellID)
        if name then
            return {
                name = name,
                iconID = icon,
                originalIconID = icon,
                castTime = castTime,
                minRange = minRange,
                maxRange = maxRange,
                spellID = id or spellID
            }
        end
        return nil
    end
end

-- GetSpellDescription wrapper
if not C_Spell.GetSpellDescription then
    C_Spell.GetSpellDescription = function(spellID)
        -- Classic doesn't have GetSpellDescription
        -- Use tooltip scanning as fallback
        return ""
    end
end

-- GetSpellTexture wrapper
if not C_Spell.GetSpellTexture then
    C_Spell.GetSpellTexture = function(spellID)
        local name, rank, icon = GetSpellInfo(spellID)
        return icon
    end
end

-- GetSpellLink wrapper
if not C_Spell.GetSpellLink then
    C_Spell.GetSpellLink = function(spellID)
        return GetSpellLink(spellID)
    end
end

-- GetSpellLossOfControlCooldown wrapper
if not C_Spell.GetSpellLossOfControlCooldown then
    C_Spell.GetSpellLossOfControlCooldown = function(spellID)
        -- Not available in Classic
        return 0, 0
    end
end

-- IsSpellUsable wrapper
if not C_Spell.IsSpellUsable then
    C_Spell.IsSpellUsable = function(spellID)
        local usable, noMana = IsUsableSpell(spellID)
        return usable, noMana
    end
end

-- IsCurrentSpell wrapper
if not C_Spell.IsCurrentSpell then
    C_Spell.IsCurrentSpell = function(spellID)
        return IsCurrentSpell(spellID)
    end
end

-- ============================================================================
-- C_UnitAuras API Compatibility
-- ============================================================================

if not C_UnitAuras then
    C_UnitAuras = {}
end

-- GetPlayerAuraBySpellID wrapper
if not C_UnitAuras.GetPlayerAuraBySpellID then
    C_UnitAuras.GetPlayerAuraBySpellID = function(spellID, filter)
        -- Search through buffs
        local index = 1
        while true do
            local name, icon, count, debuffType, duration, expirationTime, source, isStealable, 
                  nameplateShowPersonal, id, canApplyAura, isBossDebuff, isCastByPlayer,
                  nameplateShowAll, timeMod, value1, value2, value3 = UnitBuff("player", index)
            
            if not name then break end
            
            if id == spellID then
                return {
                    name = name,
                    icon = icon,
                    applications = count or 0,
                    dispelName = debuffType,
                    duration = duration or 0,
                    expirationTime = expirationTime or 0,
                    sourceUnit = source,
                    isStealable = isStealable,
                    nameplateShowPersonal = nameplateShowPersonal,
                    spellId = id,
                    canApplyAura = canApplyAura,
                    isBossAura = isBossDebuff,
                    isFromPlayerOrPlayerPet = isCastByPlayer,
                    nameplateShowAll = nameplateShowAll,
                    timeMod = timeMod or 1,
                    points = {value1, value2, value3}
                }
            end
            index = index + 1
        end
        
        -- Search through debuffs if not found in buffs
        index = 1
        while true do
            local name, icon, count, debuffType, duration, expirationTime, source, isStealable, 
                  nameplateShowPersonal, id, canApplyAura, isBossDebuff, isCastByPlayer,
                  nameplateShowAll, timeMod, value1, value2, value3 = UnitDebuff("player", index)
            
            if not name then break end
            
            if id == spellID then
                return {
                    name = name,
                    icon = icon,
                    applications = count or 0,
                    dispelName = debuffType,
                    duration = duration or 0,
                    expirationTime = expirationTime or 0,
                    sourceUnit = source,
                    isStealable = isStealable,
                    nameplateShowPersonal = nameplateShowPersonal,
                    spellId = id,
                    canApplyAura = canApplyAura,
                    isBossAura = isBossDebuff,
                    isFromPlayerOrPlayerPet = isCastByPlayer,
                    nameplateShowAll = nameplateShowAll,
                    timeMod = timeMod or 1,
                    points = {value1, value2, value3}
                }
            end
            index = index + 1
        end
        
        return nil
    end
end

-- GetBuffDataByIndex wrapper
if not C_UnitAuras.GetBuffDataByIndex then
    C_UnitAuras.GetBuffDataByIndex = function(unit, index, filter)
        local name, icon, count, debuffType, duration, expirationTime, source, isStealable, 
              nameplateShowPersonal, id, canApplyAura, isBossDebuff, isCastByPlayer,
              nameplateShowAll, timeMod, value1, value2, value3 = UnitBuff(unit, index, filter)
        
        if not name then return nil end
        
        return {
            name = name,
            icon = icon,
            applications = count or 0,
            dispelName = debuffType,
            duration = duration or 0,
            expirationTime = expirationTime or 0,
            sourceUnit = source,
            isStealable = isStealable,
            nameplateShowPersonal = nameplateShowPersonal,
            spellId = id,
            canApplyAura = canApplyAura,
            isBossAura = isBossDebuff,
            isFromPlayerOrPlayerPet = isCastByPlayer,
            nameplateShowAll = nameplateShowAll,
            timeMod = timeMod or 1,
            points = {value1, value2, value3}
        }
    end
end

-- GetDebuffDataByIndex wrapper
if not C_UnitAuras.GetDebuffDataByIndex then
    C_UnitAuras.GetDebuffDataByIndex = function(unit, index, filter)
        local name, icon, count, debuffType, duration, expirationTime, source, isStealable, 
              nameplateShowPersonal, id, canApplyAura, isBossDebuff, isCastByPlayer,
              nameplateShowAll, timeMod, value1, value2, value3 = UnitDebuff(unit, index, filter)
        
        if not name then return nil end
        
        return {
            name = name,
            icon = icon,
            applications = count or 0,
            dispelName = debuffType,
            duration = duration or 0,
            expirationTime = expirationTime or 0,
            sourceUnit = source,
            isStealable = isStealable,
            nameplateShowPersonal = nameplateShowPersonal,
            spellId = id,
            canApplyAura = canApplyAura,
            isBossAura = isBossDebuff,
            isFromPlayerOrPlayerPet = isCastByPlayer,
            nameplateShowAll = nameplateShowAll,
            timeMod = timeMod or 1,
            points = {value1, value2, value3}
        }
    end
end

-- ============================================================================
-- C_Item API Compatibility
-- ============================================================================

if not C_Item then
    C_Item = {}
end

-- GetItemCooldown wrapper
if not C_Item.GetItemCooldown then
    C_Item.GetItemCooldown = function(itemID)
        local start, duration, enabled = GetItemCooldown(itemID)
        return start or 0, duration or 0, enabled
    end
end

-- GetItemInfo wrapper
if not C_Item.GetItemInfo then
    C_Item.GetItemInfo = function(itemID)
        return GetItemInfo(itemID)
    end
end

-- GetItemSpell wrapper
if not C_Item.GetItemSpell then
    C_Item.GetItemSpell = function(itemID)
        local name, spellID = GetItemSpell(itemID)
        if name then
            return {
                name = name,
                spellID = spellID
            }
        end
        return nil
    end
end

-- IsUsableItem wrapper
if not C_Item.IsUsableItem then
    C_Item.IsUsableItem = function(itemID)
        return IsUsableItem(itemID)
    end
end

-- GetItemCount wrapper
if not C_Item.GetItemCount then
    C_Item.GetItemCount = function(itemID, includeBank, includeCharges)
        return GetItemCount(itemID, includeBank, includeCharges)
    end
end

-- IsCurrentItem wrapper
if not C_Item.IsCurrentItem then
    C_Item.IsCurrentItem = function(itemID)
        return IsCurrentItem(itemID)
    end
end

-- IsEquippedItem wrapper
if not C_Item.IsEquippedItem then
    C_Item.IsEquippedItem = function(itemID)
        return IsEquippedItem(itemID)
    end
end

-- GetItemInfoInstant wrapper
if not C_Item.GetItemInfoInstant then
    C_Item.GetItemInfoInstant = function(itemID)
        local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType,
              itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(itemID)
        if itemName then
            return itemID, itemType, itemSubType, itemEquipLoc, itemTexture, itemQuality
        end
        return nil
    end
end

-- GetDetailedItemLevelInfo wrapper
if not C_Item.GetDetailedItemLevelInfo then
    C_Item.GetDetailedItemLevelInfo = function(itemLocation)
        -- Not available in Classic, return defaults
        return 0, 0, 0
    end
end

-- ============================================================================
-- C_SpellBook API Compatibility
-- ============================================================================

if not C_SpellBook then
    C_SpellBook = {}
end

-- GetSpellBookItemInfo wrapper
if not C_SpellBook.GetSpellBookItemInfo then
    C_SpellBook.GetSpellBookItemInfo = function(index, bookType)
        local spellBank = bookType
        if type(bookType) == "number" then
            spellBank = (bookType == 1) and "spell" or "pet"
        end
        
        local name, rank, iconID, castTime, minRange, maxRange, spellID = GetSpellInfo(index, spellBank)
        if name then
            return {
                name = name,
                iconID = iconID,
                spellID = spellID,
                itemType = 1 -- SPELL
            }
        end
        return nil
    end
end

-- FindSpellBookSlotForSpell wrapper
if not C_SpellBook.FindSpellBookSlotForSpell then
    C_SpellBook.FindSpellBookSlotForSpell = function(spellID)
        -- Simple linear search through spellbook
        local i = 1
        while true do
            local name, rank = GetSpellInfo(i, "spell")
            if not name then break end
            
            local sid = select(7, GetSpellInfo(i, "spell"))
            if sid == spellID then
                return i, "spell"
            end
            i = i + 1
        end
        return nil, nil
    end
end

-- IsSpellInSpellBook wrapper
if not C_SpellBook.IsSpellInSpellBook then
    C_SpellBook.IsSpellInSpellBook = function(spellID)
        local slot, bank = C_SpellBook.FindSpellBookSlotForSpell(spellID)
        return slot ~= nil
    end
end

-- GetSpellBookItemName wrapper
if not C_SpellBook.GetSpellBookItemName then
    C_SpellBook.GetSpellBookItemName = function(index, bookType)
        local name = GetSpellInfo(index, bookType)
        return name
    end
end

-- ============================================================================
-- C_SpecializationInfo API Compatibility
-- ============================================================================

if not C_SpecializationInfo then
    C_SpecializationInfo = {}
end

-- GetSpecialization wrapper
if not C_SpecializationInfo.GetSpecialization then
    C_SpecializationInfo.GetSpecialization = function()
        return GetSpecialization()
    end
end

-- GetSpecializationInfo wrapper
if not C_SpecializationInfo.GetSpecializationInfo then
    C_SpecializationInfo.GetSpecializationInfo = function(specIndex)
        return GetSpecializationInfo(specIndex)
    end
end

-- GetTalentInfo wrapper
if not C_SpecializationInfo.GetTalentInfo then
    C_SpecializationInfo.GetTalentInfo = function(talentIndex, specIndex)
        -- Classic uses GetTalentInfo with different parameters
        if GetTalentInfo then
            return GetTalentInfo(talentIndex, specIndex)
        end
        return nil
    end
end

-- ============================================================================
-- Global Talent Functions Compatibility
-- ============================================================================

-- GetTalentInfoByID wrapper (Retail function)
if not GetTalentInfoByID then
    GetTalentInfoByID = function(talentID, specGroup)
        -- In Classic, talents work differently (tree-based, not choice-based)
        -- This is a stub that returns nil, which the calling code handles
        return nil
    end
end

-- IsPlayerSpell wrapper
if not IsPlayerSpell then
    IsPlayerSpell = function(spellID)
        -- Check if player knows the spell
        local name = GetSpellInfo(spellID)
        if not name then return false end
        
        -- Check spellbook
        local i = 1
        while true do
            local spellName = GetSpellInfo(i, "spell")
            if not spellName then break end
            
            local sid = select(7, GetSpellInfo(i, "spell"))
            if sid == spellID then
                return true
            end
            i = i + 1
        end
        
        return false
    end
end

-- ============================================================================
-- C_LossOfControl API Compatibility
-- ============================================================================

if not C_LossOfControl then
    C_LossOfControl = {}
    
    C_LossOfControl.GetActiveLossOfControlData = function(index)
        -- Not available in Classic
        return nil
    end
    
    C_LossOfControl.GetActiveLossOfControlDataCount = function()
        -- Not available in Classic
        return 0
    end
end

-- ============================================================================
-- C_AddOns API Compatibility
-- ============================================================================

if not C_AddOns then
    C_AddOns = {}
    
    C_AddOns.GetAddOnMetadata = function(addon, field)
        return GetAddOnMetadata(addon, field)
    end
    
    C_AddOns.IsAddOnLoaded = function(addon)
        return IsAddOnLoaded(addon)
    end
end

-- ============================================================================
-- AuraUtil Compatibility
-- ============================================================================

if not AuraUtil then
    AuraUtil = {}
end

if not AuraUtil.UnpackAuraData then
    AuraUtil.UnpackAuraData = function(data)
        if not data then return nil end
        return data.name, data.icon, data.applications, data.dispelName,
               data.duration, data.expirationTime, data.sourceUnit, data.isStealable,
               data.nameplateShowPersonal, data.spellId, data.canApplyAura, data.isBossAura,
               data.isFromPlayerOrPlayerPet, data.nameplateShowAll, data.timeMod,
               unpack(data.points or {})
    end
end

if not AuraUtil.FindAura then
    AuraUtil.FindAura = function(predicate, unit, filter)
        -- Search buffs
        local index = 1
        while true do
            local data = C_UnitAuras.GetBuffDataByIndex(unit, index, filter)
            if not data then break end
            
            local result = predicate(AuraUtil.UnpackAuraData(data))
            if result then
                return AuraUtil.UnpackAuraData(data)
            end
            index = index + 1
        end
        
        -- Search debuffs
        index = 1
        while true do
            local data = C_UnitAuras.GetDebuffDataByIndex(unit, index, filter)
            if not data then break end
            
            local result = predicate(AuraUtil.UnpackAuraData(data))
            if result then
                return AuraUtil.UnpackAuraData(data)
            end
            index = index + 1
        end
        
        return nil
    end
end

-- ============================================================================
-- C_Timer API Compatibility
-- ============================================================================

if not C_Timer then
    C_Timer = {}
    
    -- After wrapper
    C_Timer.After = function(duration, callback)
        -- Use the old-style timer in Classic
        local frame = CreateFrame("Frame")
        local elapsed = 0
        frame:SetScript("OnUpdate", function(self, delta)
            elapsed = elapsed + delta
            if elapsed >= duration then
                frame:SetScript("OnUpdate", nil)
                callback()
            end
        end)
        return frame
    end
    
    -- NewTimer wrapper (returns a cancelable timer)
    C_Timer.NewTimer = function(duration, callback)
        local frame = CreateFrame("Frame")
        local elapsed = 0
        local cancelled = false
        
        frame.Cancel = function()
            cancelled = true
            frame:SetScript("OnUpdate", nil)
        end
        
        frame:SetScript("OnUpdate", function(self, delta)
            if cancelled then return end
            elapsed = elapsed + delta
            if elapsed >= duration then
                frame:SetScript("OnUpdate", nil)
                if not cancelled then
                    callback()
                end
            end
        end)
        
        return frame
    end
    
    -- NewTicker wrapper (repeating timer)
    C_Timer.NewTicker = function(duration, callback, iterations)
        local frame = CreateFrame("Frame")
        local elapsed = 0
        local count = 0
        local cancelled = false
        
        frame.Cancel = function()
            cancelled = true
            frame:SetScript("OnUpdate", nil)
        end
        
        frame:SetScript("OnUpdate", function(self, delta)
            if cancelled then return end
            elapsed = elapsed + delta
            if elapsed >= duration then
                elapsed = 0
                count = count + 1
                callback()
                
                if iterations and count >= iterations then
                    frame:SetScript("OnUpdate", nil)
                end
            end
        end)
        
        return frame
    end
end

-- ============================================================================
-- C_PetBattles API Compatibility
-- ============================================================================

if not C_PetBattles then
    C_PetBattles = {}
    
    C_PetBattles.IsInBattle = function()
        -- Not available in Classic
        return false
    end
end

-- ============================================================================
-- C_SpellActivationOverlay API Compatibility
-- ============================================================================

if not C_SpellActivationOverlay then
    C_SpellActivationOverlay = {}
    
    C_SpellActivationOverlay.IsSpellOverlayed = function(spellID)
        -- Not available in Classic
        return false
    end
end

-- ============================================================================
-- Enum Compatibility
-- ============================================================================

if not Enum then
    Enum = {}
end

if not Enum.SpellBookSpellBank then
    Enum.SpellBookSpellBank = {
        Player = 0,
        Pet = 1
    }
end

if not Enum.SpellBookItemType then
    Enum.SpellBookItemType = {
        Spell = 1,
        None = 0,
        FlyOut = 2,
        FutureSpell = 3,
        PetAction = 4
    }
end

if not Enum.PowerType then
    Enum.PowerType = {
        HealthCost = -2,
        None = -1,
        Mana = 0,
        Rage = 1,
        Focus = 2,
        Energy = 3,
        ComboPoints = 4,
        Runes = 5,
        RunicPower = 6,
        SoulShards = 7,
        LunarPower = 8,
        HolyPower = 9,
        Alternate = 10,
        Maelstrom = 11,
        Chi = 12,
        Insanity = 13,
        Obsolete = 14,
        Obsolete2 = 15,
        ArcaneCharges = 16,
        Fury = 17,
        Pain = 18
    }
end

-- ============================================================================
-- Additional Helpers
-- ============================================================================

-- Action-based cooldown checking (for Turtle WoW)
ns.GetActionCooldown = function(slot)
    if not slot then return 0, 0, 0 end
    local start, duration, enabled = GetActionCooldown(slot)
    return start or 0, duration or 0, enabled or 0
end

-- Action usability checking (for Turtle WoW)
ns.IsActionUsable = function(slot)
    if not slot then return false, false end
    local usable, noMana = IsUsableAction(slot)
    return usable, noMana
end

-- Action range checking (for Turtle WoW)
ns.IsActionInRange = function(slot)
    if not slot then return nil end
    return IsActionInRange(slot)
end

-- Compatibility flag for other parts of the addon
ns.IsClassicAPI = isClassic or isVanilla
ns.IsTurtleWoW = Hekili.IsTurtleWoW or false

-- Note: Debug message removed to avoid initialization order issues
-- The compatibility layer is loaded before Hekili is fully initialized
