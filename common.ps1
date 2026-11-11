$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = New-Object Text.UTF8Encoding
Add-Type -AssemblyName System.IO.Compression.FileSystem
Add-Type -AssemblyName System.IO.Compression
$PatchRoot = $PSScriptRoot
$PatchManifest = Get-Content -LiteralPath (Join-Path $PatchRoot 'manifest.json') -Raw -Encoding UTF8 | ConvertFrom-Json
$ToolsDirectory = if ($env:DDTLQ_TOOLS_DIR) { $env:DDTLQ_TOOLS_DIR } else { Join-Path $PatchRoot 'tools' }
$OutputDirectory = Join-Path $PatchRoot 'output'
function Get-CheckedDownload([string]$Url, [string]$Path, [string]$Sha256) {
    if ((Test-Path -LiteralPath $Path) -and (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash -eq $Sha256) { return }
    Write-Host ('正在下载工具：' + [IO.Path]::GetFileName($Path))
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $Url -OutFile ($Path + '.download') -UseBasicParsing
    if ((Get-FileHash -LiteralPath ($Path + '.download') -Algorithm SHA256).Hash -ne $Sha256) { throw '工具下载校验失败。' }
    Move-Item -LiteralPath ($Path + '.download') -Destination $Path -Force
}
function Initialize-Patch {
    foreach ($item in $PatchManifest.files) {
        $file = Join-Path $PatchRoot $item.path
        if (!(Test-Path -LiteralPath $file -PathType Leaf) -or (Get-FileHash -LiteralPath $file -Algorithm SHA256).Hash -ne $item.sha256) { throw ('补丁文件缺失或损坏：' + $item.path) }
    }
    New-Item -ItemType Directory -Path $ToolsDirectory, $OutputDirectory -Force | Out-Null
    $archive = Join-Path $ToolsDirectory 'utmt-cli.zip'
    $cached = Join-Path $ToolsDirectory 'utmt'
    Get-CheckedDownload $PatchManifest.utmt.url $archive $PatchManifest.utmt.sha256
    if (!(Test-Path -LiteralPath (Join-Path $cached 'UndertaleModCli.exe'))) { Expand-Archive -LiteralPath $archive -DestinationPath $cached -Force }
    $script:ModCli = Join-Path $cached 'UndertaleModCli.exe'
}
function Invoke-GamePatch([string]$InputData, [string]$OutputData, [string]$LogPath) {
    if ([IO.Path]::GetFullPath($InputData) -eq [IO.Path]::GetFullPath($OutputData)) { throw '输入和输出不能是同一文件。' }
    $payload = $script:PatchPayload
    if (!$payload) { throw 'Select a language before building.' }
    & $script:ModCli load $InputData -s (Join-Path $payload 'patch-features.csx') -s (Join-Path $payload 'patch-strings.csx') -s (Join-Path $payload 'patch-font.csx') -o $OutputData --overwrite *> $LogPath
    if ($LASTEXITCODE -ne 0 -or !(Test-Path -LiteralPath $OutputData -PathType Leaf)) { throw ('生成失败，原文件未改动。详情：' + $LogPath) }
    & $script:ModCli info $OutputData >> $LogPath
    if ($LASTEXITCODE -ne 0) { throw ('生成文件校验失败：' + $LogPath) }
}

function Select-PatchLanguage([string]$Language) {
    $catalog = Get-Content -LiteralPath (Join-Path $PatchRoot 'languages.json') -Raw -Encoding UTF8 | ConvertFrom-Json
    if (!$Language) {
        Write-Host ''
        Write-Host 'DDTLQ 2.01.04 | Language / 选择语言'
        foreach ($item in $catalog.languages) {
            $suffix = if ($item.status -eq 'available') { '' } else { ' [待完成 / not available yet]' }
            Write-Host ('{0,2}. {1}{2}' -f $item.number,$item.name,$suffix)
        }
        $Language = Read-Host '输入编号并回车 / Number + Enter (1-10)'
    }
    $selected = @($catalog.languages | Where-Object { $_.locale -eq $Language -or [string]$_.number -eq $Language })
    if ($selected.Count -ne 1) { throw '无效语言 / Invalid language selection.' }
    if ($selected[0].status -ne 'available') { throw '此语言的 AI 译稿尚未完成校验，不会用英文占位安装。This language is not ready.' }
    $script:PatchLocale = $selected[0].locale
    $localized = Join-Path $PatchRoot ('locales\' + $script:PatchLocale)
    $script:PatchPayload = Join-Path $localized 'payload'
    $script:PatchAndroid = Join-Path $localized 'android'
    if (!(Test-Path -LiteralPath $script:PatchPayload -PathType Container) -or !(Test-Path -LiteralPath $script:PatchAndroid -PathType Container)) { throw '语言资源缺失 / Missing compiled language assets.' }
    $script:PatchPackage = 'com.qianliexian.ddtlq.' + $script:PatchLocale.ToLowerInvariant().Replace('-','_')
    if ($script:PatchLocale -eq 'zh-CN') { $script:PatchPackage = 'com.qianliexian.ddtlq.zh' }
    $script:PatchLabel = 'DDTLQ ' + $script:PatchLocale
    $script:PatchVersion = '2.01.04-' + $script:PatchLocale + '-r6'
    Write-Host ('Selected / 已选择：' + $selected[0].name)
}
function Resolve-GameDirectory([string]$GameDirectory) {
    if (!$GameDirectory) {
        $nearby = Split-Path $PatchRoot -Parent
        if (Test-Path -LiteralPath (Join-Path $nearby 'data.win') -PathType Leaf) { return $nearby }
        $GameDirectory = Read-Host '拖入原版游戏文件夹并回车 / Drag original game folder here + Enter'
        $GameDirectory = $GameDirectory.Trim().Trim('"')
    }
    if (!$GameDirectory) { throw '没有选择游戏目录 / No game folder selected.' }
    if (Test-Path -LiteralPath $GameDirectory -PathType Leaf) { $GameDirectory = Split-Path (Resolve-Path -LiteralPath $GameDirectory).Path -Parent }
    return (Resolve-Path -LiteralPath $GameDirectory).Path
}
