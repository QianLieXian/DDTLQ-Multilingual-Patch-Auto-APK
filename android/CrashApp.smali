.class public Lcom/qianliexian/ddtlq/CrashApp;
.super Landroid/app/Application;
.implements Ljava/lang/Thread$UncaughtExceptionHandler;

.field private previous:Ljava/lang/Thread$UncaughtExceptionHandler;

.method public constructor <init>()V
 .locals 0
 invoke-direct {p0},Landroid/app/Application;-><init>()V
 return-void
.end method

.method public onCreate()V
 .locals 1
 invoke-super {p0},Landroid/app/Application;->onCreate()V
 invoke-static {},Ljava/lang/Thread;->getDefaultUncaughtExceptionHandler()Ljava/lang/Thread$UncaughtExceptionHandler;
 move-result-object v0
 iput-object v0,p0,Lcom/qianliexian/ddtlq/CrashApp;->previous:Ljava/lang/Thread$UncaughtExceptionHandler;
 invoke-static {p0},Ljava/lang/Thread;->setDefaultUncaughtExceptionHandler(Ljava/lang/Thread$UncaughtExceptionHandler;)V
 return-void
.end method

.method public static record(Landroid/content/Context;Ljava/lang/Throwable;)V
 .locals 3
 :try_start
 invoke-virtual {p0},Landroid/content/Context;->getFilesDir()Ljava/io/File;
 move-result-object v0
 new-instance v1,Ljava/io/File;
 const-string v2,"DDTLQ-crash-java.txt"
 invoke-direct {v1,v0,v2},Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
 new-instance v0,Ljava/io/PrintWriter;
 invoke-direct {v0,v1},Ljava/io/PrintWriter;-><init>(Ljava/io/File;)V
 invoke-virtual {p1,v0},Ljava/lang/Throwable;->printStackTrace(Ljava/io/PrintWriter;)V
 invoke-virtual {v0},Ljava/io/PrintWriter;->close()V
 :try_end
 .catch Ljava/lang/Throwable; {:try_start .. :try_end} :failed
 return-void
 :failed
 move-exception v0
 return-void
.end method

.method public uncaughtException(Ljava/lang/Thread;Ljava/lang/Throwable;)V
 .locals 4
 :try_start
 invoke-virtual {p0},Lcom/qianliexian/ddtlq/CrashApp;->getFilesDir()Ljava/io/File;
 move-result-object v0
 new-instance v1,Ljava/io/File;
 const-string v2,"DDTLQ-crash-java.txt"
 invoke-direct {v1,v0,v2},Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
 new-instance v0,Ljava/io/PrintWriter;
 invoke-direct {v0,v1},Ljava/io/PrintWriter;-><init>(Ljava/io/File;)V
 const-string v1,"DDTLQ r8 Java crash report"
 invoke-virtual {v0,v1},Ljava/io/PrintWriter;->println(Ljava/lang/String;)V
 sget-object v1,Landroid/os/Build;->MODEL:Ljava/lang/String;
 invoke-virtual {v0,v1},Ljava/io/PrintWriter;->println(Ljava/lang/String;)V
 sget-object v1,Landroid/os/Build$VERSION;->RELEASE:Ljava/lang/String;
 invoke-virtual {v0,v1},Ljava/io/PrintWriter;->println(Ljava/lang/String;)V
 invoke-virtual {p2,v0},Ljava/lang/Throwable;->printStackTrace(Ljava/io/PrintWriter;)V
 invoke-virtual {v0},Ljava/io/PrintWriter;->close()V
 :try_end
 .catch Ljava/lang/Throwable; {:try_start .. :try_end} :write_failed
 goto :delegate
 :write_failed
 move-exception v0
 :delegate
 iget-object v0,p0,Lcom/qianliexian/ddtlq/CrashApp;->previous:Ljava/lang/Thread$UncaughtExceptionHandler;
 if-eqz v0,:kill
 invoke-interface {v0,p1,p2},Ljava/lang/Thread$UncaughtExceptionHandler;->uncaughtException(Ljava/lang/Thread;Ljava/lang/Throwable;)V
 :kill
 invoke-static {},Landroid/os/Process;->myPid()I
 move-result v0
 invoke-static {v0},Landroid/os/Process;->killProcess(I)V
 return-void
