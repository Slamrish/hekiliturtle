# Installation and Testing Checklist for Turtle WoW

## Pre-Installation
- [ ] Download the addon files
- [ ] Verify you're using Turtle WoW client (Vanilla 1.12)
- [ ] Backup any existing Hekili installation (if applicable)

## Installation Steps
1. [ ] Locate your Turtle WoW installation directory
2. [ ] Navigate to `_classic_/Interface/AddOns/` (create if doesn't exist)
3. [ ] Extract/copy addon files to `AddOns/Hekili/`
4. [ ] Verify these files exist:
   - [ ] `Hekili.toc` (Interface version should be 11200)
   - [ ] `Compatibility.lua`
   - [ ] `Hekili.lua`
   - [ ] `TURTLE_WOW_README.md`
   - [ ] `MIGRATION_SUMMARY.md`

## First Launch
5. [ ] Start Turtle WoW client
6. [ ] At character selection screen, click "AddOns" button
7. [ ] Verify "Hekili (Turtle WoW Edition)" appears in addon list
8. [ ] Enable the addon (check the box)
9. [ ] Enable "Load out of date AddOns" if prompted
10. [ ] Log in with a character

## Initial Verification
11. [ ] Watch for Lua errors in chat window
    - If errors appear, press Escape and type `/console scriptErrors 1`
    - Take screenshots of any errors
12. [ ] Check if Hekili minimap icon appears
13. [ ] Type `/hekili` to open configuration
14. [ ] Verify the configuration panel opens without errors

## UI Testing
15. [ ] Check main display visibility:
    - [ ] Primary display shows
    - [ ] Display is positioned correctly
    - [ ] Icons are visible
16. [ ] Enter combat (attack a mob)
17. [ ] Verify ability recommendations appear
18. [ ] Verify recommendations update as you use abilities

## Functionality Testing

### Cooldown Tracking
19. [ ] Use an ability with a cooldown
20. [ ] Verify cooldown is displayed correctly
21. [ ] Verify cooldown timer counts down properly

### Buff/Debuff Detection
22. [ ] Cast a buff on yourself
23. [ ] Verify Hekili recognizes the buff
24. [ ] Apply a debuff to a target
25. [ ] Verify Hekili recognizes the debuff

### Resource Tracking
26. [ ] Check that your resource bar (mana/rage/energy) updates
27. [ ] Verify resource values match your action bar display
28. [ ] Use an ability that costs resources
29. [ ] Verify resource deduction is tracked

### Spec-Specific
30. [ ] Verify your class is supported (NOT Monk/DH/Evoker)
31. [ ] Verify your spec displays correctly
32. [ ] Check spec-specific abilities appear in recommendations

## Configuration Testing
33. [ ] Open `/hekili` settings
34. [ ] Navigate to Displays tab
35. [ ] Verify display options load without errors
36. [ ] Try adjusting display size
37. [ ] Try adjusting display position
38. [ ] Verify changes apply correctly

## Class-Specific Checks

### For Casters (Mage, Warlock, Priest, etc.)
- [ ] Mana tracking works
- [ ] Spell cooldowns display correctly
- [ ] Cast time predictions show properly

### For Melee (Warrior, Rogue, etc.)
- [ ] Energy/Rage tracking works
- [ ] Auto-attack tracking functions
- [ ] Combo points display (Rogue)

### For Hybrid Classes (Paladin, Druid, Shaman)
- [ ] Mana tracking works
- [ ] Shapeshifting tracked correctly (Druid)
- [ ] Seal tracking works (Paladin)
- [ ] Totem tracking works (Shaman)

## Known Issues Check
40. [ ] Review TURTLE_WOW_README.md "Known Limitations" section
41. [ ] Note which features are expected NOT to work
42. [ ] Verify expected limitations match your experience

## Performance Testing
43. [ ] Check FPS before combat: _____ FPS
44. [ ] Check FPS during combat: _____ FPS
45. [ ] Verify no significant FPS drop
46. [ ] Check for UI stuttering or freezing

## Troubleshooting (if issues found)

### Lua Errors
- [ ] Install BugSack and BugGrabber addons
- [ ] Reproduce the error
- [ ] Open BugSack (`/bugsack`)
- [ ] Copy error details
- [ ] Report to GitHub Issues with:
  - Error message
  - Your class/spec
  - What you were doing
  - Turtle WoW build number

### Display Issues
- [ ] Try `/hekili` → Displays → Reset All
- [ ] Disable other UI addons temporarily
- [ ] Check for conflicting keybinds
- [ ] Verify screen resolution settings

### Performance Issues
- [ ] Check other addon memory usage (`/hekili` → Dev Tools)
- [ ] Try reducing display icons shown
- [ ] Disable unused displays (AoE, Cooldowns, etc.)

## Advanced Testing (Optional)

### Priority List Testing
- [ ] Test rotation in solo combat
- [ ] Test rotation in group content
- [ ] Compare to known Vanilla optimal rotations
- [ ] Note any obviously wrong recommendations

### Edge Cases
- [ ] Test with low resources (mana/rage/energy)
- [ ] Test with multiple targets
- [ ] Test with buffs/debuffs active
- [ ] Test with trinkets equipped
- [ ] Test with off-spec gear

## Reporting Results

### If Everything Works
- [ ] Post success report in GitHub Discussions
- [ ] Include: Class, Spec, Turtle WoW version
- [ ] Share any optimization tips discovered

### If Issues Found
- [ ] Create GitHub Issue
- [ ] Use template from TURTLE_WOW_README.md
- [ ] Include all requested information
- [ ] Attach screenshots if relevant

## Version Info to Report
- Addon Version: `@project-version@` (or Dev build)
- Turtle WoW Build: ____________
- Your Class: ____________
- Your Spec: ____________
- Test Date: ____________

## Additional Notes
Use this space to record any observations:

```
[Your notes here]
```

---

## Quick Reference Commands
- `/hekili` - Open settings
- `/hekili toggle` - Toggle displays on/off
- `/hekili snapshot` - Generate debug snapshot
- `/console scriptErrors 1` - Enable error display
- `/bugsack` - View Lua errors (requires BugSack)

## Support Resources
- Full Documentation: `TURTLE_WOW_README.md`
- Technical Details: `MIGRATION_SUMMARY.md`
- GitHub Issues: https://github.com/Slamrish/hekiliturtle/issues
- Original Hekili Wiki: https://github.com/Hekili/hekili/wiki (for general guidance)

---

*Checklist Version 1.0 - Updated 2026-01-31*
