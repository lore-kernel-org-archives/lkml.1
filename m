Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111Ab0ANHQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab0ANHQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 02:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755632Ab0ANHQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 02:16:13 -0500
Received: from mail.perches.com ([173.55.12.10]:1174 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755528Ab0ANHN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 02:13:26 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 14/24] MAINTAINERS: MTD - Add "Q" patchwork entry
Date: Wed, 13 Jan 2010 23:13:13 -0800
Message-Id: <2db928a47eb4e0cbcdfa7650f0a936aa17affe50.1263452909.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1263452908.git.joe@perches.com>
References: <cover.1263452908.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder "L:" entry

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e30de26..c2395f5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3571,8 +3571,9 @@ F:	mm/memcontrol.c
 
 MEMORY TECHNOLOGY DEVICES (MTD)
 M:	David Woodhouse <dwmw2@infradead.org>
-W:	http://www.linux-mtd.infradead.org/
 L:	linux-mtd@lists.infradead.org
+W:	http://www.linux-mtd.infradead.org/
+Q:	http://patchwork.ozlabs.org/project/linux-mtd/list/
 T:	git git://git.infradead.org/mtd-2.6.git
 S:	Maintained
 F:	drivers/mtd/
-- 
1.6.6.rc0.57.gad7a

