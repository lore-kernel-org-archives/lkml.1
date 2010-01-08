Return-Path: <linux-kernel-owner+w=401wt.eu-S1753468Ab0AHMtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab0AHMtv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 07:49:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265Ab0AHMtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 07:49:47 -0500
Received: from landau.phys.spbu.ru ([195.19.235.38]:37364 "EHLO
	landau.phys.spbu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab0AHMtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 07:49:45 -0500
From: Kirill Smelkov <kirr@landau.phys.spbu.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kirill Smelkov <kirr@landau.phys.spbu.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] perf: fix few typos + cosmetics
Date: Fri,  8 Jan 2010 15:23:09 +0300
Message-Id: <616fed930dd36df8730f42062ea2024ca3a92643.1262952612.git.kirr@landau.phys.spbu.ru>
X-Mailer: git-send-email 1.6.6.79.gd514e.dirty
In-Reply-To: <cover.1262952612.git.kirr@landau.phys.spbu.ru>
References: <cover.1262952612.git.kirr@landau.phys.spbu.ru>
In-Reply-To: <cover.1262952612.git.kirr@landau.phys.spbu.ru>
References: <cover.1262952612.git.kirr@landau.phys.spbu.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kirill Smelkov <kirr@landau.phys.spbu.ru>
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
1.6.6.79.gd514e.dirty
