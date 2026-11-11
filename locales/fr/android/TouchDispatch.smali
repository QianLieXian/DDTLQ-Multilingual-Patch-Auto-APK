.class public final Lcom/qianliexian/ddtlq/TouchDispatch;
.super Ljava/lang/Object;
.source "TouchDispatch.smali"

.field private static owners:Ljava/util/WeakHashMap;

.method static constructor <clinit>()V
 .locals 1
 new-instance v0,Ljava/util/WeakHashMap;
 invoke-direct {v0},Ljava/util/WeakHashMap;-><init>()V
 sput-object v0,Lcom/qianliexian/ddtlq/TouchDispatch;->owners:Ljava/util/WeakHashMap;
 return-void
.end method

# One canvas pointer owns a drag. Other fingers cannot steal its cursor or release it.
# Virtual keyboard/joystick gestures remain handled by the host's separate overlay.
.method public static dispatch(Landroidx/compose/ui/input/pointer/PointerInputChange;Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;Ljava/util/Map;Lnet/perfectdreams/butterscotch/android/ButterscotchDroidRunner;Landroidx/compose/runtime/MutableState;)V
 .locals 10
 invoke-virtual {p0},Landroidx/compose/ui/input/pointer/PointerInputChange;->getId-J3iCeTQ()J
 move-result-wide v0
 invoke-static {v0,v1},Landroidx/compose/ui/input/pointer/PointerId;->box-impl(J)Landroidx/compose/ui/input/pointer/PointerId;
 move-result-object v4
 invoke-interface {p2,v4},Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z
 move-result v5
 if-nez v5,:position
 invoke-interface {p2},Ljava/util/Map;->isEmpty()Z
 move-result v5
 if-eqz v5,:done
 invoke-virtual {p0},Landroidx/compose/ui/input/pointer/PointerInputChange;->getPreviousPressed()Z
 move-result v5
 if-nez v5,:done
 :position
 invoke-virtual {p0},Landroidx/compose/ui/input/pointer/PointerInputChange;->getPosition-F1C5BW0()J
 move-result-wide v0
 invoke-static {v0,v1},Landroidx/compose/ui/geometry/Offset;->getX-impl(J)F
 move-result v2
 invoke-static {v0,v1},Landroidx/compose/ui/geometry/Offset;->getY-impl(J)F
 move-result v3
 invoke-interface {p1},Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;->getSize-YbymL2g()J
 move-result-wide v0
 invoke-static {v0,v1},Landroidx/compose/ui/unit/IntSize;->getWidth-impl(J)I
 move-result v5
 if-lez v5,:done
 int-to-float v5,v5
 div-float/2addr v2,v5
 invoke-static {v0,v1},Landroidx/compose/ui/unit/IntSize;->getHeight-impl(J)I
 move-result v5
 if-lez v5,:done
 int-to-float v5,v5
 div-float/2addr v3,v5
 invoke-virtual {p3,v2,v3},Lnet/perfectdreams/butterscotch/android/ButterscotchDroidRunner;->onMouseMove(FF)V
 invoke-virtual {p0},Landroidx/compose/ui/input/pointer/PointerInputChange;->getPressed()Z
 move-result v0
 invoke-virtual {p0},Landroidx/compose/ui/input/pointer/PointerInputChange;->getPreviousPressed()Z
 move-result v1
 if-eq v0,v1,:done
 if-eqz v0,:release
 invoke-interface {p4},Landroidx/compose/runtime/MutableState;->getValue()Ljava/lang/Object;
 move-result-object v6
 check-cast v6,Lnet/perfectdreams/butterscotch/android/layouts/GmlMouseButton;
 invoke-interface {p2,v4,v6},Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
 sget-object v5,Lcom/qianliexian/ddtlq/TouchDispatch;->owners:Ljava/util/WeakHashMap;
 invoke-virtual {v5,p3,p2},Ljava/util/WeakHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
 const/4 v9,0x1
 invoke-virtual {p3,v6,v9},Lnet/perfectdreams/butterscotch/android/ButterscotchDroidRunner;->onMouseButton(Lnet/perfectdreams/butterscotch/android/layouts/GmlMouseButton;Z)V
 return-void
 :release
 invoke-interface {p2,v4},Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;
 move-result-object v6
 check-cast v6,Lnet/perfectdreams/butterscotch/android/layouts/GmlMouseButton;
 if-eqz v6,:done
 const/4 v9,0x0
 invoke-virtual {p3,v6,v9},Lnet/perfectdreams/butterscotch/android/ButterscotchDroidRunner;->onMouseButton(Lnet/perfectdreams/butterscotch/android/layouts/GmlMouseButton;Z)V
 :done
 return-void
.end method

.method public static reset(Lnet/perfectdreams/butterscotch/android/ButterscotchDroidRunner;)V
 .locals 3
 if-eqz p0,:done
 sget-object v0,Lcom/qianliexian/ddtlq/TouchDispatch;->owners:Ljava/util/WeakHashMap;
 invoke-virtual {v0,p0},Ljava/util/WeakHashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;
 move-result-object v0
 check-cast v0,Ljava/util/Map;
 if-eqz v0,:buttons
 invoke-interface {v0},Ljava/util/Map;->clear()V
 :buttons
 const/4 v2,0x0
 sget-object v1,Lnet/perfectdreams/butterscotch/android/layouts/GmlMouseButton;->LEFT_BUTTON:Lnet/perfectdreams/butterscotch/android/layouts/GmlMouseButton;
 invoke-virtual {p0,v1,v2},Lnet/perfectdreams/butterscotch/android/ButterscotchDroidRunner;->onMouseButton(Lnet/perfectdreams/butterscotch/android/layouts/GmlMouseButton;Z)V
 sget-object v1,Lnet/perfectdreams/butterscotch/android/layouts/GmlMouseButton;->RIGHT_BUTTON:Lnet/perfectdreams/butterscotch/android/layouts/GmlMouseButton;
 invoke-virtual {p0,v1,v2},Lnet/perfectdreams/butterscotch/android/ButterscotchDroidRunner;->onMouseButton(Lnet/perfectdreams/butterscotch/android/layouts/GmlMouseButton;Z)V
 sget-object v1,Lnet/perfectdreams/butterscotch/android/layouts/GmlMouseButton;->MIDDLE_BUTTON:Lnet/perfectdreams/butterscotch/android/layouts/GmlMouseButton;
 invoke-virtual {p0,v1,v2},Lnet/perfectdreams/butterscotch/android/ButterscotchDroidRunner;->onMouseButton(Lnet/perfectdreams/butterscotch/android/layouts/GmlMouseButton;Z)V
 :done
 return-void
.end method

.method public static checkResult(Ljava/lang/Object;Ljava/util/Map;Lnet/perfectdreams/butterscotch/android/ButterscotchDroidRunner;)V
 .locals 1
 :try_start
 invoke-static {p0},Lkotlin/ResultKt;->throwOnFailure(Ljava/lang/Object;)V
 :try_end
 .catchall {:try_start .. :try_end} :failed
 return-void
 :failed
 move-exception v0
 invoke-interface {p1},Ljava/util/Map;->clear()V
 invoke-static {p2},Lcom/qianliexian/ddtlq/TouchDispatch;->reset(Lnet/perfectdreams/butterscotch/android/ButterscotchDroidRunner;)V
 throw v0
.end method
