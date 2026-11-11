# Android touch input

The default layout provides a direction stick, Confirm, Back, Pause and Helper. Tap the game canvas to click; hold and move to drag. L/R select the canvas mouse button. Use L for ordinary clicking and dragging; use R when a game screen requests a right click. The layout can be adjusted in the runner menu.

`TouchDispatch.smali` and `patch-native-input.ps1` contain the complete frontend input modification for the pinned Butterscotch APK in `manifest.json`: cursor coordinates are delivered before button presses, one canvas pointer owns a drag, and pause/coroutine cancellation releases buttons. No original runner APK is redistributed here. The patch script checks its expected source anchors and fails if the upstream structure changes.

The frontend modification follows the upstream frontend's AGPL-3.0 licensing; see `licenses` and the upstream source information in the main README. `touch-icons.json` contains original, generated L/R button artwork as PNG data. The build installs these assets into the runner's layout sprite directory.

These source and assembly checks do not substitute for testing every phone or Android version.
