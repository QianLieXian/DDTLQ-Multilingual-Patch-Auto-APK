param([Parameter(Mandatory=$true)][string]$Stage)
$ErrorActionPreference='Stop'
$class='Lnet/perfectdreams/butterscotch/android/GameActivity$onCreate$2$1$gameSurface$1$1$2$1$1;'
$folder=Join-Path $Stage 'smali_classes10\net\perfectdreams\butterscotch\android'
$pointer=Join-Path $folder 'GameActivity$onCreate$2$1$gameSurface$1$1$2$1$1.smali'
$text=[IO.File]::ReadAllText($pointer).Replace("`r`n","`n")
$pattern='(?s)    \.line 216\n.*?    goto/16 :goto_2'
if([regex]::Matches($text,$pattern).Count -ne 1){throw 'Unexpected pinned runner pointer handler.'}
$dispatch=@'
    iget-object v9, v5, __CLASS__->$buttonForPointer:Ljava/util/Map;
    iget-object v10, v5, __CLASS__->$butterscotchRunner:Lnet/perfectdreams/butterscotch/android/ButterscotchDroidRunner;
    iget-object v11, v5, __CLASS__->$mouseButtonOverride:Landroidx/compose/runtime/MutableState;
    invoke-static {v8, v2, v9, v10, v11}, Lcom/qianliexian/ddtlq/TouchDispatch;->dispatch(Landroidx/compose/ui/input/pointer/PointerInputChange;Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;Ljava/util/Map;Lnet/perfectdreams/butterscotch/android/ButterscotchDroidRunner;Landroidx/compose/runtime/MutableState;)V
    goto/16 :goto_2
'@
$dispatch=$dispatch.Replace('__CLASS__',$class)
$text=[regex]::Replace($text,$pattern,[Text.RegularExpressions.MatchEvaluator]{param($m) $dispatch})
$failure='invoke-static/range {p1 .. p1}, Lkotlin/ResultKt;->throwOnFailure(Ljava/lang/Object;)V'
if([regex]::Matches($text,[regex]::Escape($failure)).Count -ne 2){throw 'Unexpected coroutine result checks.'}
$cleanup=@'
move-object/from16 v6, p1
    iget-object v7, v0, __CLASS__->$buttonForPointer:Ljava/util/Map;
    iget-object v8, v0, __CLASS__->$butterscotchRunner:Lnet/perfectdreams/butterscotch/android/ButterscotchDroidRunner;
    invoke-static {v6, v7, v8}, Lcom/qianliexian/ddtlq/TouchDispatch;->checkResult(Ljava/lang/Object;Ljava/util/Map;Lnet/perfectdreams/butterscotch/android/ButterscotchDroidRunner;)V
'@
$text=$text.Replace($failure,$cleanup.Replace('__CLASS__',$class))
$text=[regex]::Replace($text,'(?m)^\s*\.(?:local|end local|restart local)\b[^\n]*\n','')
[IO.File]::WriteAllText($pointer,$text,(New-Object Text.UTF8Encoding($false)))
$activity=Join-Path $folder 'GameActivity.smali'
$text=[IO.File]::ReadAllText($activity).Replace("`r`n","`n")
$start=$text.IndexOf('.method protected onPause()V');$end=$text.IndexOf('.end method',$start)
if($start -lt 0 -or $end -lt 0){throw 'Missing runner pause callback.'}
$part=$text.Substring($start,$end-$start)
if(([regex]::Matches($part,'(?m)^    :cond_0$')).Count -ne 1){throw 'Unexpected pause callback structure.'}
$part=$part.Replace("`n    :cond_0`n","`n    :cond_0`n    invoke-static {v0}, Lcom/qianliexian/ddtlq/TouchDispatch;->reset(Lnet/perfectdreams/butterscotch/android/ButterscotchDroidRunner;)V`n")
$text=$text.Substring(0,$start)+$part+$text.Substring($end)
[IO.File]::WriteAllText($activity,$text,(New-Object Text.UTF8Encoding($false)))
$launcher=Join-Path $Stage 'smali_classes18\com\qianliexian\ddtlq\Launcher.smali'
$text=[IO.File]::ReadAllText($launcher).Replace("`r`n","`n")
if(([regex]::Matches($text,'(?m)^ :save_done$')).Count -ne 1){throw 'Unexpected localized launcher asset hook.'}
$icons=@'
 :save_done
 new-instance v1,Ljava/io/File;
 const-string v2,"butterscotch/layout-sprites/ddtlq-mouse-left.png"
 invoke-direct {v1,v0,v2},Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
 const-string v2,"ddtlq/ddtlq-mouse-left.png"
 invoke-direct {p0,v2,v1},Lcom/qianliexian/ddtlq/Launcher;->copyAsset(Ljava/lang/String;Ljava/io/File;)V
 new-instance v1,Ljava/io/File;
 const-string v2,"butterscotch/layout-sprites/ddtlq-mouse-right.png"
 invoke-direct {v1,v0,v2},Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
 const-string v2,"ddtlq/ddtlq-mouse-right.png"
 invoke-direct {p0,v2,v1},Lcom/qianliexian/ddtlq/Launcher;->copyAsset(Ljava/lang/String;Ljava/io/File;)V
'@
$text=$text.Replace(' :save_done',$icons)
[IO.File]::WriteAllText($launcher,$text,(New-Object Text.UTF8Encoding($false)))
Write-Host 'Touch input: coordinate-first, primary-pointer drag, cancellation/pause release.'

$router=Join-Path $folder 'GamepadRouter.smali'
$routerText=[IO.File]::ReadAllText($router).Replace("`r`n","`n")
$axisPattern='(?m)^(\s*)invoke-virtual (\{[^}]+\}), Landroid/view/MotionEvent;->getAxisValue\(I\)F$'
$axisCount=[regex]::Matches($routerText,$axisPattern).Count
if($axisCount -lt 8 -or $axisCount -gt 20){throw 'Unexpected pinned gamepad axis handler.'}
$routerText=[regex]::Replace($routerText,$axisPattern,'$1invoke-static $2, Lcom/qianliexian/ddtlq/GamepadAxis;->value(Landroid/view/MotionEvent;I)F')
[IO.File]::WriteAllText($router,$routerText,(New-Object Text.UTF8Encoding($false)))
Write-Host ('Native gamepad axes patched: '+$axisCount)