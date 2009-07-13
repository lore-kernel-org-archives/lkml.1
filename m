Return-Path: <linux-kernel-owner+w=401wt.eu-S1757409AbZGMVPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbZGMVPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757372AbZGMVPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:15:10 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4013 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757288AbZGMVPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:15:05 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 07/16] MAINTAINERS: Update KERNEL JANITORS
Date: Mon, 13 Jul 2009 14:14:53 -0700
Message-Id: <9f731530437ff7a50edb6cef59b37c8e87e7963d.1247517374.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1247517373.git.joe@perches.com>
References: <cover.1247517373.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2851cec..108ae11 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3366,10 +3366,9 @@ F:	Makefile
 F:	scripts/Makefile.*
 
 KERNEL JANITORS
-P:	Several
 L:	kernel-janitors@vger.kernel.org
-W:	http://www.kerneljanitors.org/
-S:	Maintained
+W:	http://janitor.kernelnewbies.org/
+S:	Odd fixes
 
 KERNEL NFSD, SUNRPC, AND LOCKD SERVERS
 P:	J. Bruce Fields
-- 
1.6.3.1.10.g659a0.dirty

