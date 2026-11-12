.class public final Lcom/qianliexian/ddtlq/GamepadAxis;
.super Ljava/lang/Object;
.source "GamepadAxis.smali"

# Prefer Android's mapped Z/RZ axes; fall back to RX/RY only if the preferred
# motion range is absent. A centred Z axis is valid and must not trigger fallback.
.method public static value(Landroid/view/MotionEvent;I)F
 .locals 3
 invoke-virtual {p0},Landroid/view/MotionEvent;->getDevice()Landroid/view/InputDevice;
 move-result-object v0
 if-eqz v0,:read
 invoke-virtual {v0,p1},Landroid/view/InputDevice;->getMotionRange(I)Landroid/view/InputDevice$MotionRange;
 move-result-object v1
 if-nez v1,:read
 const/16 v2,0xb
 if-ne p1,v2,:try_rz
 const/16 v2,0xc
 goto :fallback
 :try_rz
 const/16 v2,0xe
 if-ne p1,v2,:read
 const/16 v2,0xd
 :fallback
 invoke-virtual {v0,v2},Landroid/view/InputDevice;->getMotionRange(I)Landroid/view/InputDevice$MotionRange;
 move-result-object v1
 if-eqz v1,:read
 move p1,v2
 :read
 invoke-virtual {p0,p1},Landroid/view/MotionEvent;->getAxisValue(I)F
 move-result v0
 return v0
.end method
