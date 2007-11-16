Return-Path: <linux-kernel-owner+w=401wt.eu-S1757564AbXKPSmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbXKPSmF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 13:42:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbXKPSlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 13:41:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52849 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757789AbXKPSlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 13:41:16 -0500
Date: Fri, 16 Nov 2007 10:39:55 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.23.2
Message-ID: <20071116183955.GD9807@kroah.com>
References: <20071116183752.GA9807@kroah.com> <20071116183940.GC9807@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071116183940.GC9807@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Documentation/ja_JP/HOWTO b/Documentation/ja_JP/HOWTO
index 9f08dab..d9d832c 100644
--- a/Documentation/ja_JP/HOWTO
+++ b/Documentation/ja_JP/HOWTO
@@ -1,4 +1,4 @@
-ï»¿NOTE:
+NOTE:
 This is a version of Documentation/HOWTO translated into Japanese.
 This document is maintained by Tsugikazu Shibata <tshibata@ab.jp.nec.com>
 and the JF Project team <www.linux.or.jp/JF>.
@@ -11,14 +11,14 @@ for non English (read: Japanese) speakers and is not intended as a
 fork. So if you have any comments or updates for this file, please try
 to update the original English file first.
 
-Last Updated: 2007/07/18
+Last Updated: 2007/09/23
 ==================================
 ããã¯ã
-linux-2.6.22/Documentation/HOWTO
+linux-2.6.23/Documentation/HOWTO
 ã®åè¨³ã§ãã
 
 ç¿»è¨³å£ä½ï¼ JF ãã­ã¸ã§ã¯ã < http://www.linux.or.jp/JF/ >
-ç¿»è¨³æ¥ï¼ 2007/07/16
+ç¿»è¨³æ¥ï¼ 2007/09/19
 ç¿»è¨³èï¼ Tsugikazu Shibata <tshibata at ab dot jp dot nec dot com>
 æ ¡æ­£èï¼ æ¾åãã <nbh--mats at nifty dot com>
          å°æ éå¸ãã (Masanori Kobayasi) <zap03216 at nifty dot ne dot jp>
@@ -27,6 +27,7 @@ linux-2.6.22/Documentation/HOWTO
          éå£ãã (Kenji Noguchi) <tokyo246 at gmail dot com>
          æ²³åãã (Takayoshi Kochi) <t-kochi at bq dot jp dot nec dot com>
          å²©æ¬ãã (iwamoto) <iwamoto.kn at ncos dot nec dot co dot jp>
+         åç°ãã (Satoshi Uchida) <s-uchida at ap dot jp dot nec dot com>
 ==================================
 
 Linux ã«ã¼ãã«éçºã®ããæ¹
@@ -40,7 +41,7 @@ Linux ã«ã¼ãã«éçºã³ãã¥ããã£ã¨å±ã«æ´»åããããæ¹ãå­¦ã
 æå©ãã«ãªãã¾ãã
 
 ããããã®ãã­ã¥ã¡ã³ãã®ã©ãããå¤ããªã£ã¦ããå ´åã«ã¯ããã®ãã­ã¥ã¡ã³
-ãã®æå¾ã«ãªã¹ãããã¡ã³ããã¼ã«ããããéã£ã¦ãã ããã
+ãã®æå¾ã«ãªã¹ãããã¡ã³ããã«ããããéã£ã¦ãã ããã
 
 ã¯ããã«
 ---------
@@ -59,7 +60,7 @@ Linux ã«ã¼ãã«éçºã³ãã¥ããã£ã¨å±ã«æ´»åããããæ¹ãå­¦ã
 ãã«éçºèã«ã¯å¿è¦ã§ããã¢ã¼ã­ãã¯ãã£åãã®ä½ã¬ãã«é¨åã®éçºãããã®
 ã§ãªããã°ã(ã©ããªã¢ã¼ã­ãã¯ãã£ã§ã)ã¢ã»ã³ããª(è¨³æ³¨: è¨èª)ã¯å¿è¦ãã
 ã¾ãããä»¥ä¸ã®æ¬ã¯ãC è¨èªã®ååãªç¥è­ãä½å¹´ãã®çµé¨ã«åã£ã¦ä»£ãããã®
