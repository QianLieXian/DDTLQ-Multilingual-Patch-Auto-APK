# Doki Doki Tri-Line Quest (DDTLQ) Translation Patch & Android APK Builder

Unofficial localization tools for **Doki Doki Tri-Line Quest 2.01.04 Beta**. Install a language patch on Windows, or build an Android APK locally from your own compatible Windows game files.

[简体中文](README.md) · [Latest stable release](https://github.com/QianLieXian/DDTLQ-Multilingual-Patch-Auto-APK/releases/latest) · [Original game](https://kiwistate.itch.io/dokidoki-tri-line-quest) · [Report a problem](https://github.com/QianLieXian/DDTLQ-Multilingual-Patch-Auto-APK/issues) · [Multilingual source and progress](https://github.com/QianLieXian/DDTLQ-Multilingual-Patch-Auto-APK/tree/multilingual)

**Development status:** the published stable release is the Chinese r5 patch. Drafts for all eight new languages have been collected by actual ID; unified review, font checks, and builds are still in progress. Portuguese and Japanese have passed review, font compilation, and local builds. Unfinished languages remain unavailable. The multilingual version has no formal release yet.

## Windows installation

The current stable r5 archive is Chinese-only and uses `一键汉化Windows.bat` and `一键制作安卓APK.bat`. The language-selecting entry points below belong to the multilingual development package.

Extract the complete patch archive, run **WindowsPatch.bat**, enter a language number, and press Enter. Provide your original game folder when prompted, or drag that folder onto the BAT. Run the new game copy under `output`. The original files stay intact.

Only the supported, checksum-matching 2.01.04 Beta game data is accepted. Other builds and third-party modifications are rejected. Windows PowerShell 5.1 is sufficient; pinned portable tools download on first use.

## Android APK builder

Run **Build-APK.bat**, choose a language, and provide the same original Windows game folder. The builder verifies its tool downloads and creates a signed APK under `output`. You do not need an original Android APK or a separately installed development environment.

Requirements: **Android 7 or later, ARM64**. The Chinese edition keeps its existing application ID for updates; other languages use separate application IDs and separate saves. Import saves through **Saves and settings** on the launch page, then load from the game title screen.

Controls: left joystick to move, Confirm and Back on the right, Pause near the bottom, and **Helper** at the top center. The Helper menu provides gallery/bestiary view toggles, resources, regeneration, original debug mode, and save-copy actions. These do not mark story quests complete.

## Languages

Menu order: **1 简体中文 · 2 English · 3 Português (Brasil) · 4 Русский · 5 Español · 6 Deutsch · 7 日本語 · 8 Français · 9 한국어 · 10 Türkçe**.

English preserves the original game text. Chinese uses the existing reviewed patch. The eight new translations were primarily produced through **GPT-6 High in Chat mode**, with 4,890 core entries and 52 added interface entries per language. Separately supplemented entries record their actual origin. A language is enabled only after checking text completeness, placeholders, font coverage, and the build. Native-speaker review and complete walkthrough testing are not claimed.

## Saves and troubleshooting

The supplied save is a **safe city resource save**, not a fully story-cleared save. The Windows importer backs up old saves. On Android, use **Helper → Load helper copy** for the supplied auxiliary slot. Loading is reported as successful only after the destination scene and player position have been restored.

Report the language, patch version, device, and affected screen if you encounter missing glyphs, wrong item names, or a crash. Local error reports can be viewed or copied from the launcher; they are not uploaded automatically.

## Downloads and ownership

This repository and its Releases contain **patch source, translations, configuration, and instructions only**. They do not include the original game, audio, CG, or complete game APKs. Obtain the game from its author and build your APK locally.

New public versions use regular **Latest** releases. Development work is not advertised as a finished multilingual release. [License notices](licenses/NOTICE.txt) · [Validation](VALIDATION.md)
