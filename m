Return-Path: <linux-kernel-owner+w=401wt.eu-S1759380AbZD2K7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380AbZD2K7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 06:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756360AbZD2Kvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:51:35 -0400
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:46162
	"EHLO WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755694AbZD2KvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:51:17 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KIUZGV-03-8M8-01
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 29/29] perfcounters: updating kerneltop documentation
Date: Wed, 29 Apr 2009 12:47:26 +0200
Message-ID: <1241002046-8832-30-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 29 Apr 2009 10:50:49.0602 (UTC) FILETIME=[5BC62620:01C9C8B8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The documentation about the kerneltop build was outdated after
perfstat has been implemented. This updates it.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 Documentation/perf_counter/builtin-top.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/perf_counter/builtin-top.c b/Documentation/perf_counter/builtin-top.c
index dea016f..a4d00f4 100644
--- a/Documentation/perf_counter/builtin-top.c
+++ b/Documentation/perf_counter/builtin-top.c
@@ -3,7 +3,7 @@
 
    Build with:
 
-     cc -O6 -Wall -c -o kerneltop.o kerneltop.c -lrt
+     make -C Documentation/perf_counter/
 
    Sample output:
 
-- 
1.6.1.3