-ã§ã¯ããã¾ããããå°ãªãã¨ããªãã¡ã¬ã³ã¹ã¨ãã¦ã¯ããæ¬ã§ãã
+ã§ã¯ããã¾ããããå°ãªãã¨ããªãã¡ã¬ã³ã¹ã¨ãã¦ã¯è¯ãæ¬ã§ãã
  - "The C Programming Language" by Kernighan and Ritchie [Prentice Hall]
  -ããã­ã°ã©ãã³ã°è¨èªï¼£ç¬¬2çã(B.W. ã«ã¼ããã³/D.M. ãªããã¼è ç³ç°æ´ä¹è¨³) [å±ç«åºç]
  - "Practical C Programming" by Steve Oualline [O'Reilly]
@@ -76,7 +77,7 @@ Linux ã«ã¼ãã«éçºã³ãã¥ããã£ã¨å±ã«æ´»åããããæ¹ãå­¦ã
 ã¨ãã©ããã«ã¼ãã«ããã¼ã«ãã§ã¤ã³ã C è¨èªæ¡å¼µã«ç½®ãã¦ããåæãã©ã
 ãªã£ã¦ããã®ããããã«ãããã¨ããããã¾ããæ®å¿µãªãã¨ã«æ±ºå®çãªãªãã¡
 ã¬ã³ã¹ã¯å­å¨ãã¾ãããæå ±ãå¾ãã«ã¯ãgcc ã® info ãã¼ã¸( info gcc )ã
-ã¿ã¦ãã ããã
+è¦ã¦ãã ããã
 
 ããªãã¯æ¢å­ã®éçºã³ãã¥ããã£ã¨ä¸ç·ã«ä½æ¥­ããæ¹æ³ãå­¦ã¼ãã¨ãã¦ããã
 ã¨ã«çæãã¦ãã ããããã®ã³ãã¥ããã£ã¯ãã³ã¼ãã£ã³ã°ãã¹ã¿ã¤ã«ã
@@ -92,7 +93,7 @@ Linux ã«ã¼ãã«éçºã³ãã¥ããã£ã¨å±ã«æ´»åããããæ¹ãå­¦ã
 
 Linux ã«ã¼ãã«ã®ã½ã¼ã¹ã³ã¼ãã¯ GPL ã©ã¤ã»ã³ã¹ã®ä¸ã§ãªãªã¼ã¹ããã¦ãã¾
 ããã©ã¤ã»ã³ã¹ã®è©³ç´°ã«ã¤ãã¦ã¯ãã½ã¼ã¹ããªã¼ã®ã¡ã¤ã³ãã£ã¬ã¯ããªã«å­å¨
-ãããCOPYING ã®ãã¡ã¤ã«ãã¿ã¦ãã ãããããã©ã¤ã»ã³ã¹ã«ã¤ãã¦ããã«è³ª
+ãããCOPYING ã®ãã¡ã¤ã«ãè¦ã¦ãã ãããããã©ã¤ã»ã³ã¹ã«ã¤ãã¦ããã«è³ª
 åãããã°ãLinux Kernel ã¡ã¼ãªã³ã°ãªã¹ãã«è³ªåããã®ã§ã¯ãªããã©ãã
 æ³å¾å®¶ã«ç¸è«ãã¦ãã ãããã¡ã¼ãªã³ã°ãªã¹ãã®äººéã¯æ³å¾å®¶ã§ã¯ãªããæ³ç
 åé¡ã«ã¤ãã¦ã¯å½¼ãã®å£°æã¯ãã¦ã«ããã¹ãã§ã¯ããã¾ããã
@@ -109,7 +110,8 @@ Linux ã«ã¼ãã«ã½ã¼ã¹ããªã¼ã¯å¹åºãç¯å²ã®ãã­ã¥ã¡ã³ããå
 æ°ãããã­ã¥ã¡ã³ããã¡ã¤ã«ãè¿½å ãããã¨ãå§ãã¾ãã
 ã«ã¼ãã«ã®å¤æ´ããã«ã¼ãã«ãã¦ã¼ã¶ç©ºéã«å¬éãã¦ããã¤ã³ã¿ã¼ãã§ã¤ã¹ã®
 å¤æ´ãå¼ãèµ·ããå ´åããã®å¤æ´ãèª¬æããããã¥ã¢ã«ãã¼ã¸ã®ããããæå ±
-ãããã¥ã¢ã«ãã¼ã¸ã®ã¡ã³ãã mtk-manpages@gmx.net ã«éããã¨ãå§ãã¾ãã
+ãããã¥ã¢ã«ãã¼ã¸ã®ã¡ã³ãã mtk-manpages@gmx.net ã«éããã¨ãå§ãã¾
+ãã
 
 ä»¥ä¸ã¯ã«ã¼ãã«ã½ã¼ã¹ããªã¼ã«å«ã¾ãã¦ããèª­ãã§ããã¹ããã¡ã¤ã«ã®ä¸è¦§ã§
 ã-
@@ -117,7 +119,7 @@ Linux ã«ã¼ãã«ã½ã¼ã¹ããªã¼ã¯å¹åºãç¯å²ã®ãã­ã¥ã¡ã³ããå
   README
     ãã®ãã¡ã¤ã«ã¯ Linuxã«ã¼ãã«ã®ç°¡åãªèæ¯ã¨ã«ã¼ãã«ãè¨­å®(è¨³æ³¨
     configure )ããçæ(è¨³æ³¨ build )ããããã«å¿è¦ãªãã¨ã¯ä½ããæ¸ãã
-    ã¦ãã¾ããã«ã¼ãã«ã«é¢ãã¦åãã¦ã®äººã¯ããããã¹ã¿ã¼ãããã¨ããã§
+    ã¦ãã¾ããã«ã¼ãã«ã«é¢ãã¦åãã¦ã®äººã¯ããããã¹ã¿ã¼ãããã¨è¯ãã§
     ãããã
 
   Documentation/Changes
@@ -128,7 +130,7 @@ Linux ã«ã¼ãã«ã½ã¼ã¹ããªã¼ã¯å¹åºãç¯å²ã®ãã­ã¥ã¡ã³ããå
   Documentation/CodingStyle
     ããã¯ Linux ã«ã¼ãã«ã®ã³ã¼ãã£ã³ã°ã¹ã¿ã¤ã«ã¨èæ¯ã«ããçç±ãè¨è¿°
     ãã¦ãã¾ããå¨ã¦ã®æ°ããã³ã¼ãã¯ãã®ãã­ã¥ã¡ã³ãã«ããã¬ã¤ãã©ã¤ã³
-    ã«å¾ã£ã¦ãããã¨ãæå¾ããã¦ãã¾ããå¤§é¨åã®ã¡ã³ããã¼ã¯ãããã®ã«ã¼
+    ã«å¾ã£ã¦ãããã¨ãæå¾ããã¦ãã¾ããå¤§é¨åã®ã¡ã³ããã¯ãããã®ã«ã¼
     ã«ã«å¾ã£ã¦ãããã®ã ããåãä»ããå¤ãã®äººã¯æ­£ããã¹ã¿ã¤ã«ã®ã³ã¼ã
     ã ããã¬ãã¥ã¼ãã¾ãã
 
@@ -168,16 +170,16 @@ Linux ã«ã¼ãã«ã½ã¼ã¹ããªã¼ã¯å¹åºãç¯å²ã®ãã­ã¥ã¡ã³ããå
     æ¯æ´ãã¦ãã ããã
 
   Documentation/ManagementStyle
-    ãã®ãã­ã¥ã¡ã³ãã¯ Linux ã«ã¼ãã«ã®ã¡ã³ããã¼éãã©ãè¡åãããã
+    ãã®ãã­ã¥ã¡ã³ãã¯ Linux ã«ã¼ãã«ã®ã¡ã³ããéãã©ãè¡åãããã
     å½¼ãã®ææ³ã®èæ¯ã«ããå±æããã¦ããç²¾ç¥ã«ã¤ãã¦è¨è¿°ãã¦ãã¾ããã
     ãã¯ã«ã¼ãã«éçºã®åå¿èãªãï¼ãããã¯ãåã«èå³ãããã ãã®äººã§ãï¼
-    éè¦ã§ãããªããªããã®ãã­ã¥ã¡ã³ãã¯ãã«ã¼ãã«ã¡ã³ããã¼éã®ç¬ç¹ãª
+    éè¦ã§ãããªããªããã®ãã­ã¥ã¡ã³ãã¯ãã«ã¼ãã«ã¡ã³ããéã®ç¬ç¹ãª
     è¡åã«ã¤ãã¦ã®å¤ãã®èª¤è§£ãæ··ä¹±ãè§£æ¶ããããã§ãã
 
   Documentation/stable_kernel_rules.txt
     ãã®ãã¡ã¤ã«ã¯ã©ã®ããã« stable ã«ã¼ãã«ã®ãªãªã¼ã¹ãè¡ããããã®ã«ã¼
     ã«ãè¨è¿°ããã¦ãã¾ããããã¦ãããã®ãªãªã¼ã¹ã®ä¸­ã®ã©ããã§å¤æ´ãå
-    ãå¥ãã¦ãããããå ´åã«ä½ãããã°ããããç¤ºããã¦ãã¾ãã
+    ãå¥ãã¦ãããããå ´åã«ä½ãããã°è¯ãããç¤ºããã¦ãã¾ãã
 
   Documentation/kernel-docs.txt
 ããã«ã¼ãã«éçºã«ä»éããå¤é¨ãã­ã¥ã¡ã³ãã®ãªã¹ãã§ããããããªãã
@@ -218,9 +220,9 @@ web ãµã¤ãã«ã¯ãã³ã¼ãã®æ§æããµãã·ã¹ãã ãç¾å¨å­å¨ãã
 ããã«ã¯ãã¾ããã«ã¼ãã«ã®ã³ã³ãã¤ã«ã®ããæ¹ããããã®å½ã¦æ¹ãªã©ã®éæ¥
 çãªåºæ¬æå ±ãè¨è¿°ããã¦ãã¾ãã
 
-ããªããã©ãããã¹ã¿ã¼ããã¦ãããããããªãããLinux ã«ã¼ãã«éçºã³ãã¥
+ããªããã©ãããã¹ã¿ã¼ããã¦è¯ããããããªãããLinux ã«ã¼ãã«éçºã³ãã¥
 ããã£ã«åå ãã¦ä½ããããã¨ããããã¦ããå ´åã«ã¯ãLinux kernel
-Janitor's ãã­ã¸ã§ã¯ãã«ããã°ããã§ããã -
+Janitor's ãã­ã¸ã§ã¯ãã«ããã°è¯ãã§ããã -
 	http://janitor.kernelnewbies.org/
 ããã¯ãã®ãããªã¹ã¿ã¼ããããã®ã«ãã£ã¦ã¤ãã®å ´æã§ããããã«ã¯ã
 Linux ã«ã¼ãã«ã½ã¼ã¹ããªã¼ã®ä¸­ã«å«ã¾ããããããã«ããä¿®æ­£ããªããã°ãª
@@ -243,7 +245,7 @@ Linux ã«ã¼ãã«ã½ã¼ã¹ããªã¼ã®ä¸­ã«å«ã¾ããããããã«ããä¿
 èªå·±åç§æ¹å¼ã§ãç´¢å¼ãã¤ãã web å½¢å¼ã§ãã½ã¼ã¹ã³ã¼ããåç§ãããã¨ã
 ã§ãã¾ãããã®ææ°ã®ç´ æ´ããã«ã¼ãã«ã³ã¼ãã®ãªãã¸ããªã¯ä»¥ä¸ã§è¦ã¤ãã
 ã¾ã-
-	http://sosdg.org/~coywolf/lxr/
+	http://sosdg.org/~qiyong/lxr/
 
 éçºãã­ã»ã¹
 -----------------------
@@ -265,9 +267,9 @@ Linux ã«ã¼ãã«ã®éçºãã­ã»ã¹ã¯ç¾å¨å¹¾ã¤ãã®ç°ãªãã¡ã¤ã³ã
 ä»¥ä¸ã®ã¨ãã-
 
   - æ°ããã«ã¼ãã«ããªãªã¼ã¹ãããç´å¾ã«ã2é±éã®ç¹å¥æéãè¨­ãããã
-    ãã®æéä¸­ã«ãã¡ã³ããã¼éã¯ Linus ã«å¤§ããªå·®åãéããã¨ãã§ãã¾
-    ãããã®ãããªå·®åã¯éå¸¸ -mm ã«ã¼ãã«ã«æ°é±éå«ã¾ãã¦ãããããã§
-    ãã å¤§ããªå¤æ´ã¯ git(ã«ã¼ãã«ã®ã½ã¼ã¹ç®¡çãã¼ã«ãè©³ç´°ã¯
+    ãã®æéä¸­ã«ãã¡ã³ããéã¯ Linus ã«å¤§ããªå·®åãéããã¨ãã§ãã¾ãã
+    ãã®ãããªå·®åã¯éå¸¸ -mm ã«ã¼ãã«ã«æ°é±éå«ã¾ãã¦ãããããã§ãã
+    å¤§ããªå¤æ´ã¯ git(ã«ã¼ãã«ã®ã½ã¼ã¹ç®¡çãã¼ã«ãè©³ç´°ã¯
     http://git.or.cz/  åç§) ãä½¿ã£ã¦éãã®ãå¥½ã¾ããããæ¹ã§ããããã
     ããã¡ã¤ã«ã®å½¢å¼ã®ã¾ã¾éãã®ã§ãååã§ãã
 
@@ -285,6 +287,10 @@ Linux ã«ã¼ãã«ã®éçºãã­ã»ã¹ã¯ç¾å¨å¹¾ã¤ãã®ç°ãªãã¡ã¤ã³ã
     ã«å®å®ããç¶æã«ããã¨å¤æ­ããã¨ãã«ãªãªã¼ã¹ããã¾ããç®æ¨ã¯æ¯é±æ°
     ãã -rc ã«ã¼ãã«ããªãªã¼ã¹ãããã¨ã§ãã
 
+   - ä»¥ä¸ã® URL ã§å -rc ãªãªã¼ã¹ã«å­å¨ããæ¢ç¥ã®å¾æ»ãåé¡ã®ãªã¹ã
+     ãè¿½è·¡ããã¾ã-
+     http://kernelnewbies.org/known_regressions
+
   - ãã®ãã­ã»ã¹ã¯ã«ã¼ãã«ã ãæºåãã§ãããã¨èããããã¾ã§ç¶ç¶ãã¾
     ãããã®ãã­ã»ã¹ã¯ã ããã 6é±éç¶ç¶ãã¾ãã
 
@@ -331,8 +337,8 @@ Andrew ã¯åå¥ã®ãµãã·ã¹ãã ã«ã¼ãã«ããªã¼ã¨ããããå¨ã¦é
 linux-kernel ã¡ã¼ãªã³ã°ãªã¹ãã§åéãããå¤æ°ã®ãããã¨åæã«ä¸ã¤ã«ã¾
 ã¨ãã¾ãã
 ãã®ããªã¼ã¯æ°æ©è½ã¨ããããæ¤è¨¼ãããå ´ã¨ãªãã¾ããããæéã®éããã
-ã -mm ã«å¥ã£ã¦ä¾¡å¤ãè¨¼æãããããAndrew ããµãã·ã¹ãã ã¡ã³ããããã¡
-ã¤ã³ã©ã¤ã³ã¸å¥ããããã« Linus ã«ããã·ã¥ãã¾ãã
+ã -mm ã«å¥ã£ã¦ä¾¡å¤ãè¨¼æãããããAndrew ããµãã·ã¹ãã ã¡ã³ãããã
+ã¡ã¤ã³ã©ã¤ã³ã¸å¥ããããã« Linus ã«ããã·ã¥ãã¾ãã
 
 ã¡ã¤ã³ã«ã¼ãã«ããªã¼ã«å«ããããã« Linus ã«éãåã«ããã¹ã¦ã®æ°ãããã
 ãã -mm ããªã¼ã§ãã¹ãããããã¨ãå¼·ãæ¨å¥¨ããã¾ãã
@@ -460,7 +466,7 @@ MAINTAINERS ãã¡ã¤ã«ã«ãªã¹ããããã¾ãã®ã§åç§ãã¦ãã ãã
 ãã-
 å½¼ãã¯ããªãã®ãããã®è¡æ¯ã«ã³ã¡ã³ããå¥ãããã®ã§ããã®ããã«ã¯ããã
 ãããããã¾ãããããªãã®ã¡ã¼ã«ãã­ã°ã©ã ãç©ºç½ãã¿ããå§ç¸®ããªããã
-ã«ç¢ºèªããæ¹ãããã§ããæåã®è¯ããã¹ãã¨ãã¦ã¯ãèªåã«ã¡ã¼ã«ãéã£ã¦
+ã«ç¢ºèªããæ¹ãè¯ãã§ããæåã®è¯ããã¹ãã¨ãã¦ã¯ãèªåã«ã¡ã¼ã«ãéã£ã¦
 ã¿ã¦ããã®ããããèªåã§å½ã¦ã¦ã¿ããã¨ã§ããããããããã¾ãè¡ããªããª
 ããããªãã®ã¡ã¼ã«ãã­ã°ã©ã ãç´ãã¦ãããããæ­£ããåãããã«å¤ããã¹
 ãã§ãã
@@ -507,14 +513,14 @@ MAINTAINERS ãã¡ã¤ã«ã«ãªã¹ããããã¾ãã®ã§åç§ãã¦ãã ãã
 ã¨ãæ®éã®ãã¨ã§ããããã¯ããªãã®ããããåãå¥ããããªãã¨ãããã¨ã§
 ã¯ *ããã¾ãã*ãããã¦ããªãèªèº«ã«åå¯¾ãããã¨ãæå³ããã®ã§ã *ããã¾
 ãã*ãåã«èªåã®ãããã«å¯¾ãã¦ææãããåé¡ãå¨ã¦ä¿®æ­£ãã¦åéããã°
-ããã®ã§ãã
+è¯ãã®ã§ãã
 
 
 ã«ã¼ãã«ã³ãã¥ããã£ã¨ä¼æ¥­çµç¹ã®ã¡ãã
 -----------------------------------------------------------------
 
 ã«ã¼ãã«ã³ãã¥ããã£ã¯å¤§é¨åã®ä¼çµ±çãªä¼ç¤¾ã®éçºç°å¢ã¨ã¯ç°ã£ãããæ¹ã§
-åãã¦ãã¾ããä»¥ä¸ã¯åé¡ãé¿ããããã«ã§ããã¨ãããã¨ã®ã®ãªã¹ãã§ã-
+åãã¦ãã¾ããä»¥ä¸ã¯åé¡ãé¿ããããã«ã§ããã¨è¯ããã¨ã®ãªã¹ãã§ã-
 
   ããªãã®ææ¡ããå¤æ´ã«ã¤ãã¦è¨ãã¨ãã®ãã¾ãè¨ãæ¹ï¼
 
@@ -525,7 +531,7 @@ MAINTAINERS ãã¡ã¤ã«ã«ãªã¹ããããã¾ãã®ã§åç§ãã¦ãã ãã
     - "ä»¥ä¸ã¯ä¸é£ã®å°ããªãããç¾¤ã§ãã..."
     - "ããã¯å¸åçãªãã·ã³ã§ã®æ§è½ãåä¸ããã¾ã.."
 
-  ãããæ¹ãããæªãè¨ãæ¹ï¼
+  ãããæ¹ãè¯ãæªãè¨ãæ¹ï¼
 
     - ãã®ããæ¹ã§ AIX/ptx/Solaris ã§ã¯ã§ããã®ã§ãã§ããã¯ãã 
     - ç§ã¯ããã20å¹´ãã®éãã£ã¦ãããã ãã
@@ -575,10 +581,10 @@ Linux ã«ã¼ãã«ã³ãã¥ããã£ã¯ãä¸åº¦ã«å¤§éã®ã³ã¼ãã®å¡ãå
 
 1) å°ãããããã¯ããªãã®ããããé©ç¨ãããè¦è¾¼ã¿ãå¤§ãããã¾ããã«ã¼
    ãã«ã®äººéã¯ããããæ­£ãããã©ãããç¢ºèªããæéãå´åããããªãã
-   ãã§ãã5è¡ã®ãããã¯ã¡ã³ããããã£ã1ç§è¦ãã ãã§é©ç¨ã§ãã¾ããã
-   ããã500è¡ã®ãããã¯ãæ­£ãããã¨ãã¬ãã¥ã¼ããã®ã«æ°æéããããã
-   ããã¾ãã(æéã¯ãããã®ãµã¤ãºãªã©ã«ããææ°é¢æ°ã«æ¯ä¾ãã¦ãããã¾
-   ã)
+   ãã§ãã5è¡ã®ãããã¯ã¡ã³ããããã£ã1ç§è¦ãã ãã§é©ç¨ã§ãã¾ãã
+   ãããã500è¡ã®ãããã¯ãæ­£ãããã¨ãã¬ãã¥ã¼ããã®ã«æ°æéãããã
+   ãããã¾ãã(æéã¯ãããã®ãµã¤ãºãªã©ã«ããææ°é¢æ°ã«æ¯ä¾ãã¦ããã
+   ã¾ã)
 
    å°ãããããã¯ä½ããã£ãã¨ãã«ãããã°ãã¨ã¦ãç°¡åã«ãªãã¾ãããã
    ãã1å1ååãé¤ãã®ã¯ãã¨ã¦ãå¤§ããªããããå½ã¦ãå¾ã«(ãã¤ãä½ãã
@@ -587,23 +593,23 @@ Linux ã«ã¼ãã«ã³ãã¥ããã£ã¯ãä¸åº¦ã«å¤§éã®ã³ã¼ãã®å¡ãå
 2) å°ããããããéãã ãã§ãªããéãã¾ãã«ãæ¸ãç´ãã¦ãã·ã³ãã«ã«ã
    ã(ãããã¯ãåã«é çªãå¤ããã ãã§ã)ãã¨ããã¨ã¦ãéè¦ã§ãã
 
-ä»¥ä¸ã¯ã«ã¼ãã«éçºèã® Al Viro ã®ãã¨ãè©±ãã§ãï¼
+ä»¥ä¸ã¯ã«ã¼ãã«éçºèã® Al Viro ã®ãã¨ãè©±ã§ãï¼
 
         "çå¾ã®æ°å­¦ã®å®¿é¡ãæ¡ç¹ããåçã®ãã¨ãèãã¦ã¿ã¦ãã ãããå
-        çã¯çå¾ãè§£ã«å°éããã¾ã§ã®è©¦è¡é¯èª¤ãã¿ããã¨ã¯æããªãã§ãã
-        ããåçã¯ç°¡æ½ãªæé«ã®è§£ãã¿ããã®ã§ããè¯ãçå¾ã¯ãããç¥ã£ã¦
+        çã¯çå¾ãè§£ã«å°éããã¾ã§ã®è©¦è¡é¯èª¤ãè¦ããã¨ã¯æããªãã§ãã
+        ããåçã¯ç°¡æ½ãªæé«ã®è§£ãè¦ããã®ã§ããè¯ãçå¾ã¯ãããç¥ã£ã¦
         ãããããã¦æçµè§£ã®åã®ä¸­éä½æ¥­ãæåºãããã¨ã¯æ±ºãã¦ãªãã®ã§
         ã"
 
-        ã«ã¼ãã«éçºã§ãããã¯åãã§ããã¡ã³ããã¼éã¨ã¬ãã¥ã¼ã¢éã¯ã
-        åé¡ãè§£æ±ºããè§£ã®èå¾ã«ãªãæèãã­ã»ã¹ãã¿ããã¨ã¯æãã¾ããã
-        å½¼ãã¯åç´ã§ãããããªè§£æ±ºæ¹æ³ãã¿ããã®ã§ãã
+        ã«ã¼ãã«éçºã§ãããã¯åãã§ããã¡ã³ããéã¨ã¬ãã¥ã¼ã¢éã¯ã
+        åé¡ãè§£æ±ºããè§£ã®èå¾ã«ãªãæèãã­ã»ã¹ãè¦ããã¨ã¯æãã¾ããã
+        å½¼ãã¯åç´ã§ãããããªè§£æ±ºæ¹æ³ãè¦ããã®ã§ãã
 
 ãããããªè§£ãèª¬æããã®ã¨ãã³ãã¥ããã£ã¨å±ã«ä»äºãããæªè§£æ±ºã®ä»äºã
 è­°è«ãããã¨ã®ãã©ã³ã¹ãã­ã¼ãããã®ã¯é£ããããããã¾ããã
 ã§ããããéçºãã­ã»ã¹ã®æ©ææ®µéã§æ¹åã®ããã®ãã£ã¼ãããã¯ããããã
-ãã«ããã®ãããã§ãããå¤æ´ç¹ãå°ããé¨åã«åå²ãã¦å¨ä½ã§ã¯ã¾ã å®æã
-ã¦ããªãä»äºã(é¨åçã«)åãè¾¼ãã§ããããããã«ãããã¨ããããã¨ã§ãã
+ãã«ããã®ãè¯ãã§ãããå¤æ´ç¹ãå°ããé¨åã«åå²ãã¦å¨ä½ã§ã¯ã¾ã å®æã
+ã¦ããªãä»äºã(é¨åçã«)åãè¾¼ãã§ããããããã«ãããã¨ãè¯ããã¨ã§ãã
 
 ã¾ããã§ãä¸ãã£ã¦ããªããã®ãã"å°æ¥ç´ã" ãããªãããããæ¬æµã«å«ã
 ã¦ãããããã«éã£ã¦ããããã¯åãä»ããããªããã¨ãçè§£ãã¦ãã ããã
@@ -629,7 +635,7 @@ Linux ã«ã¼ãã«ã³ãã¥ããã£ã¯ãä¸åº¦ã«å¤§éã®ã³ã¼ãã®å¡ãå
   - ãã¹ãçµæ
 
 ããã«ã¤ãã¦å¨ã¦ãã©ã®ããã«ããã¹ããã«ã¤ãã¦ã®è©³ç´°ã¯ãä»¥ä¸ã®ãã­ã¥ã¡
-ã³ãã® ChangeLog ã»ã¯ã·ã§ã³ãã¿ã¦ãã ãã-
+ã³ãã® ChangeLog ã»ã¯ã·ã§ã³ãè¦ã¦ãã ãã-
   "The Perfect Patch"
       http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt
 
diff --git a/Makefile b/Makefile
index c244a02..c6d545c 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 23
-EXTRAVERSION = .1
+EXTRAVERSION = .2
 NAME = Arr Matey! A Hairy Bilge Rat!
 
 # *DOCUMENTATION*
diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index ed39313..026cf24 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -819,7 +819,6 @@ static int __blk_free_tags(struct blk_queue_tag *bqt)
 	retval = atomic_dec_and_test(&bqt->refcnt);
 	if (retval) {
 		BUG_ON(bqt->busy);
-		BUG_ON(!list_empty(&bqt->busy_list));
 
 		kfree(bqt->tag_index);
 		bqt->tag_index = NULL;
@@ -931,7 +930,6 @@ static struct blk_queue_tag *__blk_queue_init_tags(struct request_queue *q,
 	if (init_tag_map(q, tags, depth))
 		goto fail;
 
-	INIT_LIST_HEAD(&tags->busy_list);
 	tags->busy = 0;
 	atomic_set(&tags->refcnt, 1);
 	return tags;
@@ -982,6 +980,7 @@ int blk_queue_init_tags(struct request_queue *q, int depth,
 	 */
 	q->queue_tags = tags;
 	q->queue_flags |= (1 << QUEUE_FLAG_QUEUED);
+	INIT_LIST_HEAD(&q->tag_busy_list);
 	return 0;
 fail:
 	kfree(tags);
@@ -1152,7 +1151,7 @@ int blk_queue_start_tag(struct request_queue *q, struct request *rq)
 	rq->tag = tag;
 	bqt->tag_index[tag] = rq;
 	blkdev_dequeue_request(rq);
-	list_add(&rq->queuelist, &bqt->busy_list);
+	list_add(&rq->queuelist, &q->tag_busy_list);
 	bqt->busy++;
 	return 0;
 }
@@ -1173,11 +1172,10 @@ EXPORT_SYMBOL(blk_queue_start_tag);
  **/
 void blk_queue_invalidate_tags(struct request_queue *q)
 {
-	struct blk_queue_tag *bqt = q->queue_tags;
 	struct list_head *tmp, *n;
 	struct request *rq;
 
-	list_for_each_safe(tmp, n, &bqt->busy_list) {
+	list_for_each_safe(tmp, n, &q->tag_busy_list) {
 		rq = list_entry_rq(tmp);
 
 		if (rq->tag == -1) {
diff --git a/fs/locks.c b/fs/locks.c
index c795eaa..494f250 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -694,11 +694,20 @@ EXPORT_SYMBOL(posix_test_lock);
  * Note: the above assumption may not be true when handling lock requests
  * from a broken NFS client. But broken NFS clients have a lot more to
  * worry about than proper deadlock detection anyway... --okir
+ *
+ * However, the failure of this assumption (also possible in the case of
+ * multiple tasks sharing the same open file table) also means there's no
+ * guarantee that the loop below will terminate.  As a hack, we give up
+ * after a few iterations.
  */
+
+#define MAX_DEADLK_ITERATIONS 10
+
 static int posix_locks_deadlock(struct file_lock *caller_fl,
 				struct file_lock *block_fl)
 {
 	struct list_head *tmp;
+	int i = 0;
 
 next_task:
 	if (posix_same_owner(caller_fl, block_fl))
@@ -706,6 +715,8 @@ next_task:
 	list_for_each(tmp, &blocked_list) {
 		struct file_lock *fl = list_entry(tmp, struct file_lock, fl_link);
 		if (posix_same_owner(fl, block_fl)) {
+			if (i++ > MAX_DEADLK_ITERATIONS)
+				return 0;
 			fl = fl->fl_next;
 			block_fl = fl;
 			goto next_task;
diff --git a/fs/proc/array.c b/fs/proc/array.c
index ee4814d..20d7ae4 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -351,7 +351,8 @@ static cputime_t task_utime(struct task_struct *p)
 	}
 	utime = (clock_t)temp;
 
-	return clock_t_to_cputime(utime);
+	p->prev_utime = max(p->prev_utime, clock_t_to_cputime(utime));
+	return p->prev_utime;
 }
 
 static cputime_t task_stime(struct task_struct *p)
@@ -366,7 +367,8 @@ static cputime_t task_stime(struct task_struct *p)
 	stime = nsec_to_clock_t(p->se.sum_exec_runtime) -
 			cputime_to_clock_t(task_utime(p));
 
-	return clock_t_to_cputime(stime);
+	p->prev_stime = max(p->prev_stime, clock_t_to_cputime(stime));
+	return p->prev_stime;
 }
 #endif
 
diff --git a/fs/splice.c b/fs/splice.c
index e95a362..02c39ae 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1390,10 +1390,10 @@ static int pipe_to_user(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 	if (copy_to_user(sd->u.userptr, src + buf->offset, sd->len))
 		ret = -EFAULT;
 
+	buf->ops->unmap(pipe, buf, src);
 out:
 	if (ret > 0)
 		sd->u.userptr += ret;
-	buf->ops->unmap(pipe, buf, src);
 	return ret;
 }
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b126c6f..d26bbb0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -356,7 +356,6 @@ enum blk_queue_state {
 struct blk_queue_tag {
 	struct request **tag_index;	/* map of busy tags */
 	unsigned long *tag_map;		/* bit map of free/busy tags */
-	struct list_head busy_list;	/* fifo list of busy tags */
 	int busy;			/* current depth */
 	int max_depth;			/* what we will send to device */
 	int real_max_depth;		/* what the array can hold */
@@ -451,6 +450,7 @@ struct request_queue
 	unsigned int		dma_alignment;
 
 	struct blk_queue_tag	*queue_tags;
+	struct list_head	tag_busy_list;
 
 	unsigned int		nr_sorted;
 	unsigned int		in_flight;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 313c6b6..f509fbd 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1022,6 +1022,7 @@ struct task_struct {
 
 	unsigned int rt_priority;
 	cputime_t utime, stime;
+	cputime_t prev_utime, prev_stime;
 	unsigned long nvcsw, nivcsw; /* context switch counts */
 	struct timespec start_time; 		/* monotonic time */
 	struct timespec real_start_time;	/* boot based time */
diff --git a/kernel/fork.c b/kernel/fork.c
index 33f12f4..f299d45 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1045,6 +1045,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	p->utime = cputime_zero;
 	p->stime = cputime_zero;
+	p->prev_utime = cputime_zero;
+	p->prev_stime = cputime_zero;
 
 #ifdef CONFIG_TASK_XACCT
 	p->rchar = 0;		/* I/O counter: bytes read */
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index 2c2e295..f938c23 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -29,6 +29,15 @@ fetch_robust_entry(compat_uptr_t *uentry, struct robust_list __user **entry,
 	return 0;
 }
 
+static void __user *futex_uaddr(struct robust_list *entry,
+				compat_long_t futex_offset)
+{
+	compat_uptr_t base = ptr_to_compat(entry);
+	void __user *uaddr = compat_ptr(base + futex_offset);
+
+	return uaddr;
+}
+
 /*
  * Walk curr->robust_list (very carefully, it's a userspace list!)
  * and mark any locks found there dead, and notify any waiters.
@@ -75,11 +84,13 @@ void compat_exit_robust_list(struct task_struct *curr)
 		 * A pending lock might already be on the list, so
 		 * dont process it twice:
 		 */
-		if (entry != pending)
-			if (handle_futex_death((void __user *)entry + futex_offset,
-						curr, pi))
-				return;
+		if (entry != pending) {
+			void __user *uaddr = futex_uaddr(entry,
+							 futex_offset);
 
+			if (handle_futex_death(uaddr, curr, pi))
+				return;
+		}
 		if (rc)
 			return;
 		uentry = next_uentry;
@@ -93,9 +104,11 @@ void compat_exit_robust_list(struct task_struct *curr)
 
 		cond_resched();
 	}
-	if (pending)
-		handle_futex_death((void __user *)pending + futex_offset,
-				   curr, pip);
+	if (pending) {
+		void __user *uaddr = futex_uaddr(pending, futex_offset);
+
+		handle_futex_death(uaddr, curr, pip);
+	}
 }
 
 asmlinkage long
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 734da57..42ae4a5 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -1521,7 +1521,7 @@ cache_hit:
 }
 
 static int validate_chain(struct task_struct *curr, struct lockdep_map *lock,
-	       	struct held_lock *hlock, int chain_head)
+	       	struct held_lock *hlock, int chain_head, u64 chain_key)
 {
 	/*
 	 * Trylock needs to maintain the stack of held locks, but it
@@ -1534,7 +1534,7 @@ static int validate_chain(struct task_struct *curr, struct lockdep_map *lock,
 	 * graph_lock for us)
 	 */
 	if (!hlock->trylock && (hlock->check == 2) &&
-			lookup_chain_cache(curr->curr_chain_key, hlock->class)) {
+			lookup_chain_cache(chain_key, hlock->class)) {
 		/*
 		 * Check whether last held lock:
 		 *
@@ -1576,7 +1576,7 @@ static int validate_chain(struct task_struct *curr, struct lockdep_map *lock,
 #else
 static inline int validate_chain(struct task_struct *curr,
 	       	struct lockdep_map *lock, struct held_lock *hlock,
-		int chain_head)
+		int chain_head, u64 chain_key)
 {
 	return 1;
 }
@@ -2450,11 +2450,11 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 		chain_head = 1;
 	}
 	chain_key = iterate_chain_key(chain_key, id);
-	curr->curr_chain_key = chain_key;
 
-	if (!validate_chain(curr, lock, hlock, chain_head))
+	if (!validate_chain(curr, lock, hlock, chain_head, chain_key))
 		return 0;
 
+	curr->curr_chain_key = chain_key;
 	curr->lockdep_depth++;
 	check_chain_key(curr);
 #ifdef CONFIG_DEBUG_LOCKDEP
diff --git a/kernel/params.c b/kernel/params.c
index 4e57732..5e5651f 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -595,13 +595,16 @@ static void __init param_sysfs_builtin(void)
 
 	for (i=0; i < __stop___param - __start___param; i++) {
 		char *dot;
+		size_t max_name_len;
 
 		kp = &__start___param[i];
+		max_name_len =
+			min_t(size_t, MAX_KBUILD_MODNAME, strlen(kp->name));
 
-		/* We do not handle args without periods. */
-		dot = memchr(kp->name, '.', MAX_KBUILD_MODNAME);
+		dot = memchr(kp->name, '.', max_name_len);
 		if (!dot) {
-			DEBUGP("couldn't find period in %s\n", kp->name);
+			DEBUGP("couldn't find period in first %d characters "
+			       "of %s\n", MAX_KBUILD_MODNAME, kp->name);
 			continue;
 		}
 		name_len = dot - kp->name;
diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 708d488..e557c44 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -80,10 +80,11 @@ void softlockup_tick(void)
 	print_timestamp = per_cpu(print_timestamp, this_cpu);
 
 	/* report at most once a second */
-	if (print_timestamp < (touch_timestamp + 1) ||
-		did_panic ||
-			!per_cpu(watchdog_task, this_cpu))
+	if ((print_timestamp >= touch_timestamp &&
+			print_timestamp < (touch_timestamp + 1)) ||
+			did_panic || !per_cpu(watchdog_task, this_cpu)) {
 		return;
+	}
 
 	/* do not print during early bootup: */
 	if (unlikely(system_state != SYSTEM_RUNNING)) {
diff --git a/mm/filemap.c b/mm/filemap.c
index 15c8413..14ca63f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1312,7 +1312,7 @@ int filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 
 	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	if (vmf->pgoff >= size)
-		goto outside_data_content;
+		return VM_FAULT_SIGBUS;
 
 	/* If we don't want any read-ahead, don't bother */
 	if (VM_RandomReadHint(vma))
@@ -1389,7 +1389,7 @@ retry_find:
 	if (unlikely(vmf->pgoff >= size)) {
 		unlock_page(page);
 		page_cache_release(page);
-		goto outside_data_content;
+		return VM_FAULT_SIGBUS;
 	}
 
 	/*
@@ -1400,15 +1400,6 @@ retry_find:
 	vmf->page = page;
 	return ret | VM_FAULT_LOCKED;
 
-outside_data_content:
-	/*
-	 * An external ptracer can access pages that normally aren't
-	 * accessible..
-	 */
-	if (vma->vm_mm == current->mm)
-		return VM_FAULT_SIGBUS;
-
-	/* Fall through to the non-read-ahead case */
 no_cached_page:
 	/*
 	 * We're only likely to ever get here if MADV_RANDOM is in
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 4472036..97ddc58 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -672,8 +672,10 @@ retry:
 
 			ret = (*writepage)(page, wbc, data);
 
-			if (unlikely(ret == AOP_WRITEPAGE_ACTIVATE))
+			if (unlikely(ret == AOP_WRITEPAGE_ACTIVATE)) {
 				unlock_page(page);
+				ret = 0;
+			}
 			if (ret || (--(wbc->nr_to_write) <= 0))
 				done = 1;
 			if (wbc->nonblocking && bdi_write_congested(bdi)) {
diff --git a/mm/shmem.c b/mm/shmem.c
index fcd19d3..95558e4 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -916,6 +916,21 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 	struct inode *inode;
 
 	BUG_ON(!PageLocked(page));
+	/*
+	 * shmem_backing_dev_info's capabilities prevent regular writeback or
+	 * sync from ever calling shmem_writepage; but a stacking filesystem
+	 * may use the ->writepage of its underlying filesystem, in which case
+	 * we want to do nothing when that underlying filesystem is tmpfs
+	 * (writing out to swap is useful as a response to memory pressure, but
+	 * of no use to stabilize the data) - just redirty the page, unlock it
+	 * and claim success in this case.  AOP_WRITEPAGE_ACTIVATE, and the
+	 * page_mapped check below, must be avoided unless we're in reclaim.
+	 */
+	if (!wbc->for_reclaim) {
+		set_page_dirty(page);
+		unlock_page(page);
+		return 0;
+	}
 	BUG_ON(page_mapped(page));
 
 	mapping = page->mapping;
diff --git a/mm/slub.c b/mm/slub.c
index addb20a..c1f2fda 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1501,28 +1501,8 @@ new_slab:
 	page = new_slab(s, gfpflags, node);
 	if (page) {
 		cpu = smp_processor_id();
-		if (s->cpu_slab[cpu]) {
-			/*
-			 * Someone else populated the cpu_slab while we
-			 * enabled interrupts, or we have gotten scheduled
-			 * on another cpu. The page may not be on the
-			 * requested node even if __GFP_THISNODE was
-			 * specified. So we need to recheck.
-			 */
-			if (node == -1 ||
-				page_to_nid(s->cpu_slab[cpu]) == node) {
-				/*
-				 * Current cpuslab is acceptable and we
-				 * want the current one since its cache hot
-				 */
-				discard_slab(s, page);
-				page = s->cpu_slab[cpu];
-				slab_lock(page);
-				goto load_freelist;
-			}
-			/* New slab does not fit our expectations */
+		if (s->cpu_slab[cpu])
 			flush_slab(s, s->cpu_slab[cpu], cpu);
-		}
 		slab_lock(page);
 		SetSlabFrozen(page);
 		s->cpu_slab[cpu] = page;
