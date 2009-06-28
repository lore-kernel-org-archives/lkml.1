Return-Path: <linux-kernel-owner+w=401wt.eu-S1760287AbZF1Qm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760287AbZF1Qm3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757286AbZF1Q2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:28:40 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1149 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636AbZF1Q14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:27:56 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux390@de.ibm.com, Frank Blaschka <blaschka@linux.vnet.ibm.com>,
       Ursula Braun <ursula.braun@de.ibm.com>, linux-s390@vger.kernel.org
Subject: [PATCH 40/62] drivers/s390/net/netiucv.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:45 -0700
Message-Id: <ddc432fdb5d1df3821c6cbf8453b58b5d2dd2325.1246173682.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/s390/net/netiucv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/s390/net/netiucv.c b/drivers/s390/net/netiucv.c
index 8c36eaf..6b6371b 100644
--- a/drivers/s390/net/netiucv.c
+++ b/drivers/s390/net/netiucv.c
@@ -2113,7 +2113,7 @@ static ssize_t remove_write (struct device_driver *drv,
 	IUCV_DBF_TEXT(trace, 3, __func__);
 
         if (count >= IFNAMSIZ)
-                count = IFNAMSIZ - 1;;
+                count = IFNAMSIZ - 1;
 
 	for (i = 0, p = buf; i < count && *p; i++, p++) {
 		if (*p == '\n' || *p == ' ')
-- 
1.6.3.1.10.g659a0.dirty

