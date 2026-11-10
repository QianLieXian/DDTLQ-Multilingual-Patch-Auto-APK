$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = New-Object Text.UTF8Encoding
Add-Type -AssemblyName System.IO.Compression.FileSystem
Add-Type -AssemblyName System.IO.Compression
$PatchRoot = $PSScriptRoot
$PatchManifest = Get-Content -LiteralPath (Join-Path $PatchRoot 'manifest.json') -Raw -Encoding UTF8 | ConvertFrom-Json
$ToolsDirectory = Join-Path $PatchRoot 'tools'
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
    $payload = Join-Path $PatchRoot 'payload'
    & $script:ModCli load $InputData -s (Join-Path $payload 'patch-features.csx') -s (Join-Path $payload 'patch-strings.csx') -s (Join-Path $payload 'patch-font.csx') -o $OutputData *> $LogPath
    if ($LASTEXITCODE -ne 0 -or !(Test-Path -LiteralPath $OutputData -PathType Leaf)) { throw ('生成失败，原文件未改动。详情：' + $LogPath) }
    & $script:ModCli info $OutputData >> $LogPath
    if ($LASTEXITCODE -ne 0) { throw ('生成文件校验失败：' + $LogPath) }
}
