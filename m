Return-Path: <linux-kernel-owner+w=401wt.eu-S1756068Ab0ANHO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab0ANHO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 02:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755834Ab0ANHN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 02:13:59 -0500
Received: from mail.perches.com ([173.55.12.10]:1171 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755645Ab0ANHN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 02:13:27 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 19/24] MAINTAINERS: REAL TIME CLOCK - Add "Q" patchwork entry
Date: Wed, 13 Jan 2010 23:13:18 -0800
Message-Id: <0f1098f1881e8467abd81b446720a7e87c1ff2af.1263452909.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1263452908.git.joe@perches.com>
References: <cover.1263452908.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3e2e631..134880c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4562,6 +4562,7 @@ F:	include/linux/rtc.h
 REAL TIME CLOCK (RTC) SUBSYSTEM
 M:	Alessandro Zummo <a.zummo@towertech.it>
 L:	rtc-linux@googlegroups.com
+Q:	http://patchwork.ozlabs.org/project/rtc-linux/list/
 S:	Maintained
 F:	Documentation/rtc.txt
 F:	drivers/rtc/
-- 
1.6.6.rc0.57.gad7a

