.class public Lcom/qianliexian/ddtlq/Launcher;
.super Landroid/app/Activity;
.implements Ljava/lang/Runnable;
.implements Landroid/view/View$OnClickListener;

.field private status:Landroid/widget/TextView;
.field private startButton:Landroid/widget/Button;
.field private manageButton:Landroid/widget/Button;

.method public constructor <init>()V
 .locals 0
 invoke-direct {p0}, Landroid/app/Activity;-><init>()V
 return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
 .locals 5
 invoke-super {p0,p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V
 new-instance v0,Landroid/widget/LinearLayout;
 invoke-direct {v0,p0},Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
 const/4 v1,0x1
 invoke-virtual {v0,v1},Landroid/widget/LinearLayout;->setOrientation(I)V
 const/16 v1,0x20
 invoke-virtual {v0,v1,v1,v1,v1},Landroid/widget/LinearLayout;->setPadding(IIII)V
 new-instance v1,Landroid/widget/TextView;
 invoke-direct {v1,p0},Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
 const-string v2,"DDTLQ 2.01.04 日本語化 r8"
 invoke-virtual {v1,v2},Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
 const/high16 v2,0x41c00000
 invoke-virtual {v1,v2},Landroid/widget/TextView;->setTextSize(F)V
 invoke-virtual {v0,v1},Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
 new-instance v1,Landroid/widget/TextView;
 invoke-direct {v1,p0},Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
 const-string v2,"ゲームファイルを準備しています。初回起動時はしばらくお待ちください……"
 invoke-virtual {v1,v2},Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
 iput-object v1,p0,Lcom/qianliexian/ddtlq/Launcher;->status:Landroid/widget/TextView;
 invoke-virtual {v0,v1},Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
 new-instance v1,Landroid/widget/Button;
 invoke-direct {v1,p0},Landroid/widget/Button;-><init>(Landroid/content/Context;)V
 const-string v2,"ゲーム開始"
 invoke-virtual {v1,v2},Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
 const/4 v2,0x1
 invoke-virtual {v1,v2},Landroid/widget/Button;->setId(I)V
 const/4 v3,0x0
 invoke-virtual {v1,v3},Landroid/widget/Button;->setEnabled(Z)V
 invoke-virtual {v1,p0},Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V
 iput-object v1,p0,Lcom/qianliexian/ddtlq/Launcher;->startButton:Landroid/widget/Button;
 invoke-virtual {v0,v1},Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
 new-instance v1,Landroid/widget/Button;
 invoke-direct {v1,p0},Landroid/widget/Button;-><init>(Landroid/content/Context;)V
 const-string v2,"セーブデータと設定"
 invoke-virtual {v1,v2},Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
 const/4 v2,0x2
 invoke-virtual {v1,v2},Landroid/widget/Button;->setId(I)V
 invoke-virtual {v1,v3},Landroid/widget/Button;->setEnabled(Z)V
 invoke-virtual {v1,p0},Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V
 iput-object v1,p0,Lcom/qianliexian/ddtlq/Launcher;->manageButton:Landroid/widget/Button;
 invoke-virtual {v0,v1},Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
 new-instance v1,Landroid/widget/Button;
 invoke-direct {v1,p0},Landroid/widget/Button;-><init>(Landroid/content/Context;)V
 const/4 v2,0x3
 invoke-virtual {v1,v2},Landroid/widget/Button;->setId(I)V
 const-string v2,"エラーレポートを表示／コピー"
 invoke-virtual {v1,v2},Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
 invoke-virtual {v1,p0},Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V
 invoke-virtual {v0,v1},Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
 new-instance v1,Landroid/widget/ScrollView;
 invoke-direct {v1,p0},Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V
 invoke-virtual {v1,v0},Landroid/widget/ScrollView;->addView(Landroid/view/View;)V
 invoke-virtual {p0,v1},Lcom/qianliexian/ddtlq/Launcher;->setContentView(Landroid/view/View;)V
 new-instance v0,Ljava/lang/Thread;
 invoke-direct {v0,p0},Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V
 invoke-virtual {v0},Ljava/lang/Thread;->start()V
 return-void
.end method

.method private copyAsset(Ljava/lang/String;Ljava/io/File;)V
 .locals 7
 invoke-virtual {p2},Ljava/io/File;->getParentFile()Ljava/io/File;
 move-result-object v0
 invoke-virtual {v0},Ljava/io/File;->mkdirs()Z
 invoke-virtual {p0},Lcom/qianliexian/ddtlq/Launcher;->getAssets()Landroid/content/res/AssetManager;
 move-result-object v0
 invoke-virtual {v0,p1},Landroid/content/res/AssetManager;->open(Ljava/lang/String;)Ljava/io/InputStream;
 move-result-object v0
 invoke-virtual {v0},Ljava/io/InputStream;->available()I
 move-result v1
 int-to-long v1,v1
 invoke-virtual {p2},Ljava/io/File;->length()J
 move-result-wide v3
 const-string v6,"embedded/data.win"
 invoke-virtual {v6,p1},Ljava/lang/String;->equals(Ljava/lang/Object;)Z
 move-result v5
 if-nez v5,:copy
 cmp-long v5,v1,v3
 if-nez v5,:copy
 invoke-virtual {v0},Ljava/io/InputStream;->close()V
 return-void
 :copy
 new-instance v1,Ljava/io/File;
 invoke-virtual {p2},Ljava/io/File;->getPath()Ljava/lang/String;
 move-result-object v2
 const-string v3,".preparing"
 invoke-virtual {v2,v3},Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;
 move-result-object v2
 invoke-direct {v1,v2},Ljava/io/File;-><init>(Ljava/lang/String;)V
 new-instance v2,Ljava/io/FileOutputStream;
 invoke-direct {v2,v1},Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
 const v3,0x10000
 new-array v3,v3,[B
 :loop
 invoke-virtual {v0,v3},Ljava/io/InputStream;->read([B)I
 move-result v4
 if-ltz v4,:done
 const/4 v5,0x0
 invoke-virtual {v2,v3,v5,v4},Ljava/io/FileOutputStream;->write([BII)V
 goto :loop
 :done
 invoke-virtual {v0},Ljava/io/InputStream;->close()V
 invoke-virtual {v2},Ljava/io/FileOutputStream;->getFD()Ljava/io/FileDescriptor;
 move-result-object v0
 invoke-virtual {v0},Ljava/io/FileDescriptor;->sync()V
 invoke-virtual {v2},Ljava/io/FileOutputStream;->close()V
 invoke-virtual {v1,p2},Ljava/io/File;->renameTo(Ljava/io/File;)Z
 move-result v0
 if-nez v0,:ok
 new-instance v0,Ljava/io/IOException;
 const-string v1,"Cannot finish game file extraction"
 invoke-direct {v0,v1},Ljava/io/IOException;-><init>(Ljava/lang/String;)V
 throw v0
 :ok
 return-void
.end method

.method public run()V
 .locals 6
 :try_start
 invoke-virtual {p0},Lcom/qianliexian/ddtlq/Launcher;->getFilesDir()Ljava/io/File;
 move-result-object v0
 new-instance v1,Ljava/io/File;
 const-string v2,"butterscotch/games/data/224b6ad0-f10d-4d22-a43d-000002010400/bundle"
 invoke-direct {v1,v0,v2},Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
 new-instance v2,Ljava/io/File;
 const-string v3,"data.win"
 invoke-direct {v2,v1,v3},Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
 const-string v3,"embedded/data.win"
 invoke-direct {p0,v3,v2},Lcom/qianliexian/ddtlq/Launcher;->copyAsset(Ljava/lang/String;Ljava/io/File;)V
 new-instance v2,Ljava/io/File;
 const-string v3,"audiogroup1.dat"
 invoke-direct {v2,v1,v3},Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
 const-string v3,"embedded/audiogroup1.dat"
 invoke-direct {p0,v3,v2},Lcom/qianliexian/ddtlq/Launcher;->copyAsset(Ljava/lang/String;Ljava/io/File;)V
 new-instance v2,Ljava/io/File;
 const-string v3,"audiogroup2.dat"
 invoke-direct {v2,v1,v3},Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
 const-string v3,"embedded/audiogroup2.dat"
 invoke-direct {p0,v3,v2},Lcom/qianliexian/ddtlq/Launcher;->copyAsset(Ljava/lang/String;Ljava/io/File;)V
 new-instance v1,Ljava/io/File;
 const-string v2,"butterscotch/library.json"
 invoke-direct {v1,v0,v2},Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
 invoke-virtual {v1},Ljava/io/File;->exists()Z
 move-result v2
 if-nez v2,:index_done
 const-string v2,"ddtlq/library.json"
 invoke-direct {p0,v2,v1},Lcom/qianliexian/ddtlq/Launcher;->copyAsset(Ljava/lang/String;Ljava/io/File;)V
 :index_done
 new-instance v1,Ljava/io/File;
 const-string v2,"butterscotch/games/data/224b6ad0-f10d-4d22-a43d-000002010400/saves/00000000-0000-4000-8000-000000000001/Memory Quartz Line 99.ini"
 invoke-direct {v1,v0,v2},Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
 invoke-virtual {v1},Ljava/io/File;->exists()Z
 move-result v2
 if-nez v2,:save_done
 const-string v2,"ddtlq/full-save.ini"
 invoke-direct {p0,v2,v1},Lcom/qianliexian/ddtlq/Launcher;->copyAsset(Ljava/lang/String;Ljava/io/File;)V
 :save_done
 const-string v1,"net.perfectdreams.butterscotch.android.ButterscotchNative"
 invoke-static {v1},Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;
 new-instance v1,Lcom/qianliexian/ddtlq/Launcher$Ready;
 const/4 v2,0x0
 invoke-direct {v1,p0,v2},Lcom/qianliexian/ddtlq/Launcher$Ready;-><init>(Lcom/qianliexian/ddtlq/Launcher;Ljava/lang/String;)V
 invoke-virtual {p0,v1},Lcom/qianliexian/ddtlq/Launcher;->runOnUiThread(Ljava/lang/Runnable;)V
 :try_end
 .catch Ljava/lang/Throwable; {:try_start .. :try_end} :failed
 return-void
 :failed
 move-exception v0
 invoke-static {p0,v0},Lcom/qianliexian/ddtlq/CrashApp;->record(Landroid/content/Context;Ljava/lang/Throwable;)V
 invoke-virtual {v0},Ljava/lang/Throwable;->toString()Ljava/lang/String;
 move-result-object v0
 new-instance v1,Lcom/qianliexian/ddtlq/Launcher$Ready;
 invoke-direct {v1,p0,v0},Lcom/qianliexian/ddtlq/Launcher$Ready;-><init>(Lcom/qianliexian/ddtlq/Launcher;Ljava/lang/String;)V
 invoke-virtual {p0,v1},Lcom/qianliexian/ddtlq/Launcher;->runOnUiThread(Ljava/lang/Runnable;)V
 return-void
.end method

.method public ready(Ljava/lang/String;)V
 .locals 2
 iget-object v0,p0,Lcom/qianliexian/ddtlq/Launcher;->status:Landroid/widget/TextView;
 if-nez p1,:error
 const-string v1,"左スティックで移動します。決定・戻る・一時停止はタッチ操作にも対応しています。画面上部中央の「ヘルプ」から、図鑑・ギャラリー・リソースの設定を利用できます。補助コピーを読み込むと、シーンの切り替えが検証されます。エラーレポートはこのページで確認できます。"
 invoke-virtual {v0,v1},Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
 const/4 v1,0x1
 iget-object v0,p0,Lcom/qianliexian/ddtlq/Launcher;->startButton:Landroid/widget/Button;
 invoke-virtual {v0,v1},Landroid/widget/Button;->setEnabled(Z)V
 iget-object v0,p0,Lcom/qianliexian/ddtlq/Launcher;->manageButton:Landroid/widget/Button;
 invoke-virtual {v0,v1},Landroid/widget/Button;->setEnabled(Z)V
 return-void
 :error
 invoke-virtual {v0,p1},Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
 return-void
.end method

.method public onClick(Landroid/view/View;)V
 .locals 4
 invoke-virtual {p1},Landroid/view/View;->getId()I
 move-result v0
 const/4 v1,0x3
 if-ne v0,v1,:normal_click
 invoke-static {p0},Lcom/qianliexian/ddtlq/CrashApp;->report(Landroid/content/Context;)Ljava/lang/String;
 move-result-object v0
 iget-object v1,p0,Lcom/qianliexian/ddtlq/Launcher;->status:Landroid/widget/TextView;
 invoke-virtual {v1,v0},Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
 const-string v1,"clipboard"
 invoke-virtual {p0,v1},Lcom/qianliexian/ddtlq/Launcher;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
 move-result-object v1
 check-cast v1,Landroid/content/ClipboardManager;
 const-string v2,"DDTLQ 起動ログ"
 invoke-static {v2,v0},Landroid/content/ClipData;->newPlainText(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Landroid/content/ClipData;
 move-result-object v2
 invoke-virtual {v1,v2},Landroid/content/ClipboardManager;->setPrimaryClip(Landroid/content/ClipData;)V
 return-void
 :normal_click
 const/4 v1,0x1
 if-ne v0,v1,:manage
 const-string v0,"net.perfectdreams.butterscotch.android.GameActivity"
 goto :intent
 :manage
 const-string v0,"net.perfectdreams.butterscotch.android.MainActivity"
 :intent
 new-instance v2,Landroid/content/Intent;
 invoke-direct {v2},Landroid/content/Intent;-><init>()V
 invoke-virtual {p0},Lcom/qianliexian/ddtlq/Launcher;->getPackageName()Ljava/lang/String;
 move-result-object v3
 invoke-virtual {v2,v3,v0},Landroid/content/Intent;->setClassName(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;
 invoke-virtual {p1},Landroid/view/View;->getId()I
 move-result v0
 if-ne v0,v1,:launch
 const-string v0,"net.perfectdreams.butterscotch.android.EXTRA_GAME_ID"
 const-string v1,"224b6ad0-f10d-4d22-a43d-000002010400"
 invoke-virtual {v2,v0,v1},Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;
 :launch
 invoke-virtual {p0,v2},Lcom/qianliexian/ddtlq/Launcher;->startActivity(Landroid/content/Intent;)V
 return-void
.end method
