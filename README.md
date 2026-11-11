# Doki Doki Tri-Line Quest (DDTLQ) 多语言补丁与 Android APK 打包器

《Doki Doki Tri-Line Quest》2.01.04 Beta 非官方多语言补丁。Windows 一键选择语言安装，也能使用自己的原版 Windows 游戏自动制作安卓 APK。

[简体中文](README.md) · [English](README.en.md) · [Português](README.pt-BR.md) · [Русский](README.ru.md) · [Español](README.es.md) · [Deutsch](README.de.md) · [日本語](README.ja.md) · [Français](README.fr.md) · [한국어](README.ko.md) · [Türkçe](README.tr.md)

[下载正式 Latest](https://github.com/QianLieXian/DDTLQ-Multilingual-Patch-Auto-APK/releases/latest) · [取得原作](https://kiwistate.itch.io/dokidoki-tri-line-quest) · [反馈问题](https://github.com/QianLieXian/DDTLQ-Multilingual-Patch-Auto-APK/issues)

## 使用

完整解压补丁后，按用途运行：

- **电脑：** 双击 `WindowsPatch.bat`，选择语言编号、回车，指定原版游戏文件夹。运行 `output` 中的新游戏副本。
- **安卓：** 在电脑双击 `Build-APK.bat`，选择语言编号、回车，指定同一个原版 Windows 游戏文件夹。自动准备工具、打包并签名，将 `output` 中的 APK 复制到手机安装。**无需原版安卓 APK。**

首次需要联网下载并校验工具。支持指定校验值的 **2.01.04 Beta** 原版，其他版本会拒绝处理。电脑需 Windows PowerShell 5.1；手机需 **Android 7+、ARM64**。原游戏文件保持原样。

## 十种语言

**1 简体中文 · 2 English · 3 Português (Brasil) · 4 Русский · 5 Español · 6 Deutsch · 7 日本語 · 8 Français · 9 한국어 · 10 Türkçe**

语言数量和顺序与 [Hole Dweller 项目](https://github.com/QianLieXian/HoleDweller-zhCN-Auto-APK) 一致。每种语言按 **4,890 条核心文本、52 条附加界面文本**核对。英文保留原文；其他译文采用 AI 语境翻译及统一校对，没有调用机器翻译服务。新增八种语言的初稿主要来自 GPT-6 High 聊天模式，后续 Codex 审校和个别补译记录在各语言来源文件中。未宣称母语人工审校或全剧情通关无误。

## 触控、作弊与存档

左摇杆移动，右侧确认/返回，下方暂停，上方中央打开助手。直接点击画面相当于鼠标点击，按住移动可拖动；顶部 **L / R** 切换左/右鼠标键，普通点击和拖动用 L。运行组件菜单可调整布局。助手只在明确按下对应按钮时操作，拖动经过菜单不算点击。

助手提供图鉴、CG 画廊显示开关，弧币、回血回蓝、原版调试及资源副本。电脑快捷键：F5 图鉴、F6 画廊、F7 弧币、F8 恢复、F9 助手、F10 调试、F11 生成副本、F12 读取副本。

附带的是**可继续剧情的城镇资源辅助档**。图鉴、CG 使用独立显示开关，不强制完成剧情。Windows 可运行 `导入城镇辅助存档.bat`；安卓可从启动页导入自己的存档，或用“助手 → 读取辅助副本”。旧档会备份，成功提示需等待实际进入目标场景。中文包可覆盖旧中文版本，其他语言使用独立包名和存档。

## 城镇卡顿修复

移除了每次文字绘制时遍历数千条翻译分支的开销。本地同存档城镇测试中，脚本耗时由约 39.8 降至 5.7 毫秒/帧；这不是所有手机的帧率保证。[测试方法与限制](maintainer/TOWN-PERFORMANCE.md)。

## 下载与许可

仓库和 Releases **只提供补丁、翻译、配置及教程，不提供原游戏、音频、CG 或完整游戏 APK**。请自行取得兼容原作；APK 仅在本地生成。正式版本发布为 Latest。

[校验与测试限制](VALIDATION.md) · [字体及开源组件许可](licenses/NOTICE.txt) · [Android 触控修改源码说明](android/TOUCH-PATCH.md)
