param([string]$SaveDirectory)
$ErrorActionPreference='Stop'
try {
    if(!$SaveDirectory){$SaveDirectory=Join-Path $env:LOCALAPPDATA 'triline_nsfw'}
    New-Item -ItemType Directory -Path $SaveDirectory -Force | Out-Null
    $stamp=Get-Date -Format 'yyyyMMdd-HHmmss-fff'
    foreach($name in @('Memory Quartz Line 0.ini','Memory Quartz Line 99.ini','DDTLQ_ZH.ini')){
        $file=Join-Path $SaveDirectory $name
        if(Test-Path -LiteralPath $file){Copy-Item -LiteralPath $file -Destination ($file+'.backup-'+$stamp)}
    }
    $source=Join-Path $PSScriptRoot 'saves\Memory Quartz Line 99.ini'
    Copy-Item -LiteralPath $source -Destination (Join-Path $SaveDirectory 'Memory Quartz Line 0.ini') -Force
    Copy-Item -LiteralPath $source -Destination (Join-Path $SaveDirectory 'Memory Quartz Line 99.ini') -Force
    $helper=Join-Path $SaveDirectory 'DDTLQ_ZH.ini'
    if(Test-Path -LiteralPath $helper){
        $text=[IO.File]::ReadAllText($helper)
        if($text -match '(?m)^Gallery='){$text=$text -replace '(?m)^Gallery=.*$','Gallery=1'}else{$text+="`r`n[Helper]`r`nGallery=1`r`n"}
    }else{$text="[Helper]`r`nGallery=1`r`nRecovery=0`r`nDebug=0`r`nDex=1`r`n"}
    if($text -match '(?m)^Dex\s*='){$text=$text -replace '(?m)^Dex\s*=.*$','Dex=1'}else{$text=$text -replace '(?m)^\[Helper\]\s*$',('[Helper]'+"`r`nDex=1")}
    [IO.File]::WriteAllText($helper,$text,(New-Object Text.UTF8Encoding($false)))
    Write-Host '已导入。原存档已另存 backup 文件。启动游戏选择读取存档即可。' -ForegroundColor Green
    exit 0
}catch{Write-Host ('失败：'+$_.Exception.Message) -ForegroundColor Red;exit 1}
