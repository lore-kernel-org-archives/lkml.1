Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbZFIGgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbZFIGgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756640AbZFIGgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:36:47 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:58054 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756878AbZFIGgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:36:46 -0400
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: [PATCH 15/27] score: create head files resource.h
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF79067DAA.30777D1C-ON482575D0.0023D45B-482575D0.00244621@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Tue, 9 Jun 2009 14:31:55 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/09 ?? 02:31:56,
	Serialize complete at 2009/06/09 ?? 02:31:56
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c01a13da77fa5e44db8f1f701fac3df686d37aac Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Tue, 9 Jun 2009 13:43:12 +0800
Subject: [PATCH 15/27] score: create head files resource.h


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/resource.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/include/asm/resource.h

diff --git a/arch/score/include/asm/resource.h 
b/arch/score/include/asm/resource.h
new file mode 100644
index 0000000..9ce22bc
--- /dev/null
+++ b/arch/score/include/asm/resource.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_RESOURCE_H
+#define _ASM_SCORE_RESOURCE_H
+
+#include <asm-generic/resource.h>
+
+#endif /* _ASM_SCORE_RESOURCE_H */
-- 
1.6.2

