param([string]$GameDirectory, [string]$Language)
try {
    . (Join-Path $PSScriptRoot 'common.ps1')
    Select-PatchLanguage $Language
    $GameDirectory = Resolve-GameDirectory $GameDirectory
    $source = Join-Path $GameDirectory 'data.win'
    if (!(Test-Path -LiteralPath $source) -or (Get-FileHash -LiteralPath $source).Hash -ne $PatchManifest.pc_data_sha256) { throw '请将指定版本的原版 Windows 游戏文件夹拖到 BAT 上。' }
    foreach ($name in @('audiogroup1.dat','audiogroup2.dat')) { if (!(Test-Path -LiteralPath (Join-Path $GameDirectory $name))) { throw ('缺少游戏文件：' + $name) } }
    Initialize-Patch
    $build = Join-Path $OutputDirectory ('Android-PC-' + $script:PatchLocale + '-' + [Guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $build | Out-Null
    $pcData = Join-Path $build 'translated.win'
    Invoke-GamePatch $source $pcData (Join-Path $build 'build.log')
    $portData = Join-Path $build 'ported.win'
    & $script:ModCli load $pcData -s (Join-Path $PatchRoot 'payload\patch-port.csx') -o $portData >> (Join-Path $build 'build.log')
    if ($LASTEXITCODE -ne 0 -or !(Test-Path -LiteralPath $portData)) { throw '安卓兼容修补失败，请查看 build.log。' }
    $javaZip = Join-Path $ToolsDirectory 'java17.zip'
    Get-CheckedDownload $PatchManifest.java.url $javaZip $PatchManifest.java.sha256
    $javaRoot = Join-Path $ToolsDirectory 'java'
    $java = Get-ChildItem -LiteralPath $javaRoot -Filter java.exe -File -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
    if (!$java) { Expand-Archive -LiteralPath $javaZip -DestinationPath $javaRoot -Force; $java = Get-ChildItem -LiteralPath $javaRoot -Filter java.exe -File -Recurse | Select-Object -First 1 }
    if (!$java) { throw 'Java 工具解压失败。' }
    $apktool = Join-Path $ToolsDirectory 'apktool.jar'
    $baseZip = Join-Path $ToolsDirectory 'open-runner-android.zip'
    $signer = Join-Path $ToolsDirectory 'uber-apk-signer.jar'
    Get-CheckedDownload $PatchManifest.apktool.url $apktool $PatchManifest.apktool.sha256
    Get-CheckedDownload $PatchManifest.open_runner.url $baseZip $PatchManifest.open_runner.sha256
    Get-CheckedDownload $PatchManifest.signer.url $signer $PatchManifest.signer.sha256
    $baseDir = Join-Path $build 'base'
    Expand-Archive -LiteralPath $baseZip -DestinationPath $baseDir
    $baseApk = @(Get-ChildItem -LiteralPath $baseDir -Filter '*.apk' -File -Recurse)
    if ($baseApk.Count -ne 1) { throw '运行组件内没有唯一的 APK。' }
    # Android's native aapt2/zipalign tools require an ASCII build path on Windows.
    $nativeRoot = Join-Path ([IO.Path]::GetTempPath()) ('DDTLQ-' + [Guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $nativeRoot | Out-Null
    $stage = Join-Path $nativeRoot 'stage'
    Write-Host '正在制作安卓运行外壳……'
    & $java.FullName '-jar' $apktool 'd' $baseApk[0].FullName '-o' $stage *> (Join-Path $build 'apktool.log')
    if ($LASTEXITCODE -ne 0) { throw '安卓外壳解析失败。' }
    $sourceDir = $script:PatchAndroid
    $newDex = Join-Path $stage 'smali_classes18\com\qianliexian\ddtlq'
    New-Item -ItemType Directory -Path $newDex -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $sourceDir 'Launcher.smali') -Destination (Join-Path $newDex 'Launcher.smali')
    Copy-Item -LiteralPath (Join-Path $sourceDir 'LauncherReady.smali') -Destination (Join-Path $newDex 'Launcher$Ready.smali')
    Copy-Item -LiteralPath (Join-Path $sourceDir 'CrashApp.smali') -Destination (Join-Path $newDex 'CrashApp.smali')
    $embedded = Join-Path $stage 'assets\embedded'
    $ddtlq = Join-Path $stage 'assets\ddtlq'
    New-Item -ItemType Directory -Path $embedded,$ddtlq -Force | Out-Null
    Copy-Item -LiteralPath $portData -Destination (Join-Path $embedded 'data.win')
    foreach ($name in @('audiogroup1.dat','audiogroup2.dat')) { Copy-Item -LiteralPath (Join-Path $GameDirectory $name) -Destination (Join-Path $embedded $name) }
    Copy-Item -LiteralPath (Join-Path $sourceDir 'library.json') -Destination (Join-Path $ddtlq 'library.json')
    Copy-Item -LiteralPath (Join-Path $PatchRoot 'saves\Memory Quartz Line 99.ini') -Destination (Join-Path $ddtlq 'full-save.ini')
    foreach ($layout in @('default_landscape.json','default_portrait.json')) { Copy-Item -LiteralPath (Join-Path $sourceDir $layout) -Destination (Join-Path $stage ('assets\layouts\' + $layout)) -Force }
    Copy-Item -LiteralPath (Join-Path $sourceDir 'ddtlq_icon.xml') -Destination (Join-Path $stage 'res\drawable\ddtlq_icon.xml')
    $ns = 'http://schemas.android.com/apk/res/android'
    $manifestPath = Join-Path $stage 'AndroidManifest.xml'
    [xml]$xml = Get-Content -LiteralPath $manifestPath -Raw -Encoding UTF8
    $oldPackage = $xml.manifest.package
    $xml.manifest.package = $script:PatchPackage
    $app = $xml.manifest.application
    $app.SetAttribute('name',$ns,'com.qianliexian.ddtlq.CrashApp')
    $app.SetAttribute('label',$ns,$script:PatchLabel)
    $app.SetAttribute('icon',$ns,'@drawable/ddtlq_icon')
    $app.SetAttribute('roundIcon',$ns,'@drawable/ddtlq_icon')
    $app.SetAttribute('extractNativeLibs',$ns,'true')
    $app.SetAttribute('debuggable',$ns,'false')
    foreach ($activity in @($app.activity)) {
        $activity.SetAttribute('exported',$ns,'false')
        foreach ($filter in @($activity.'intent-filter')) {
            if ($filter -and @($filter.category | Where-Object { $_.GetAttribute('name',$ns) -eq 'android.intent.category.LAUNCHER' }).Count -gt 0) { $activity.RemoveChild($filter) | Out-Null }
        }
        if ($activity.GetAttribute('name',$ns) -eq 'net.perfectdreams.butterscotch.android.GameActivity') { $activity.SetAttribute('screenOrientation',$ns,'sensorLandscape') }
    }
    foreach ($provider in @($app.provider)) { $authority = $provider.GetAttribute('authorities',$ns); if ($authority) { $provider.SetAttribute('authorities',$ns,$authority.Replace($oldPackage,$script:PatchPackage)) } }
    foreach ($permission in @($xml.manifest.'uses-permission')) { if ($permission.GetAttribute('name',$ns) -eq 'com.google.android.gms.permission.AD_ID') { $xml.manifest.RemoveChild($permission) | Out-Null } }
    foreach ($permission in @($xml.manifest.permission) + @($xml.manifest.'uses-permission')) { if ($permission) { $name=$permission.GetAttribute('name',$ns);if($name.StartsWith($oldPackage+'.')){$permission.SetAttribute('name',$ns,$name.Replace($oldPackage,$script:PatchPackage))} } }
    $launcher = $xml.CreateElement('activity')
    $launcher.SetAttribute('name',$ns,'com.qianliexian.ddtlq.Launcher')
    $launcher.SetAttribute('exported',$ns,'true')
    $launcher.SetAttribute('screenOrientation',$ns,'sensorLandscape')
    $filter = $xml.CreateElement('intent-filter')
    $action = $xml.CreateElement('action'); $action.SetAttribute('name',$ns,'android.intent.action.MAIN'); $filter.AppendChild($action) | Out-Null
    $category = $xml.CreateElement('category'); $category.SetAttribute('name',$ns,'android.intent.category.LAUNCHER'); $filter.AppendChild($category) | Out-Null
    $launcher.AppendChild($filter) | Out-Null; $app.AppendChild($launcher) | Out-Null
    $xml.Save($manifestPath)
    $yamlPath=Join-Path $stage 'apktool.yml'
    $yaml=[IO.File]::ReadAllText($yamlPath)
    $yaml=$yaml -replace 'versionCode: 32','versionCode: 2010406' -replace 'versionName: dev',('versionName: ' + $script:PatchVersion)
    [IO.File]::WriteAllText($yamlPath,$yaml,(New-Object Text.UTF8Encoding($false)))
    $unsigned = Join-Path $nativeRoot 'DDTLQ-2.01.04-zh-port-unsigned.apk'
    & $java.FullName '-jar' $apktool 'b' $stage '-o' $unsigned >> (Join-Path $build 'apktool.log')
    if ($LASTEXITCODE -ne 0 -or !(Test-Path -LiteralPath $unsigned)) { throw '安卓构建失败，请查看 apktool.log。' }
    $jar = [IO.Compression.ZipFile]::OpenRead($signer)
    try { [IO.Compression.ZipFileExtensions]::ExtractToFile($jar.GetEntry('debug.keystore'), (Join-Path $ToolsDirectory 'patch.keystore'), $true) } finally { $jar.Dispose() }
    $signDir = Join-Path $nativeRoot 'signed'
    & $java.FullName '-jar' $signer '-a' $unsigned '-o' $signDir '--allowResign' '--ksDebug' (Join-Path $ToolsDirectory 'patch.keystore') *> (Join-Path $build 'sign.log')
    if ($LASTEXITCODE -ne 0) { throw 'APK 签名失败，请查看 sign.log。' }
    $signed = @(Get-ChildItem -LiteralPath $signDir -Filter '*-aligned-debugSigned.apk' -File)
    if ($signed.Count -ne 1) { throw '没有找到唯一的签名成品。' }
    & $java.FullName '-jar' $signer '-a' $signed[0].FullName '-y' >> (Join-Path $build 'sign.log')
    if ($LASTEXITCODE -ne 0) { throw 'APK 签名验证失败。' }
    $final = Join-Path $build ('DDTLQ-' + $script:PatchVersion + '-android.apk')
    Move-Item -LiteralPath $signed[0].FullName -Destination $final
    $zip = [IO.Compression.ZipFile]::OpenRead($final)
    try { foreach ($name in @('assets/embedded/data.win','assets/embedded/audiogroup1.dat','assets/embedded/audiogroup2.dat','assets/ddtlq/full-save.ini','classes18.dex')) { if (!$zip.GetEntry($name)) { throw ('最终 APK 缺少：' + $name) } } } finally { $zip.Dispose() }
    (Get-FileHash -LiteralPath $final).Hash | Set-Content -LiteralPath (Join-Path $build 'APK.sha256.txt') -Encoding ASCII
    Write-Host ('已生成本地安卓包：' + $final) -ForegroundColor Green
    Write-Host '无需原版安卓 APK。使用开源运行组件，尚需安卓真机验证。'
    exit 0
} catch { Write-Host ('失败：' + $_.Exception.Message) -ForegroundColor Red; exit 1 }
