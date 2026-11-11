# Doki Doki Tri-Line Quest / DDTLQ 汉化与多语言补丁 · Windows & Android

**《Doki Doki Tri-Line Quest》（DDTLQ）2.01.04 Beta 非官方本地化项目。** 提供 Windows 汉化、语言选择安装器，以及使用自己原版游戏文件制作 Android APK 的工具。

Unofficial **Doki Doki Tri-Line Quest translation patches and Android APK builder**, with a 10-language installer for Windows and local Android builds.

[English](README.en.md) · [下载正式 Latest](https://github.com/QianLieXian/DDTLQ-Chinese-Patch/releases/latest) · [原作购买页](https://kiwistate.itch.io/dokidoki-tri-line-quest) · [反馈问题](https://github.com/QianLieXian/DDTLQ-Chinese-Patch/issues)

> **当前状态：** 正式版为中文 r5。8 种新增语言的正文和界面译稿均已按 ID 收齐，正在统一校对、字体检查和构建验证。未就绪语言会明确标记并阻止安装。多语言版尚未发布正式 Release。

## 一键安装

当前正式 r5 压缩包使用 **“一键汉化Windows.bat”** 和 **“一键制作安卓APK.bat”**，只提供中文；下面的新语言选择入口属于开发中的多语言包。

**Windows：** 完整解压补丁，双击 **WindowsPatch.bat**，输入语言编号，按回车。按提示拖入原版游戏目录，也可以直接把游戏文件夹拖到 BAT 上。完成后运行 `output` 新副本里的游戏，原游戏文件保持原样。

**Android：** 双击 **Build-APK.bat**，选择语言和同一个原版 Windows 游戏目录。首次自动下载并校验便携工具和开源运行组件，签名 APK 生成在 `output`。**不需要原版安卓 APK，也不需要安装开发环境。**

仅适用于校验匹配的 2.01.04 Beta；同名版本、其他发行包或第三方 MOD 不一定兼容。Windows 需要 PowerShell 5.1；安卓需要 **Android 7 及以上、ARM64**。

## 语言菜单

| 编号 | 语言 | 文本来源与进度 |
| --- | --- | --- |
| 1 | 简体中文 | 沿用已审校中文补丁 |
| 2 | English | 原版文本；新增助手界面为英文 |
| 3 | Português (Brasil) | 审校、字体和本地构建已通过，待正式发布 |
| 4 | Русский | 译稿收齐，统一审校中 |
| 5 | Español | 译稿收齐，统一审校中 |
| 6 | Deutsch | 译稿收齐，统一审校中 |
| 7 | 日本語 | 审校、字体和本地构建已通过，待正式发布 |
| 8 | Français | 译稿收齐，统一审校中 |
| 9 | 한국어 | 译稿收齐，统一审校中 |
| 10 | Türkçe | 译稿收齐，统一审校中 |

语言数量及顺序与 [Hole Dweller 多语言项目](https://github.com/QianLieXian/HoleDweller-zhCN-Auto-APK) 一致。每种目标语言包含 **4,890 条核心文本和 52 条助手、存档提示及安卓界面文案**。新增译稿主要通过 GPT-6 High 聊天模式做语境翻译；单独补译条目记录具体来源。条目、占位符、字体和构建通过校验后才开放安装。未宣称经过全部母语审校或全剧情通关测试。

## 安卓触控与作弊助手

左摇杆移动，右侧确认和返回，下方暂停，上方中央 **“助手”** 打开菜单。支持直接点选，以及方向、确认、返回按键操作。

助手提供图鉴、CG 画廊显示开关，弧币、回血回蓝、原版调试，以及生成和读取资源副本。Windows 快捷键：F5 图鉴、F6 画廊、F7 弧币、F8 恢复、F9 助手、F10 调试、F11 生成副本、F12 读取副本。

中文 APK 保留既有包名，便于覆盖更新；其他语言使用独立包名和存档。安卓存档从启动页 **“存档与设置”** 导入，再到游戏标题页读取。

## 存档与 CG

附带 **可继续剧情的城镇资源辅助档，不是全流程通关档**。图鉴和画廊使用独立显示开关，不强改任务完成状态。

Windows 运行 **“导入城镇辅助存档.bat”**，旧档会先备份。安卓可以使用 **“助手 → 读取辅助副本”**；只有实际切换场景并恢复人物坐标后才提示成功。导入自己的外部存档前也请备份。

## 常见问题

**DDTLQ 汉化补丁在哪里下载？** 进入上方正式 Latest，下载补丁附件并完整解压。不要只下载一个 BAT。

**有没有 Doki Doki Tri-Line Quest 安卓版 APK 下载？** 这里提供本地 APK 打包器，玩家使用自己拥有的兼容 Windows 游戏生成。公开仓库和 Releases 不提供完整游戏 APK。

**有方框、物品名错误或闪退怎么办？** 反馈语言、补丁版本、设备和具体界面；启动页可以查看或复制本地错误报告，记录不会自动上传。

**为什么某个语言不能安装？** 译稿或验证尚未完成，安装器会明确提示。开发进度不会冒充已完成的正式版本。

## 发布与许可

只发布补丁、翻译、配置和教程，**不包含原游戏、音频、CG 或完整 APK**。原作内容归原作者所有，请从作者页面取得游戏。新发布默认使用正式 **Latest**。

[校验记录](VALIDATION.md) · [字体与开源组件许可](licenses/NOTICE.txt)
