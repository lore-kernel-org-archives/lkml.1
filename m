Return-Path: <linux-kernel-owner+w=401wt.eu-S1758587AbZF1Qda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587AbZF1Qda (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756676AbZF1Q1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:27:37 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1108 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbZF1Q1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:27:33 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Karsten Keil <isdn@linux-pingi.de>
Subject: [PATCH 20/62] drivers/isdn/capi/capiutil.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:25 -0700
Message-Id: <39c2cf78606c983a3c535b842086922583aa86e1.1246173681.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/isdn/capi/capiutil.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/capi/capiutil.c b/drivers/isdn/capi/capiutil.c
index 16f2e46..26626ee 100644
--- a/drivers/isdn/capi/capiutil.c
+++ b/drivers/isdn/capi/capiutil.c
@@ -1019,7 +1019,7 @@ int __init cdebug_init(void)
 	if (!g_debbuf->buf) {
 		kfree(g_cmsg);
 		kfree(g_debbuf);
-		return -ENOMEM;;
+		return -ENOMEM;
 	}
 	g_debbuf->size = CDEBUG_GSIZE;
 	g_debbuf->buf[0] = 0;
-- 
1.6.3.1.10.g659a0.dirty

