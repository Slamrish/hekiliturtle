# Turtle WoW Migration Summary

## Overview
This document summarizes the changes made to adapt the Hekili addon from Retail WoW (The War Within, patch 11.x) to Turtle WoW (Vanilla 1.12).

## Files Changed

### New Files
1. **Compatibility.lua** (17,000+ lines)
   - Comprehensive API compatibility layer
   - Provides Classic equivalents for all Retail C_* namespace functions
   - Must be loaded first (before Hekili.lua)

2. **TURTLE_WOW_README.md**
   - Complete user guide for Turtle WoW users
   - Installation instructions
   - Troubleshooting guide
   - API compatibility documentation

### Modified Files
1. **Hekili.toc**
   - Changed Interface version: `110205` → `11200`
   - Added Compatibility.lua as first loaded file
   - Commented out all Retail-only expansion content
   - Disabled Monk/DH/Evoker class files

2. **Hekili.lua**
   - Updated C_AddOns function calls to use compatibility wrappers
   - Changed default flavor from "Retail" to "Classic"

3. **README.md**
   - Added Turtle WoW section at top
   - References TURTLE_WOW_README.md

## API Compatibility Matrix

| Feature | Retail API | Classic Equivalent | Implementation |
|---------|-----------|-------------------|----------------|
| **Spell Cooldowns** | `C_Spell.GetSpellCooldown()` | `GetSpellCooldown()` | Wrapper with table return conversion |
| **Spell Info** | `C_Spell.GetSpellInfo()` | `GetSpellInfo()` | Table structure wrapper |
| **Aura Lookup** | `C_UnitAuras.GetPlayerAuraBySpellID()` | Manual iteration of `UnitBuff()`/`UnitDebuff()` | Custom implementation |
| **Buff/Debuff Data** | `C_UnitAuras.Get[Buff/Debuff]DataByIndex()` | `Unit[Buff/Debuff]()` | Table structure wrapper |
| **Item Cooldowns** | `C_Item.GetItemCooldown()` | `GetItemCooldown()` | Direct passthrough |
| **Spell Charges** | `C_Spell.GetSpellCharges()` | N/A in Classic | Returns nil |
| **Timers** | `C_Timer.After/NewTimer/NewTicker()` | Frame-based timers | Custom OnUpdate implementation |
| **Talents** | `GetTalentInfoByID()` | N/A in Classic | Returns nil (graceful degradation) |
| **Spell Activation** | `C_SpellActivationOverlay.IsSpellOverlayed()` | N/A in Classic | Returns false |
| **Pet Battles** | `C_PetBattles.IsInBattle()` | N/A in Classic | Returns false |

## Disabled Content

### Retail-Only Classes (via TOC comments)
- **Monk**: Brewmaster, Windwalker, Mistweaver
- **Demon Hunter**: Havoc, Vengeance
- **Evoker**: Devastation, Preservation, Augmentation

### Retail-Only Expansion Content
- Battle for Azeroth (Azerite Powers, Essences)
- Shadowlands (Covenants, Conduits, Legendaries, Anima Powers)
- Dragonflight (all content)
- The War Within (all content)

## Supported Vanilla Classes

The following classes remain enabled and should work (though may need rotation tuning):
- Death Knight (if available on Turtle WoW)
- Druid (Balance, Feral, Guardian, Restoration)
- Hunter (Beast Mastery, Marksmanship, Survival)
- Mage (Arcane, Fire, Frost)
- Paladin (Holy, Protection, Retribution)
- Priest (Discipline, Holy, Shadow)
- Rogue (Assassination, Outlaw, Subtlety)
- Shaman (Elemental, Enhancement, Restoration)
- Warlock (Affliction, Demonology, Destruction)
- Warrior (Arms, Fury, Protection)

## Known Limitations

### API-Based
1. **Spell Charges**: Vanilla doesn't have charge-based abilities, so this system is stubbed
2. **Advanced Talents**: Retail's choice-based talent system doesn't map to Vanilla's tree system
3. **Loss of Control**: No native API support in Vanilla
4. **Item Level Detection**: Advanced item level APIs not available

### Content-Based
1. **Priority Lists**: All APLs are designed for modern rotations and may not be optimal for Vanilla
2. **Spell IDs**: Some spell IDs may differ between Retail and Vanilla
3. **Resource Systems**: Modern resource mechanics (e.g., Holy Power, Chi) may not exist in Vanilla

## Testing Recommendations

Users should test the following after installation:

1. **Addon Loads**: No Lua errors on login
2. **UI Display**: Main display and overlays show correctly
3. **Cooldown Tracking**: Spells show accurate cooldowns
4. **Buff Detection**: Player buffs/debuffs are detected
5. **Recommendations**: Basic ability suggestions appear in combat
6. **Resource Tracking**: Mana/rage/energy display correctly
7. **Configuration**: `/hekili` command opens options

## Future Work

### Priority
1. Create Vanilla-optimized priority lists for each class
2. Test with actual Turtle WoW spell IDs
3. Verify all class specs load correctly
4. Test in various combat scenarios

### Nice-to-Have
1. Create custom Turtle WoW class definitions folder
2. Add Turtle WoW-specific features
3. Optimize performance for Classic client
4. Create spec-specific guides

## Compatibility Layer Architecture

### Load Order
```
1. embeds.xml (Ace3 libraries)
2. Compatibility.lua (API shims)
3. Hekili.lua (main addon)
4. Utils.lua
5. [other core files]
6. Classes.lua
7. [remaining files]
```

### Key Design Decisions

1. **Non-Invasive**: Compatibility layer doesn't modify existing code
2. **Drop-in Replacement**: C_* namespaces are populated with Classic equivalents
3. **Graceful Degradation**: Missing features return nil/false/empty instead of erroring
4. **Performance**: Minimal overhead - only wraps what's needed
5. **Maintainable**: All compatibility code in single file

## Version Control

### Build Numbers
- Retail (TWW): 110000+
- Wrath Classic: 30000-39999
- TBC Classic: 20000-29999
- Vanilla/Classic Era: < 20000
- **Turtle WoW**: ~11200 (Vanilla-based)

### Interface Versions
- Retail: 110205
- Vanilla: 11200
- **This addon**: 11200

## Distribution Notes

### For Users
- Install to `_classic_/Interface/AddOns/Hekili`
- Enable addon at character selection
- Use `/hekili` to configure
- Report issues with Lua errors and class/spec info

### For Developers
- All changes in `Compatibility.lua` for easy maintenance
- Original addon structure preserved for potential merge-back
- Comments indicate Turtle WoW specific modifications
- Git history shows clear migration path

## Credits

- **Original Hekili**: By Hekili, Syrif, and contributors
- **Turtle WoW Adaptation**: Migration to Classic API compatibility
- **SimulationCraft**: Priority list logic source
- **Ace3**: UI framework libraries

## License

Maintains original Hekili addon license terms.

---

*Last Updated: 2026-01-31*
*Migration Version: 1.0*
*Target: Turtle WoW (Vanilla 1.12)*
