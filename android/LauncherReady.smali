.class public Lcom/qianliexian/ddtlq/Launcher$Ready;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;
.field private owner:Lcom/qianliexian/ddtlq/Launcher;
.field private error:Ljava/lang/String;
.method public constructor <init>(Lcom/qianliexian/ddtlq/Launcher;Ljava/lang/String;)V
 .locals 0
 invoke-direct {p0},Ljava/lang/Object;-><init>()V
 iput-object p1,p0,Lcom/qianliexian/ddtlq/Launcher$Ready;->owner:Lcom/qianliexian/ddtlq/Launcher;
 iput-object p2,p0,Lcom/qianliexian/ddtlq/Launcher$Ready;->error:Ljava/lang/String;
 return-void
.end method
.method public run()V
 .locals 2
 iget-object v0,p0,Lcom/qianliexian/ddtlq/Launcher$Ready;->owner:Lcom/qianliexian/ddtlq/Launcher;
 iget-object v1,p0,Lcom/qianliexian/ddtlq/Launcher$Ready;->error:Ljava/lang/String;
 invoke-virtual {v0,v1},Lcom/qianliexian/ddtlq/Launcher;->ready(Ljava/lang/String;)V
 return-void
.end method
