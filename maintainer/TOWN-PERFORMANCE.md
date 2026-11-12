# Town performance correction

The display translation wrapper previously searched a switch containing thousands of strings for every text draw. Text already translated in the data file still traversed the entire switch before falling through. The town's wanted posters and wrapped UI text made this expensive on the CPU.

`gml_Script_zh_display` now initializes a translation map once and uses indexed lookups thereafter. Unknown strings are returned unchanged and are not inserted into the map. Gameplay, quest timing, frame limits and movement speed are unchanged. The locale compiler emits the same implementation for future builds. Internal width-reference strings 1988 and 4007 remain original.

On November 12, 2026, an automated local Butterscotch comparison used the same Chinese data, auxiliary town save, seed/default settings and 600-frame run, changing only the display lookup. In the final 120-frame town sample, the profiler reported:

| GML time per frame | Before | After |
| --- | ---: | ---: |
| Display lookup | 34.04 ms | 0.04 ms |
| Total script execution | 39.80 ms | 5.68 ms |
| Executed instructions | 2,148,170 | 310,940 |

This demonstrates the script bottleneck and its removal in that local test. It is not a measured Android-device frame-rate claim or a full game walkthrough. Raw run logs are retained privately because testing uses the player's game data; the public distribution contains patch source only.

## r9: invisible town UI and nine-slice drawing

The translation lookup fix did not remove the thousands of transparent sprite tiles submitted by hidden poster panels. r9 skips zero-alpha panel/text drawing and reduces three verified flat skins to at most nine draws under nearest filtering. Linear filtering and unknown skins retain original tiling. Native Windows night-town sampling fell from 4.31491 to 0.40660 ms; local Android-ported GML time fell from 5.52 to 0.53 ms. 108 render pairs and both full night-town screenshot pairs match exactly. These are local results, not phone FPS claims. See R9-TOWN-RENDER-AUDIT.json and VALIDATION.md.