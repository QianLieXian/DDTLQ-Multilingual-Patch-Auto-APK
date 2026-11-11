param([string]$GameDirectory, [string]$Language)
try {
    . (Join-Path $PSScriptRoot 'common.ps1')
    Select-PatchLanguage $Language
    $GameDirectory = Resolve-GameDirectory $GameDirectory
    $source = Join-Path $GameDirectory 'data.win'
    if (!(Test-Path -LiteralPath $source -PathType Leaf)) { throw '把游戏文件夹拖到 BAT 上，或将补丁文件夹放在游戏目录中。' }
    if ((Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash -ne $PatchManifest.pc_data_sha256) { throw '原版数据不匹配，本补丁适用于 DDTLQ 2.01.04 Beta 的指定 Windows 版。' }
    foreach ($name in @('triline nsfw.exe','audiogroup1.dat','audiogroup2.dat')) { if (!(Test-Path -LiteralPath (Join-Path $GameDirectory $name))) { throw ('游戏文件不完整：' + $name) } }
    Initialize-Patch
    $build = Join-Path $OutputDirectory ('Windows-' + $script:PatchLocale + '-' + [Guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $build | Out-Null
    Write-Host '正在生成所选语言的游戏副本 / Building selected language…'
    Invoke-GamePatch $source (Join-Path $build 'data.win') (Join-Path $build 'build.log')
    foreach ($name in @('triline nsfw.exe','audiogroup1.dat','audiogroup2.dat','options.ini')) {
        $from = Join-Path $GameDirectory $name
        if (Test-Path -LiteralPath $from) { Copy-Item -LiteralPath $from -Destination (Join-Path $build $name) }
    }
    (Get-FileHash -LiteralPath (Join-Path $build 'data.win')).Hash | Set-Content -LiteralPath (Join-Path $build 'data.sha256.txt') -Encoding ASCII
    Write-Host ('完成！运行：' + (Join-Path $build 'triline nsfw.exe')) -ForegroundColor Green
    exit 0
} catch { Write-Host ('失败：' + $_.Exception.Message) -ForegroundColor Red; exit 1 }
