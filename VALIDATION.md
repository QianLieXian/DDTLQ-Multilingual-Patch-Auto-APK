# 校验记录

## r7 多语言与手柄

- 本轮重点校对葡语、俄语、西语、德语、日语、法语、韩语和土耳其语，修订391条：日语321、土耳其语24、俄语19、葡语9、德语8、西语4、法语3、韩语3。其中23条日文原为翻译保留占位，已按原文补回。人物名、任务提示、称谓和否定语义也有实际修订。并非只检查条目数量。[逐项证据](maintainer/R7-TRANSLATION-AUDIT.json)。
- 八语全部4890条核心与52条附加界面完成结构、空值、格式、字体和元说明筛查；语义审校针对异常及关键上下文，不宣称逐句母语人工审校。中文与英文未重复做本轮译文校对，仅随通用手柄功能重新构建。
- 十种语言均通过本地Windows/Android构建、APK签名、嵌入数据/音频/存档比对、原生手柄辅助类和布局检查，以及进入城镇后至少240帧运行检查。原始5个游戏文件校验值未变。
- Windows数据与安卓移植数据各通过52项模拟输入检查，包含三套原控制方案、方向重复/死区、助手确认返回、触控/鼠标与手柄共用拖动、原游戏方块鼠标事件、失焦/断连释放、重连回中和场景切换。维护者测试源码位于maintainer/r7-qa-gamepad.*；模拟输入只用于测试副本。
- Windows读取原生GameMaker手柄API；Android由InputDevice/GamepadRouter传递实体按键与轴。右摇杆轴优先Z/RZ，缺失时回退RX/RY。USB/蓝牙手柄需先被系统识别。原生输入集成不代表已经做了实体Xbox或安卓真机操作测试。
- 保留城镇翻译索引性能修复、1988/4007测宽串、动态金额片段边界、俄语6244–6299错位修复、物品名、显示用途CG/图鉴开关和真实场景完成后再提示读档成功的逻辑。新增占位元说明拦截和菜单原生鼠标事件防穿透。

## 范围限制

没有做全剧情通关或全部硬件组合测试。3727原文衣物名称含糊，保留泛称，不强行断定具体服装；1495与2602的原版路线描述左右次数不同，未在缺少路线实测时擅改。字体和ID检查不能证明每句语义无误。

仅发布补丁、翻译、配置和教程，不含原游戏、音频、CG、完整APK或签名密钥。正式发布为Latest。本地清理会保留中文电脑成品、中文安卓APK及小型维护备份，其他语言源码仍在公开补丁和GitHub中。

## r8 Android startup archive fix

Android 12 logs identify inconsistent ZIP descriptors before application startup. Original r7 has 102 invalid descriptors. The repaired signed r8 validates all 235 entries, including decompressed CRCs/sizes, with zero invalid descriptors. ZIP alignment and v2/v3 signature verification pass with the original signing certificate. Game data/audio/native libraries are unchanged. Windows PowerShell 5.1 regression check rejects r7 and accepts r8. All-language APK pipelines now enforce both pre-sign normalization and post-sign validation. This does not establish successful phone gameplay; a device retest is pending. See maintainer/R8-ANDROID-ZIP-AUDIT.json.


## r9 Night-town rendering correction

The phone profiler identified NineSliceBox at 41.18 ms out of 73.16 ms total GML time. The town draws poster panels at alpha zero; the old helper still tiled their full interiors and wrapped/drew their invisible text. r9 skips zero-alpha panel/text drawing. Explicit-colour text calls use their explicit alpha argument. The three shipped nine-slice skins have verified uniform centres and repeat-invariant edges. Nearest-filtered visible panels now take at most nine draws. Linear filtering and unknown skins retain original tiling.

108 OpenGL comparisons cover three skins, six dimension cases (zero, smaller-than-tile, non-multiple, normal, large and negative), fractional positions, alpha 0/0.35/1 and nearest/linear filtering. All 10,368,000 compared pixels are identical. Full night-town screenshots at frame 960 also match before/after for desktop and Android-ported data.

| Measurement | Before | After |
| --- | ---: | ---: |
| Original Windows executable, mean Begin Step to GUI End over 240 sampled town frames | 4.31491 ms | 0.40660 ms |
| Local Butterscotch, desktop data, GML time per frame | 5.44 ms | 0.48 ms |
| Local Butterscotch, Android-ported data, GML time per frame | 5.52 ms | 0.53 ms |
| Local Android-ported data, executed instructions per frame | 317,213 | 29,787 |

Tests use isolated copies/save directories, provided save 99, room 6, global.time=0.9 and the same seed/settings. Native Windows sampling follows 120 town warm-up frames. Local runner figures use the final 120-frame profiler sample of 1000-frame runs; these are not phone frame-rate measurements. r9 phone retesting and physical Xbox testing are not claimed. Game speed, lighting, input, quests and saves are unchanged. The r8 archive fix, CRC/structure validation and signing certificate remain in place. See maintainer/R9-TOWN-RENDER-AUDIT.json.

Render QA: apply maintainer/r9-qa-render.csx to translated pre-r9 data. The CLI screenshot-surfaces option writes the final 7200x2880 atlas; compare its left/right 3600-pixel halves. The town benchmark loads the provided save in an isolated test folder. Never apply instrumentation to a released game or a player's normal save folder.