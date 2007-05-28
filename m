Return-Path: <linux-kernel-owner+w=401wt.eu-S1762135AbXE1Ija@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762135AbXE1Ija (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 04:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761371AbXE1Igm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 04:36:42 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:22622 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759274AbXE1Ige (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 04:36:34 -0400
X-IronPort-AV: i="4.14,586,1170651600"; 
   d="scan'208"; a="40300051:sNHT21908810"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 09/20] Blackfin arch: fixup Blackfin MAINTIANERS team member list
Date: Mon, 28 May 2007 16:37:44 +0800
Message-Id: <11803414783199-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11803414753217-git-send-email-bryan.wu@analog.com>
References: <11803414753217-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 MAINTAINERS |   70 ++++++++++++++++++++++++++++++----------------------------
 1 files changed, 36 insertions(+), 34 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 953291d..57dd23a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -720,42 +720,44 @@ M:	rpurdie@rpsys.net
 S:	Maintained
 
 BLACKFIN ARCHITECTURE
-P:     Aubrey Li
-M:     aubrey.li@analog.com
-P:     Bernd Schmidt
-M:     bernd.schmidt@analog.com
-P:     Bryan Wu
-M:     bryan.wu@analog.com
-P:     Grace Pan
-M:     grace.pan@analog.com
-P:     Michael Hennerich
-M:     michael.hennerich@analog.com
-P:     Mike Frysinger
-M:     michael.frysinger@analog.com
-P:     Jane Lv
-M:     jane.lv@analog.com
-P:     Jerry Zeng
-M:     jerry.zeng@analog.com
-P:     Jie Zhang
-M:     jie.zhang@analog.com
-P:     Robin Getz
-M:     robin.getz@analog.com
-P:     Roy Huang
-M:     roy.huang@analog.com
-P:     Sonic Zhang
-M:     sonic.zhang@analog.com
-P:     Yi Li
-M:     yi.li@analog.com
-L:     uclinux-dist-devel@blackfin.uclinux.org
-W:     http://blackfin.uclinux.org
-S:     Supported
+P:	Aubrey Li
+M:	aubrey.li@analog.com
+P:	Bernd Schmidt
+M:	bernd.schmidt@analog.com
+P:	Bryan Wu
+M:	bryan.wu@analog.com
+P:	Grace Pan
+M:	grace.pan@analog.com
+P:	Marc Hoffman
+M:	marc.hoffman@analog.com
+P:	Michael Hennerich
+M:	michael.hennerich@analog.com
+P:	Mike Frysinger
+M:	michael.frysinger@analog.com
+P:	Jerry Zeng
+M:	jerry.zeng@analog.com
+P:	Jie Zhang
+M:	jie.zhang@analog.com
+P:	Robin Getz
+M:	robin.getz@analog.com
+P:	Roy Huang
+M:	roy.huang@analog.com
+P:	Sonic Zhang
+M:	sonic.zhang@analog.com
+P:	Vivi Li
+M:	vivi.li@analog.com
+P:	Yi Li
+M:	yi.li@analog.com
+L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
+W:	http://blackfin.uclinux.org
+S:	Supported
 
 BLACKFIN SERIAL DRIVER
-P:     Aubrey Li
-M:     aubrey.li@analog.com
-L:     uclinux-dist-devel@blackfin.uclinux.org
-W:     http://blackfin.uclinux.org
-S:     Supported
+P:	Aubrey Li
+M:	aubrey.li@analog.com
+L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
+W:	http://blackfin.uclinux.org
+S:	Supported
 
 BAYCOM/HDLCDRV DRIVERS FOR AX.25
 P:	Thomas Sailer
-- 
1.5.2
