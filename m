Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876Ab0AMPWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab0AMPWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 10:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755747Ab0AMPWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 10:22:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33356 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655Ab0AMPWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 10:22:37 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Kirill Smelkov <kirr@landau.phys.spbu.ru>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/3] perf: fix few typos + cosmetics
Date: Wed, 13 Jan 2010 13:22:18 -0200
Message-Id: <1263396139-4798-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1263396139-4798-1-git-send-email-acme@infradead.org>
References: <1263396139-4798-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill Smelkov <kirr@landau.phys.spbu.ru>

Signed-off-by: Kirill Smelkov <kirr@landau.phys.spbu.ru>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf.txt |    2 +-
 tools/perf/design.txt             |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Documentation/perf.txt b/tools/perf/Documentation/perf.txt
index 69c8325..0eeb247 100644
--- a/tools/perf/Documentation/perf.txt
+++ b/tools/perf/Documentation/perf.txt
@@ -12,7 +12,7 @@ SYNOPSIS
 
 DESCRIPTION
 -----------
-Performance counters for Linux are are a new kernel-based subsystem
+Performance counters for Linux are a new kernel-based subsystem
 that provide a framework for all things performance analysis. It
 covers hardware level (CPU/PMU, Performance Monitoring Unit) features
 and software features (software counters, tracepoints) as well.
diff --git a/tools/perf/design.txt b/tools/perf/design.txt
index 8d0de51..bd0bb1b 100644
--- a/tools/perf/design.txt
+++ b/tools/perf/design.txt
@@ -101,10 +101,10 @@ enum hw_event_ids {
 	 */
 	PERF_COUNT_HW_CPU_CYCLES		= 0,
 	PERF_COUNT_HW_INSTRUCTIONS		= 1,
-	PERF_COUNT_HW_CACHE_REFERENCES	= 2,
+	PERF_COUNT_HW_CACHE_REFERENCES		= 2,
 	PERF_COUNT_HW_CACHE_MISSES		= 3,
 	PERF_COUNT_HW_BRANCH_INSTRUCTIONS	= 4,
-	PERF_COUNT_HW_BRANCH_MISSES	= 5,
+	PERF_COUNT_HW_BRANCH_MISSES		= 5,
 	PERF_COUNT_HW_BUS_CYCLES		= 6,
 };
 
@@ -131,8 +131,8 @@ software events, selected by 'event_id':
  */
 enum sw_event_ids {
 	PERF_COUNT_SW_CPU_CLOCK		= 0,
-	PERF_COUNT_SW_TASK_CLOCK		= 1,
-	PERF_COUNT_SW_PAGE_FAULTS		= 2,
+	PERF_COUNT_SW_TASK_CLOCK	= 1,
+	PERF_COUNT_SW_PAGE_FAULTS	= 2,
 	PERF_COUNT_SW_CONTEXT_SWITCHES	= 3,
 	PERF_COUNT_SW_CPU_MIGRATIONS	= 4,
 	PERF_COUNT_SW_PAGE_FAULTS_MIN	= 5,
-- 
1.6.2.5

