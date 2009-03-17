Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbZCQXWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbZCQXWG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 19:22:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbZCQXU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 19:20:58 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4385 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbZCQXUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 19:20:55 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 4/8] MAINTAINERS - Remove HP Fibre Channel HBA no longer in tree
Date: Tue, 17 Mar 2009 16:19:25 -0700
Message-Id: <1237331969-28565-5-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237331969-28565-1-git-send-email-joe@perches.com>
References: <1237331969-28565-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a8436c5..9bb0e13 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2401,12 +2401,6 @@ S:	Maintained
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

