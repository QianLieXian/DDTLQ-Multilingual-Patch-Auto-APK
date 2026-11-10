# DDTLQ 2.01.04 简体中文补丁

适用于《Doki Doki Tri-Line Quest》2.01.04 Beta。GPT 按语境翻译并统一校对，包含剧情、菜单、道具、中文像素字体和可选助手。原游戏文件不随补丁发布。

从 [Releases](https://github.com/QianLieXian/DDTLQ-Chinese-Patch/releases) 下载补丁 ZIP，解压到原 Windows 游戏文件夹中。

- **Windows**：双击「一键汉化Windows.bat」，运行 `output/Windows-…` 内的游戏。
- **制作安卓 APK**：双击「一键制作安卓APK.bat」。只需原 Windows 的 `data.win` 和两个 `audiogroup*.dat`，不需要原版安卓 APK；成品在 `output/Android-PC-…`。首次需联网下载工具，制作期间请留出足够磁盘空间。
- **安卓触控**：左摇杆移动，右侧确认、返回，下方暂停；拖动方块直接触屏。上方中央「助手」为独立触控键，不会点击空白处打开。
- **助手**：F6 画廊全开，F7 加十万弧币，F8 持续回血回蓝，F10 原版调试，F11 生成任务末阶段存档，F12 读取。F9 或安卓上方中央「助手」打开/关闭菜单；方向键选择、确认执行、返回关闭，也可点按菜单行。菜单期间游戏按键隔离。

`saves` 附带工具生成的城镇任务末阶段存档，并非人工全流程通关存档。出生点已移到道路中央，读档增加碰墙脱困。图鉴、关卡和装备不冒充全部收集；观看全部 48 项画廊可用助手的独立开关。原作尚未完结，部分任务本来就是待续内容。

Windows 可双击「导入任务存档并全开画廊.bat」，会先备份旧存档。安卓包已附带该存档，在助手中点击「读取全任务状态副本」；需要导入、导出自己的存档时，从启动页进入「存档与设置」，在游戏条目中管理存档槽。

Windows 已进行菜单、对白、字体及存档读写测试。安卓采用 [Butterscotch](https://github.com/ButterscotchRunner/Butterscotch) 开源运行组件，属于移植测试版；已验证同一游戏数据在该组件中显示中文菜单，尚未完成安卓真机和全流程验证。运行组件自身设置页可能显示英文。

仅发布补丁、源文件和制作工具，**不会上传含游戏内容的完整 APK**。[原作购买页](https://kiwistate.itch.io/dokidoki-tri-line-quest) · [校验与限制](VALIDATION.md) · [开源许可](licenses/NOTICE.txt)
