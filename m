Return-Path: <linux-kernel-owner+w=401wt.eu-S1753698AbZIXSnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbZIXSnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 14:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbZIXSns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 14:43:48 -0400
Received: from mail.perches.com ([173.55.12.10]:1161 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546AbZIXSl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 14:41:56 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 07/11] MAINTAINERS: Update SCORE architecture name style and add file pattern
Date: Thu, 24 Sep 2009 11:41:55 -0700
Message-Id: <8a7aea38a4e4500e083e0e771840be5ad98974b0.1253817463.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1253817463.git.joe@perches.com>
References: <cover.1253817463.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 96b2810..96468b1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4468,12 +4468,11 @@ F:	kernel/sched*
 F:	include/linux/sched.h
 
 SCORE ARCHITECTURE
-P:	Chen Liqin
-M:	liqin.chen@sunplusct.com
-P:	Lennox Wu
-M:	lennox.wu@gmail.com
+M:	Chen Liqin <liqin.chen@sunplusct.com>
+M:	Lennox Wu <lennox.wu@gmail.com>
 W:	http://www.sunplusct.com
 S:	Supported
+F:	arch/score/
 
 SCSI CDROM DRIVER
 M:	Jens Axboe <axboe@kernel.dk>
-- 
1.6.3.1.10.g659a0.dirty

