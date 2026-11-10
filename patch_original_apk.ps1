param([string]$ApkPath)
try {
    . (Join-Path $PSScriptRoot 'common.ps1')
    if (!$ApkPath) {
        $candidate = @(Get-ChildItem -LiteralPath $PSScriptRoot -Filter '*.apk' -File)
        if ($candidate.Count -eq 1) { $ApkPath = $candidate[0].FullName }
    }
    if (!$ApkPath -or !(Test-Path -LiteralPath $ApkPath -PathType Leaf)) { throw '请把自行取得的 DDTLQ 2.01.04 原版安卓 APK 拖到 BAT 上。本补丁不含游戏。' }
    $ApkPath = (Resolve-Path -LiteralPath $ApkPath).Path
    Initialize-Patch
    $build = Join-Path $OutputDirectory ('Android-' + [Guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $build | Out-Null
    $sourceData = Join-Path $build 'original.droid'
    $zip = [IO.Compression.ZipFile]::OpenRead($ApkPath)
    try {
        $entries = @($zip.Entries | Where-Object { $_.FullName -match '^assets/(game\.(droid|win)|data\.win)$' })
        if ($entries.Count -ne 1) { throw '没有找到唯一的 GameMaker 数据文件，停止处理此 APK。' }
        $gameEntry = $entries[0].FullName
        [IO.Compression.ZipFileExtensions]::ExtractToFile($entries[0], $sourceData, $false)
    } finally { $zip.Dispose() }
    Write-Host '正在检查游戏版本并合并汉化……'
    $patchedData = Join-Path $build 'patched.droid'
    Invoke-GamePatch $sourceData $patchedData (Join-Path $build 'build.log')
    $unsigned = Join-Path $build 'DDTLQ-2.01.04-zh-unsigned.apk'
    Copy-Item -LiteralPath $ApkPath -Destination $unsigned
    $zip = [IO.Compression.ZipFile]::Open($unsigned, [IO.Compression.ZipArchiveMode]::Update)
    try {
        foreach ($entry in @($zip.Entries)) { if ($entry.FullName -eq $gameEntry -or $entry.FullName -match '^META-INF/[^/]+\.(SF|RSA|DSA|EC|MF)$') { $entry.Delete() } }
        [IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $patchedData, $gameEntry, [IO.Compression.CompressionLevel]::Optimal) | Out-Null
    } finally { $zip.Dispose() }
    $javaZip = Join-Path $ToolsDirectory 'java17.zip'
    Get-CheckedDownload $PatchManifest.java.url $javaZip $PatchManifest.java.sha256
    $javaRoot = Join-Path $ToolsDirectory 'java'
    $java = Get-ChildItem -LiteralPath $javaRoot -Filter java.exe -Recurse -File -ErrorAction SilentlyContinue | Select-Object -First 1
    if (!$java) {
        Expand-Archive -LiteralPath $javaZip -DestinationPath $javaRoot -Force
        $java = Get-ChildItem -LiteralPath $javaRoot -Filter java.exe -Recurse -File | Select-Object -First 1
    }
    if (!$java) { throw 'Java 工具解压失败。' }
    $signer = Join-Path $ToolsDirectory 'uber-apk-signer.jar'
    Get-CheckedDownload $PatchManifest.signer.url $signer $PatchManifest.signer.sha256
    $jar = [IO.Compression.ZipFile]::OpenRead($signer)
    try { [IO.Compression.ZipFileExtensions]::ExtractToFile($jar.GetEntry('debug.keystore'), (Join-Path $ToolsDirectory 'patch.keystore'), $true) } finally { $jar.Dispose() }
    $signedDir = Join-Path $build 'signed'
    & $java.FullName '-Dfile.encoding=UTF-8' '-jar' $signer '-a' $unsigned '-o' $signedDir '--allowResign' '--ksDebug' (Join-Path $ToolsDirectory 'patch.keystore')
    if ($LASTEXITCODE -ne 0) { throw 'APK 签名失败。' }
    $signed = @(Get-ChildItem -LiteralPath $signedDir -Filter '*-aligned-debugSigned.apk' -File)
    if ($signed.Count -ne 1) { throw '没有找到唯一的签名成品。' }
    & $java.FullName '-Dfile.encoding=UTF-8' '-jar' $signer '-a' $signed[0].FullName '-y'
    if ($LASTEXITCODE -ne 0) { throw '签名或对齐校验失败。' }
    $final = Join-Path $build 'DDTLQ-2.01.04-zh-android.apk'
    Move-Item -LiteralPath $signed[0].FullName -Destination $final
    $zip = [IO.Compression.ZipFile]::OpenRead($final)
    try {
        $entry = $zip.GetEntry($gameEntry)
        if (!$entry) { throw '最终 APK 中缺少游戏数据。' }
        $stream = $entry.Open(); $sha = [Security.Cryptography.SHA256]::Create()
        try { $actual = [BitConverter]::ToString($sha.ComputeHash($stream)).Replace('-','') } finally { $stream.Dispose(); $sha.Dispose() }
        if ($actual -ne (Get-FileHash -LiteralPath $patchedData).Hash) { throw 'APK 内的汉化数据校验失败。' }
    } finally { $zip.Dispose() }
    (Get-FileHash -LiteralPath $final).Hash | Set-Content -LiteralPath (Join-Path $build 'APK.sha256.txt') -Encoding ASCII
    Write-Host ('已生成本地 APK：' + $final) -ForegroundColor Green
    Write-Host '安卓分支尚未进行真机验证。签名已变化，请先备份原版存档再安装。'
    exit 0
} catch { Write-Host ('失败：' + $_.Exception.Message) -ForegroundColor Red; exit 1 }
