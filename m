Return-Path: <linux-kernel-owner+w=401wt.eu-S1756963AbZHZGvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963AbZHZGvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756923AbZHZGvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:51:13 -0400
Received: from 124-219-29-227.vdslpro.static.apol.com.tw ([124.219.29.227]:38982
	"EHLO mswedge2.sunplus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756857AbZHZGvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:51:12 -0400
Subject: Subject: [PATCH 33/33] score: add maintainers for score
	architecture
From: Chen Liqin <liqin.chen@sunplusct.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, torvalds@linux-foundation.org
Content-Type: text/plain
Date: Wed, 26 Aug 2009 14:39:33 +0800
Message-Id: <1251268773.3293.6.camel@ad3ser01>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f29c7977ddcce1ee7d83a38bc9963bde95c94f45 Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Wed, 26 Aug 2009 10:05:12 +0800
Subject: [PATCH 33/33] score: add maintainers for score architecture


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 60299a9..7e9c040 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4392,6 +4392,14 @@ S:	Maintained
 F:	kernel/sched*
 F:	include/linux/sched.h
 
+SCORE ARCHITECTURE
+P:	Chen Liqin
+M:	liqin.chen@sunplusct.com
+P:	Lennox Wu
+M:	lennox.wu@sunplusct.com
+W:	http://www.sunplusct.com
+S:	Supported
+
 SCSI CDROM DRIVER
 M:	Jens Axboe <axboe@kernel.dk>
 L:	linux-scsi@vger.kernel.org
-- 
1.6.2



