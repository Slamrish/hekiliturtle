# Hekili for Turtle WoW

This is a modified version of the Hekili addon adapted for **Turtle WoW**, a private server running on Vanilla/Classic WoW mechanics (version 1.12).

## What Changed?

The original Hekili addon was designed for Retail WoW (The War Within, patch 11.x) and used modern APIs that don't exist in Vanilla WoW. This version has been adapted to work with Turtle WoW's Classic API environment.

### Major Changes

1. **API Compatibility Layer** (`Compatibility.lua`)
   - Replaces Retail C_* namespace functions with Classic equivalents
   - All `C_Spell.*`, `C_Item.*`, `C_UnitAuras.*` functions now work on Vanilla
   - Wraps functions like `GetSpellCooldown`, `GetItemCooldown`, `UnitBuff`, `UnitDebuff`

2. **Removed Retail-Only Content**
   - Disabled all expansion-specific content (BfA, Shadowlands, Dragonflight, The War Within)
   - Removed Retail-only classes:
     - **Monk** (all 3 specs)
     - **Demon Hunter** (both specs)
     - **Evoker** (all 3 specs)
   - Removed Retail-only systems (Azerite, Essences, Covenants, Conduits, etc.)

3. **Interface Version**
   - Changed from `110205` (The War Within) to `11200` (Vanilla 1.12)

## Supported Classes (Vanilla)

The following Vanilla WoW classes should be supported:

- **Death Knight** (if available on Turtle WoW) - Blood, Frost, Unholy
- **Druid** - Balance, Feral, Guardian, Restoration
- **Hunter** - Beast Mastery, Marksmanship, Survival
- **Mage** - Arcane, Fire, Frost
- **Paladin** - Holy, Protection, Retribution
- **Priest** - Discipline, Holy, Shadow
- **Rogue** - Assassination, Outlaw, Subtlety
- **Shaman** - Elemental, Enhancement, Restoration
- **Warlock** - Affliction, Demonology, Destruction
- **Warrior** - Arms, Fury, Protection

**Note:** Some class specs may require additional work to function properly in Vanilla, as the action priority lists were designed for modern WoW rotations.

## Installation

1. Download the addon
2. Extract to `World of Warcraft/_classic_/Interface/AddOns/`
3. Rename the folder to just `Hekili` if needed
4. Launch Turtle WoW client
5. Enable the addon at the character selection screen
6. Use `/hekili` to open configuration

## Known Limitations

### API Differences

Some features may not work perfectly due to fundamental differences between Retail and Vanilla:

1. **Spell Charges** - Vanilla doesn't have spell charge systems. The addon will handle this gracefully.
2. **Talent System** - Retail uses a choice-based talent system; Vanilla uses talent trees. The addon may not properly detect all talents.
3. **Action Priority Lists** - The SimulationCraft-based priority lists are designed for Retail rotations and may not be optimal for Vanilla.

### Missing Features

The following Retail features are not available in Vanilla and have been disabled:

- Azerite Powers
- Essences
- Covenants & Soulbinds
- Conduits
- Legendary effects (Shadowlands/Legion style)
- Pet battle integration
- Spell activation overlays
- Loss of control tracking
- Advanced item level detection

## Compatibility Layer Details

The `Compatibility.lua` file provides the following API translations:

### Spell APIs
- `C_Spell.GetSpellCooldown()` → `GetSpellCooldown()`
- `C_Spell.GetSpellInfo()` → `GetSpellInfo()` (with structure wrapping)
- `C_Spell.GetSpellTexture()` → Icon extraction from `GetSpellInfo()`
- `C_Spell.IsSpellUsable()` → `IsUsableSpell()`
- `C_Spell.IsCurrentSpell()` → `IsCurrentSpell()`

### Aura/Buff APIs
- `C_UnitAuras.GetPlayerAuraBySpellID()` → Manual `UnitBuff()`/`UnitDebuff()` iteration
- `C_UnitAuras.GetBuffDataByIndex()` → `UnitBuff()` with data wrapping
- `C_UnitAuras.GetDebuffDataByIndex()` → `UnitDebuff()` with data wrapping

### Item APIs
- `C_Item.GetItemCooldown()` → `GetItemCooldown()`
- `C_Item.GetItemInfo()` → `GetItemInfo()`
- `C_Item.IsUsableItem()` → `IsUsableItem()`
- `C_Item.GetItemCount()` → `GetItemCount()`

### Spellbook APIs
- `C_SpellBook.GetSpellBookItemInfo()` → `GetSpellInfo(index, bookType)`
- `C_SpellBook.FindSpellBookSlotForSpell()` → Manual spellbook iteration
- `C_SpellBook.IsSpellInSpellBook()` → Spellbook slot lookup

### Other APIs
- `C_SpecializationInfo.GetSpecialization()` → `GetSpecialization()`
- `C_AddOns.GetAddOnMetadata()` → `GetAddOnMetadata()`
- `AuraUtil.UnpackAuraData()` → Data structure unpacking
- `AuraUtil.FindAura()` → Predicate-based aura search

## Troubleshooting

### Addon Won't Load
- Check that the Interface version in `Hekili.toc` matches your client (should be `11200`)
- Ensure `Compatibility.lua` is being loaded before `Hekili.lua`
- Check for Lua errors with `/console scriptErrors 1` or install BugSack/BugGrabber

### No Recommendations Showing
- Make sure your specialization is supported (not Monk/DH/Evoker)
- Check if there are Lua errors in the chat window
- Try `/hekili` to configure displays
- Some specs may need custom priority lists for Vanilla rotations

### Errors About Missing Functions
- This usually means a Retail API wasn't properly wrapped
- Please report the specific error message
- As a workaround, you may need to disable certain features

## Development Notes

### Adding Vanilla-Specific Priority Lists

If you want to create optimized priority lists for Vanilla rotations:

1. The addon currently loads class definitions from legacy expansion folders (TBC, Wrath, Cataclysm, Legion)
2. For true Vanilla-optimized rotations, you would need to create new class spec files
3. These should be placed in a new folder (e.g., `Vanilla/`) and referenced in the TOC file
4. Use SimulationCraft-style syntax
5. Reference only spells/abilities available in Vanilla
6. Test thoroughly in-game

**Note:** The existing priority lists may not be optimal for Vanilla WoW as they were designed for much later expansions with different mechanics.

### Adding Missing API Wrappers

If you encounter a missing Retail API:

1. Edit `Compatibility.lua`
2. Add a wrapper function that provides Vanilla-equivalent functionality
3. Test the addon loads without errors
4. Submit a pull request with your changes

## Reporting Issues

When reporting issues specific to Turtle WoW:

1. Include your exact Turtle WoW version/build number
2. Note which class/spec you're playing
3. Provide any Lua errors (use BugSack/BugGrabber)
4. Describe what you expected vs. what happened
5. Include a `/hekili snapshot` if possible

## Credits

- Original **Hekili** addon by Hekili, Syrif, and contributors
- Turtle WoW compatibility adaptation
- Based on logic from [SimulationCraft](https://www.simulationcraft.org/)
- Uses [Ace3](https://www.wowace.com/projects/ace3) libraries

## License

This adaptation maintains the same license as the original Hekili addon.

---

**Note:** This is an unofficial adaptation for Turtle WoW. The original addon development ended with Midnight (patch 12.0). This version is maintained separately for the Classic/Vanilla community.
