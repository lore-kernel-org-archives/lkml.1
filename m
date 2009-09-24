Return-Path: <linux-kernel-owner+w=401wt.eu-S1753695AbZIXSmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbZIXSmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 14:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbZIXSmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 14:42:00 -0400
Received: from mail.perches.com ([173.55.12.10]:1160 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbZIXSl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 14:41:56 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 06/11] MAINTAINERS: JANITORS status set to Odd Fixes
Date: Thu, 24 Sep 2009 11:41:54 -0700
Message-Id: <e469f9a7f6b4023a1d08c1a6507d45d980566184.1253817463.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1253817463.git.joe@perches.com>
References: <cover.1253817463.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was mistakenly reset to MAINTAINED after a fuzzy merge

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0aa0776..96b2810 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2955,7 +2955,7 @@ F:	scripts/Makefile.*
 KERNEL JANITORS
 L:	kernel-janitors@vger.kernel.org
 W:	http://www.kerneljanitors.org/
-S:	Maintained
+S:	Odd Fixes
 
 KERNEL NFSD, SUNRPC, AND LOCKD SERVERS
 M:	"J. Bruce Fields" <bfields@fieldses.org>
-- 
1.6.3.1.10.g659a0.dirty