.end method

.method private static readFile(Ljava/io/File;)Ljava/lang/String;
 .locals 7
 :try_start
 new-instance v0,Ljava/io/RandomAccessFile;
 const-string v1,"r"
 invoke-direct {v0,p0,v1},Ljava/io/RandomAccessFile;-><init>(Ljava/io/File;Ljava/lang/String;)V
 invoke-virtual {v0},Ljava/io/RandomAccessFile;->length()J
 move-result-wide v2
 const-wide/32 v4,0x10000
 sub-long/2addr v2,v4
 const-wide/16 v4,0x0
 cmp-long v6,v2,v4
 if-gez v6,:seek
 const-wide/16 v2,0x0
 :seek
 invoke-virtual {v0,v2,v3},Ljava/io/RandomAccessFile;->seek(J)V
 const v2,0x10000
 new-array v1,v2,[B
 invoke-virtual {v0,v1},Ljava/io/RandomAccessFile;->read([B)I
 move-result v3
 invoke-virtual {v0},Ljava/io/RandomAccessFile;->close()V
 if-lez v3,:empty
 new-instance v0,Ljava/lang/String;
 const/4 v2,0x0
 const-string v4,"UTF-8"
 invoke-direct {v0,v1,v2,v3,v4},Ljava/lang/String;-><init>([BIILjava/lang/String;)V
 return-object v0
 :try_end
 .catch Ljava/lang/Throwable; {:try_start .. :try_end} :failed
 :failed
 move-exception v0
 :empty
 const-string v0,""
 return-object v0
.end method

.method public static report(Landroid/content/Context;)Ljava/lang/String;
 .locals 9
 new-instance v0,Ljava/lang/StringBuilder;
 const-string v1,"DDTLQ r8 本地错误报告。\n\n"
 invoke-direct {v0,v1},Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V
 invoke-virtual {p0},Landroid/content/Context;->getFilesDir()Ljava/io/File;
 move-result-object v1
 new-instance v2,Ljava/io/File;
 const-string v3,"DDTLQ-crash-java.txt"
 invoke-direct {v2,v1,v3},Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
 invoke-static {v2},Lcom/qianliexian/ddtlq/CrashApp;->readFile(Ljava/io/File;)Ljava/lang/String;
 move-result-object v2
 invoke-virtual {v0,v2},Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
 new-instance v2,Ljava/io/File;
 const-string v3,"butterscotch/games/data/224b6ad0-f10d-4d22-a43d-000002010400/logs"
 invoke-direct {v2,v1,v3},Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
 invoke-virtual {v2},Ljava/io/File;->listFiles()[Ljava/io/File;
 move-result-object v1
 if-eqz v1,:done
 const/4 v2,0x0
 const/4 v3,0x0
 const-wide/16 v4,0x0
 :loop
 array-length v6,v1
 if-ge v2,v6,:read
 aget-object v6,v1,v2
 invoke-virtual {v6},Ljava/io/File;->lastModified()J
 move-result-wide v7
 cmp-long v7,v7,v4
 if-lez v7,:next
 move-object v3,v6
 invoke-virtual {v6},Ljava/io/File;->lastModified()J
 move-result-wide v4
 :next
 add-int/lit8 v2,v2,0x1
 goto :loop
 :read
 if-eqz v3,:done
 const-string v1,"\n\n运行组件最新日志：\n"
 invoke-virtual {v0,v1},Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
 invoke-static {v3},Lcom/qianliexian/ddtlq/CrashApp;->readFile(Ljava/io/File;)Ljava/lang/String;
 move-result-object v1
 invoke-virtual {v0,v1},Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
 :done
 const-string v1,"\n\n没有记录不代表没有崩溃。底层闪退还需 adb 日志。"
 invoke-virtual {v0,v1},Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
 invoke-virtual {v0},Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
 move-result-object v0
 return-object v0
.end method
