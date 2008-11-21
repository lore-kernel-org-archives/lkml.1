Return-Path: <linux-kernel-owner+w=401wt.eu-S1756975AbYKUPpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975AbYKUPpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 10:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbYKUPoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 10:44:14 -0500
Received: from smtp.nokia.com ([192.100.122.233]:58962 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977AbYKUPoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 10:44:11 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: change UBI/UBIFS git tree URLs
Date: Fri, 21 Nov 2008 19:19:25 +0200
Message-Id: <1227287970-14684-4-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1227287970-14684-1-git-send-email-dedekind@infradead.org>
References: <1227287970-14684-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 21 Nov 2008 15:44:05.0991 (UTC) FILETIME=[FC5BC770:01C94BEF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d643e86..7e897ee 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4192,7 +4192,7 @@ M:	dedekind@infradead.org
 P:	Adrian Hunter
 M:	ext-adrian.hunter@nokia.com
 L:	linux-mtd@lists.infradead.org
-T:	git git://git.infradead.org/~dedekind/ubifs-2.6.git
+T:	git git://git.infradead.org/ubifs-2.6.git
 W:	http://www.linux-mtd.infradead.org/doc/ubifs.html
 S:	Maintained
 
@@ -4246,7 +4246,7 @@ P:	Artem Bityutskiy
 M:	dedekind@infradead.org
 W:	http://www.linux-mtd.infradead.org/
 L:	linux-mtd@lists.infradead.org
-T:	git git://git.infradead.org/~dedekind/ubi-2.6.git
+T:	git git://git.infradead.org/ubi-2.6.git
 S:	Maintained
 
 USB ACM DRIVER
-- 
1.5.4.3

