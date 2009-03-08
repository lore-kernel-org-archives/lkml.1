Return-Path: <linux-kernel-owner+w=401wt.eu-S1753153AbZCHPyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbZCHPyK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 11:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639AbZCHPxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 11:53:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:34165 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753675AbZCHPxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 11:53:01 -0400
Date: Sun, 8 Mar 2009 15:52:23 GMT
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       srostedt@redhat.com, tglx@linutronix.de, kosaki.motohiro@jp.fujitsu.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       srostedt@redhat.com, tglx@linutronix.de, kosaki.motohiro@jp.fujitsu.com,
       mingo@elte.hu
In-Reply-To: <20090307235409.5A87.A69D9226@jp.fujitsu.com>
References: <20090307235409.5A87.A69D9226@jp.fujitsu.com>
Subject: [tip:tracing/doc] ftrace: fix documentation typo s/trace_max_latency/tracing_max_latency/
Message-ID: <tip-42b40b3d55f5782b00b74d9105c3565fbfa5cb80@git.kernel.org>
Git-Commit-ID: 42b40b3d55f5782b00b74d9105c3565fbfa5cb80
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 08 Mar 2009 15:52:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  42b40b3d55f5782b00b74d9105c3565fbfa5cb80
Gitweb:     http://git.kernel.org/tip/42b40b3d55f5782b00b74d9105c3565fbfa5cb80
Author:     "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
AuthorDate: Sat, 7 Mar 2009 23:55:09 +0900
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Mar 2009 16:50:07 +0100

ftrace: fix documentation typo s/trace_max_latency/tracing_max_latency/

There isn't a trace_max_latency file, there is tracing_max_latency.
Fix it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Steven Rostedt <srostedt@redhat.com>
LKML-Reference: <20090307235409.5A87.A69D9226@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/ftrace.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/ftrace.txt b/Documentation/ftrace.txt
index 22614be..fd9a3e6 100644
--- a/Documentation/ftrace.txt
+++ b/Documentation/ftrace.txt
@@ -100,7 +100,7 @@ of ftrace. Here is a list of some of the key files:
 	that is displayed in one of the above output
 	files.
 
-  trace_max_latency:
+  tracing_max_latency:
 
 	Some of the tracers record the max latency.
 	For example, the time interrupts are disabled.
