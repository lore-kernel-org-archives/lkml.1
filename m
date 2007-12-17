Return-Path: <linux-kernel-owner+w=401wt.eu-S933535AbXLQTiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933535AbXLQTiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:38:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761005AbXLQTbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:31:41 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2966 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760762AbXLQTbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:36 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Subject: [PATCH] arch/sh/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:18 -0800
Message-Id: <1197919875-5288-19-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918890.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/sh/boards/dreamcast/irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sh/boards/dreamcast/irq.c b/arch/sh/boards/dreamcast/irq.c
index 5bf01f8..9d0673a 100644
--- a/arch/sh/boards/dreamcast/irq.c
+++ b/arch/sh/boards/dreamcast/irq.c
@@ -136,7 +136,7 @@ int systemasic_irq_demux(int irq)
         emr = EMR_BASE + (level << 4) + (level << 2);
         esr = ESR_BASE + (level << 2);
 
-        /* Mask the ESR to filter any spurious, unwanted interrtupts */
+        /* Mask the ESR to filter any spurious, unwanted interrupts */
         status = inl(esr);
         status &= inl(emr);
 
-- 
1.5.3.7.949.g2221a6

