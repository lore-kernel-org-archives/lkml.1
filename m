Return-Path: <linux-kernel-owner+w=401wt.eu-S1760101AbZDHFUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760101AbZDHFUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 01:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758275AbZDHFUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 01:20:19 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4360 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130AbZDHFUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 01:20:17 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/10] MAINTAINERS - Remove HP Fibre Channel HBA no longer in tree
Date: Tue,  7 Apr 2009 22:17:46 -0700
Message-Id: <1239167872-8179-5-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1239167872-8179-1-git-send-email-joe@perches.com>
References: <1239167872-8179-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 007f2fa..09d503f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2460,12 +2460,6 @@ S:	Maintained
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

