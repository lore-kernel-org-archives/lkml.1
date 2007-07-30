Return-Path: <linux-kernel-owner+w=401wt.eu-S969330AbXG3WKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969330AbXG3WKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 18:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969152AbXG3WKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 18:10:25 -0400
Received: from ns1.suse.de ([195.135.220.2]:40364 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S969012AbXG3WKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 18:10:23 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tsugikazu Shibata <tshibata@ab.jp.nec.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 02/11] HOWTO: sync Japanese HOWTO
Date: Mon, 30 Jul 2007 15:09:24 -0700
Message-Id: <11858333772499-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <1185833373286-git-send-email-gregkh@suse.de>
References: <20070730220829.GB5263@kroah.com>
 <1185833373286-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tsugikazu Shibata <tshibata@ab.jp.nec.com>

Signed-off-by: Tsugikazu Shibata <tshibata@ab.jp.nec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/ja_JP/HOWTO |   66 ++++++++++++++++++++++++---------------------
 1 files changed, 35 insertions(+), 31 deletions(-)

diff --git a/Documentation/ja_JP/HOWTO b/Documentation/ja_JP/HOWTO
index b2446a0..9f08dab 100644
--- a/Documentation/ja_JP/HOWTO
+++ b/Documentation/ja_JP/HOWTO
@@ -1,23 +1,24 @@
-NOTE:
-This is Japanese translated version of "Documentation/HOWTO".
-This one is maintained by Tsugikazu Shibata <tshibata@ab.jp.nec.com>
-and JF Project team <www.linux.or.jp/JF>.
-If you find difference with original file or problem in translation,
-please contact maintainer of this file or JF project.
-
-Please also note that purpose of this file is easier to read for non
-English natives and not to be intended to fork. So, if you have any
-comments or updates of this file, please try to update Original(English)
-file at first.
-
-Last Updated: 2007/06/04
+﻿NOTE:
+This is a version of Documentation/HOWTO translated into Japanese.
+This document is maintained by Tsugikazu Shibata <tshibata@ab.jp.nec.com>
+and the JF Project team <www.linux.or.jp/JF>.
+If you find any difference between this document and the original file
+or a problem with the translation,
+please contact the maintainer of this file or JF project.
+
+Please also note that the purpose of this file is to be easier to read
+for non English (read: Japanese) speakers and is not intended as a
+fork. So if you have any comments or updates for this file, please try
+to update the original English file first.
+
+Last Updated: 2007/07/18
 ==================================
 これは、
-linux-2.6.21/Documentation/HOWTO
+linux-2.6.22/Documentation/HOWTO
 の和訳です。
 
 翻訳団体： JF プロジェクト < http://www.linux.or.jp/JF/ >
-翻訳日： 2007/06/04
+翻訳日： 2007/07/16
 翻訳者： Tsugikazu Shibata <tshibata at ab dot jp dot nec dot com>
 校正者： 松倉さん <nbh--mats at nifty dot com>
          小林 雅典さん (Masanori Kobayasi) <zap03216 at nifty dot ne dot jp>
@@ -52,6 +53,7 @@ Linux カーネル開発コミュニティと共に活動するやり方を学�
 また、このコミュニティがなぜ今うまくまわっているのかという理由の一部も
 説明しようと試みています。
 
+
 カーネルは 少量のアーキテクチャ依存部分がアセンブリ言語で書かれている
 以外は大部分は C 言語で書かれています。C言語をよく理解していることはカー
 ネル開発者には必要です。アーキテクチャ向けの低レベル部分の開発をするの
@@ -141,6 +143,7 @@ Linux カーネルソースツリーは幅広い範囲のドキュメントを�
      これらのルールに従えばうまくいくことを保証することではありません
      が (すべてのパッチは内容とスタイルについて精査を受けるので)、
      ルールに従わなければ間違いなくうまくいかないでしょう。
+
      この他にパッチを作る方法についてのよくできた記述は-
 
 	"The Perfect Patch"
@@ -360,44 +363,42 @@ linux-kernel メーリングリストで収集された多数のパッチと同�
 
   git ツリー-
     - Kbuild の開発ツリー、Sam Ravnborg <sam@ravnborg.org>
-	kernel.org:/pub/scm/linux/kernel/git/sam/kbuild.git
+	git.kernel.org:/pub/scm/linux/kernel/git/sam/kbuild.git
 
     - ACPI の開発ツリー、 Len Brown <len.brown@intel.com>
-	kernel.org:/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
+	git.kernel.org:/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
 
     - Block の開発ツリー、Jens Axboe <axboe@suse.de>
-	kernel.org:/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
+	git.kernel.org:/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
 
     - DRM の開発ツリー、Dave Airlie <airlied@linux.ie>
-	kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
+	git.kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
 
     - ia64 の開発ツリー、Tony Luck <tony.luck@intel.com>
-	kernel.org:/pub/scm/linux/kernel/git/aegl/linux-2.6.git
-
-    - ieee1394 の開発ツリー、Jody McIntyre <scjody@modernduck.com>
-	kernel.org:/pub/scm/linux/kernel/git/scjody/ieee1394.git
+	git.kernel.org:/pub/scm/linux/kernel/git/aegl/linux-2.6.git
 
     - infiniband, Roland Dreier <rolandd@cisco.com>
-	kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git
+	git.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git
 
     - libata, Jeff Garzik <jgarzik@pobox.com>
-	kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
+	git.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
 
     - ネットワークドライバ, Jeff Garzik <jgarzik@pobox.com>
-	kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git
+	git.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git
 
     - pcmcia, Dominik Brodowski <linux@dominikbrodowski.net>
-	kernel.org:/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
+	git.kernel.org:/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
 
     - SCSI, James Bottomley <James.Bottomley@SteelEye.com>
-	kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
-
-  その他の git カーネルツリーは http://kernel.org/git に一覧表がありま
-  す。
+	git.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
 
   quilt ツリー-
     - USB, PCI ドライバコアと I2C, Greg Kroah-Hartman <gregkh@suse.de>
 	kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
+    - x86-64 と i386 の仲間 Andi Kleen <ak@suse.de>
+
+  その他のカーネルツリーは http://git.kernel.org/ と MAINTAINERS ファ
+  イルに一覧表があります。
 
 バグレポート
 -------------
@@ -508,6 +509,7 @@ MAINTAINERS ファイルにリストがありますので参照してくださ�
 せん*。単に自分のパッチに対して指摘された問題を全て修正して再送すれば
 いいのです。
 
+
 カーネルコミュニティと企業組織のちがい
 -----------------------------------------------------------------
 
@@ -577,6 +579,7 @@ Linux カーネルコミュニティは、一度に大量のコードの塊を�
    かし、500行のパッチは、正しいことをレビューするのに数時間かかるかも
    しれません(時間はパッチのサイズなどにより指数関数に比例してかかりま
    す)
+
    小さいパッチは何かあったときにデバッグもとても簡単になります。パッ
    チを1個1個取り除くのは、とても大きなパッチを当てた後に(かつ、何かお
    かしくなった後で)解剖するのに比べればとても簡単です。
@@ -591,6 +594,7 @@ Linux カーネルコミュニティは、一度に大量のコードの塊を�
         う。先生は簡潔な最高の解をみたいのです。良い生徒はこれを知って
         おり、そして最終解の前の中間作業を提出することは決してないので
         す"
+
         カーネル開発でもこれは同じです。メンテナー達とレビューア達は、
         問題を解決する解の背後になる思考プロセスをみたいとは思いません。
         彼らは単純であざやかな解決方法をみたいのです。
-- 
1.5.2.2

