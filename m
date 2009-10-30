Return-Path: <linux-kernel-owner+w=401wt.eu-S1757530AbZJ3Vcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbZJ3Vcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 17:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757433AbZJ3Vcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 17:32:31 -0400
Received: from 139.254.232.72.static.reverse.ltdomains.com ([72.232.254.139]:44579
	"EHLO liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756667AbZJ3Vca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 17:32:30 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: trivial@kernel.org
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] trivial: fix some typo in the perf events config description
Date: Fri, 30 Oct 2009 19:32:25 -0200
Message-Id: <1256938346-8230-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 init/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index a669eb0..f6ae79f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -950,7 +950,7 @@ config PERF_EVENTS
 	  Enable kernel support for various performance events provided
 	  by software and hardware.
 
-	  Software events are supported either build-in or via the
+	  Software events are supported either built-in or via the
 	  use of generic tracepoints.
 
 	  Most modern CPUs support performance events via performance
@@ -962,7 +962,7 @@ config PERF_EVENTS
 	  used to profile the code that runs on that CPU.
 
 	  The Linux Performance Event subsystem provides an abstraction of
-	  these software and hardware cevent apabilities, available via a
+	  these software and hardware event capabilities, available via a
 	  system call and used by the "perf" utility in tools/perf/. It
 	  provides per task and per CPU counters, and it provides event
 	  capabilities on top of those.
-- 
1.6.3.3

