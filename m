Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436Ab0AVExL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab0AVExL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 23:53:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905Ab0AVExF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 23:53:05 -0500
Received: from mail.perches.com ([173.55.12.10]:1350 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850Ab0AVEw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 23:52:59 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 10/24] drivers/block/floppy.c: Indent a comment
Date: Thu, 21 Jan 2010 20:52:40 -0800
Message-Id: <a566b72140b2087bdd90598d475409af179371ef.1264133863.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264133863.git.joe@perches.com>
References: <cover.1264133863.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 4a43373..0813c10 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4262,7 +4262,7 @@ static int __init floppy_init(void)
 		FDCS->dtr = -1;
 		FDCS->dor = 0x4;
 #if defined(__sparc__) || defined(__mc68000__)
-		/*sparcs/sun3x don't have a DOR reset which we can fall back on to */
+	/*sparcs/sun3x don't have a DOR reset which we can fall back on to */
 #ifdef __mc68000__
 		if (MACH_IS_SUN3X)
 #endif
-- 
1.6.6.rc0.57.gad7a

