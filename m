Return-Path: <linux-kernel-owner+w=401wt.eu-S1753681AbYKRROZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbYKRROZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 12:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbYKRRNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 12:13:36 -0500
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4478 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbYKRRNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 12:13:34 -0500
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@strlen.de>,
       Pavel Machek <pavel@suse.cz>
Subject: [PATCH 05/10] MAINTAINERS - Remove HP Fibre Channel HBA no longer in tree
Date: Tue, 18 Nov 2008 09:13:17 -0800
Message-Id: <1227028402-1548-6-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1227028402-1548-1-git-send-email-joe@perches.com>
References: <1227028402-1548-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c0d5efd..e9a148b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2325,12 +2325,6 @@ S:	Maintained
 F:	Documentation/serial/hayes-esp.txt
 F:	drivers/char/esp.c
 
-HEWLETT-PACKARD FIBRE CHANNEL 64-bit/66MHz PCI non-intelligent HBA
-P:	Chirag Kantharia
-M:	chirag.kantharia@hp.com
-L:	iss_storagedev@hp.com
-S:	Maintained
-
 HEWLETT-PACKARD SMART2 RAID DRIVER
 P:	Chirag Kantharia
 M:	chirag.kantharia@hp.com
-- 
1.6.0.2

