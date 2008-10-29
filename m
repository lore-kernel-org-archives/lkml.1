Return-Path: <linux-kernel-owner+w=401wt.eu-S1759276AbYJ2XFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759276AbYJ2XFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 19:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbYJ2XDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 19:03:08 -0400
Received: from kroah.org ([198.145.64.141]:35901 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756455AbYJ2XDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 19:03:06 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tsugikazu Shibata <tshibata@ab.jp.nec.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 5/6] HOWTO: Sync patch for jp_JP/HOWTO
Date: Wed, 29 Oct 2008 15:58:11 -0700
Message-Id: <1225321092-21933-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081029223824.GB21657@kroah.com>
References: <20081029223824.GB21657@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tsugikazu Shibata <tshibata@ab.jp.nec.com>

Sync the jp_JP version of HOWTO to contain the latest updates

From: Tsugikazu Shibata <tshibata@ab.jp.nec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/ja_JP/HOWTO |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/ja_JP/HOWTO b/Documentation/ja_JP/HOWTO
index 0775cf4..5547698 100644
--- a/Documentation/ja_JP/HOWTO
+++ b/Documentation/ja_JP/HOWTO
@@ -11,14 +11,14 @@ for non English (read: Japanese) speakers and is not intended as a
 fork. So if you have any comments or updates for this file, please try
 to update the original English file first.
 
-Last Updated: 2008/08/21
+Last Updated: 2008/10/24
 ==================================
 これは、
-linux-2.6.27/Documentation/HOWTO
+linux-2.6.28/Documentation/HOWTO
 の和訳です。
 
 翻訳団体： JF プロジェクト < http://www.linux.or.jp/JF/ >
-翻訳日： 2008/8/5
+翻訳日： 2008/10/24
 翻訳者： Tsugikazu Shibata <tshibata at ab dot jp dot nec dot com>
 校正者： 松倉さん <nbh--mats at nifty dot com>
          小林 雅典さん (Masanori Kobayasi) <zap03216 at nifty dot ne dot jp>
@@ -110,8 +110,8 @@ Linux カーネルソースツリーは幅広い範囲のドキュメントを
 新しいドキュメントファイルも追加することを勧めます。
 カーネルの変更が、カーネルがユーザ空間に公開しているインターフェイスの
 変更を引き起こす場合、その変更を説明するマニュアルページのパッチや情報
-をマニュアルページのメンテナ mtk.manpages@gmail.com に送ることを勧めま
-す。
+をマニュアルページのメンテナ mtk.manpages@gmail.com に送り、CC を
+linux-api@ver.kernel.org に送ることを勧めます。
 
 以下はカーネルソースツリーに含まれている読んでおくべきファイルの一覧で
 す-
@@ -149,7 +149,7 @@ Linux カーネルソースツリーは幅広い範囲のドキュメントを
      この他にパッチを作る方法についてのよくできた記述は-
 
 	"The Perfect Patch"
-		http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt
+		http://userweb.kernel.org/~akpm/stuff/tpp.txt
 	"Linux kernel patch submission format"
 		http://linux.yyz.us/patch-format.html
 
@@ -664,7 +664,7 @@ Linux カーネルコミュニティは、一度に大量のコードの塊を
 これについて全てがどのようにあるべきかについての詳細は、以下のドキュメ
 ントの ChangeLog セクションを見てください-
   "The Perfect Patch"
-      http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt
+      http://userweb.kernel.org/~akpm/stuff/tpp.txt
 
 これらのどれもが、時にはとても困難です。これらの慣例を完璧に実施するに
 は数年かかるかもしれません。これは継続的な改善のプロセスであり、そのた
-- 
1.6.0.2

