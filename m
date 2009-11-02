Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbZKBQUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbZKBQUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755347AbZKBQUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:20:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:53790 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755973AbZKBQUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:20:15 -0500
Date: Mon, 2 Nov 2009 16:19:32 GMT
From: tip-bot for Thadeu Lima de Souza Cascardo 
	<cascardo@holoscopio.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       cascardo@holoscopio.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, cascardo@holoscopio.com, mingo@elte.hu
In-Reply-To: <1256938346-8230-1-git-send-email-cascardo@holoscopio.com>
References: <1256938346-8230-1-git-send-email-cascardo@holoscopio.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf_events: Fix some typo in the perf events config description
Message-ID: <tip-dd77038d233d106f297b907bf51459dfb1099eb1@git.kernel.org>
Git-Commit-ID: dd77038d233d106f297b907bf51459dfb1099eb1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dd77038d233d106f297b907bf51459dfb1099eb1
Gitweb:     http://git.kernel.org/tip/dd77038d233d106f297b907bf51459dfb1099eb1
Author:     Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
AuthorDate: Fri, 30 Oct 2009 19:32:25 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 2 Nov 2009 16:53:35 +0100

perf_events: Fix some typo in the perf events config description

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: trivial@kernel.org
LKML-Reference: <1256938346-8230-1-git-send-email-cascardo@holoscopio.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 init/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 09c5c64..3b8c7bc 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -937,7 +937,7 @@ config PERF_EVENTS
 	  Enable kernel support for various performance events provided
 	  by software and hardware.
 
-	  Software events are supported either build-in or via the
+	  Software events are supported either built-in or via the
 	  use of generic tracepoints.
 
 	  Most modern CPUs support performance events via performance
@@ -949,7 +949,7 @@ config PERF_EVENTS
 	  used to profile the code that runs on that CPU.
 
 	  The Linux Performance Event subsystem provides an abstraction of
-	  these software and hardware cevent apabilities, available via a
+	  these software and hardware event capabilities, available via a
 	  system call and used by the "perf" utility in tools/perf/. It
 	  provides per task and per CPU counters, and it provides event
 	  capabilities on top of those.
