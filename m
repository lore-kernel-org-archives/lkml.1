Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577Ab0AMV4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab0AMV4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 16:56:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756534Ab0AMV4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 16:56:11 -0500
Received: from mail.perches.com ([173.55.12.10]:1132 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756523Ab0AMV4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 16:56:08 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] MAINTAINERS: Update PERFORMANCE EVENTS F: patterns
Date: Wed, 13 Jan 2010 13:56:05 -0800
Message-Id: <f9b3968c9655ab3c096062faa512ac758d6a7f4c.1263419518.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1263419518.git.joe@perches.com>
References: <cover.1263419518.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To match arch/*/kernel perf_event location changes

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5747aaf..abd548e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4225,7 +4225,9 @@ M:	Ingo Molnar <mingo@elte.hu>
 S:	Supported
 F:	kernel/perf_event.c
 F:	include/linux/perf_event.h
-F:	arch/*/*/kernel/perf_event.c
+F:	arch/*/kernel/perf_event.c
+F:	arch/*/kernel/*/perf_event.c
+F:	arch/*/kernel/*/*/perf_event.c
 F:	arch/*/include/asm/perf_event.h
 F:	arch/*/lib/perf_event.c
 F:	arch/*/kernel/perf_callchain.c
-- 
1.6.6.rc0.57.gad7a

