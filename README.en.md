# Doki Doki Tri-Line Quest (DDTLQ) — Multilingual Patch & Android APK Builder

Unofficial translation patches for **DDTLQ 2.01.04 Beta**, with language-select Windows installers and a local Android APK builder.

[简体中文](README.md) · [English](README.en.md) · [Português](README.pt-BR.md) · [Русский](README.ru.md) · [Español](README.es.md) · [Deutsch](README.de.md) · [日本語](README.ja.md) · [Français](README.fr.md) · [한국어](README.ko.md) · [Türkçe](README.tr.md)

[Download Latest](https://github.com/QianLieXian/DDTLQ-Multilingual-Patch-Auto-APK/releases/latest) · [Get the original game](https://kiwistate.itch.io/dokidoki-tri-line-quest)

## Install

- **Windows:** extract the complete patch, run `WindowsPatch.bat`, select a language, press Enter and provide your original game folder. Run the new copy under `output`.
- **Android:** on Windows, run `Build-APK.bat`, select a language, press Enter and provide the same original Windows game folder. Tools download and verify automatically; copy the signed APK from `output` to your phone. **No original Android APK or separately installed development environment is required.**

Requires the checksum-matching original **2.01.04 Beta**, Windows PowerShell 5.1 for building, and **Android 7+, ARM64** for playing. The original game files are preserved.

## Languages

**1 简体中文 · 2 English · 3 Português (Brasil) · 4 Русский · 5 Español · 6 Deutsch · 7 日本語 · 8 Français · 9 한국어 · 10 Türkçe**

Each locale is checked against 4,890 core entries and 52 added interface entries. English retains the original game text. Other locales use contextual AI translation and editorial review, without machine-translation services. The eight new drafts were primarily produced in GPT-6 High Chat; Codex review and separately supplemented entries record their actual provenance. Native-speaker approval and complete walkthrough testing are not claimed.

## Touch, helper and saves

Move with the left stick; Confirm/Back are on the right, Pause below, and Helper at the top. Tap the canvas to click and hold/move to drag. **L/R** select the canvas mouse button; use L for normal clicking and dragging. The runner menu allows layout adjustments.

The helper provides gallery/bestiary display toggles, resources, regeneration, original debug mode and save copies. Desktop shortcuts: F5 bestiary, F6 gallery, F7 money, F8 regeneration, F9 helper, F10 debug, F11 save copy, F12 load copy. Display unlocks do not complete story quests.

The included auxiliary save preserves story progression and starts in the town. Windows uses `导入城镇辅助存档.bat`; Android supports save import on the launcher or loading the supplied copy through Helper. Loading reports success after the destination scene is entered. Chinese updates retain the existing application ID; other languages have separate IDs and saves.

## Town performance

Display translation now uses an indexed lookup instead of repeatedly searching thousands of cases. A local same-save town comparison reduced total GML script time from approximately 39.8 to 5.7 ms/frame. This is not an Android-device frame-rate guarantee. [Method and limitations](maintainer/TOWN-PERFORMANCE.md).

## Distribution

Public downloads contain **patch source, translations, configuration and instructions only**. Original game files, audio, CG and complete game APKs are excluded. Obtain a compatible original game and build locally. Public versions use regular Latest releases.

[Validation](VALIDATION.md) · [License notices](licenses/NOTICE.txt) · [Touch patch source](android/TOUCH-PATCH.md)
