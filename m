Return-Path: <linux-kernel-owner+w=401wt.eu-S1758967AbZAMU2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967AbZAMU2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 15:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755525AbZAMU1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 15:27:45 -0500
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2526 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbZAMU1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 15:27:43 -0500
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 05/10] MAINTAINERS - Remove HP Fibre Channel HBA no longer in tree
Date: Tue, 13 Jan 2009 12:28:13 -0800
Message-Id: <1231878498-25171-6-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1231878498-25171-1-git-send-email-joe@perches.com>
References: <1231878498-25171-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4b6ec2a..4c23a85 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2356,12 +2356,6 @@ S:	Maintained
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

