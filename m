Return-Path: <linux-kernel-owner+w=401wt.eu-S1755373AbZCGOzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbZCGOzt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 09:55:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbZCGOzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 09:55:40 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37248 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbZCGOzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 09:55:40 -0500
Date: Sat, 7 Mar 2009 23:55:09 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ftrace: fix documentaion typo s/trace_max_latency/tracing_max_latency/
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20090307235209.5A84.A69D9226@jp.fujitsu.com>
References: <20090307235209.5A84.A69D9226@jp.fujitsu.com>
Message-Id: <20090307235409.5A87.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There isn't trace_max_latency. there is tracing_max_latency.
fixing here.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 Documentation/ftrace.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/ftrace.txt b/Documentation/ftrace.txt
index d124e6a..aad5809 100644
--- a/Documentation/ftrace.txt
+++ b/Documentation/ftrace.txt
@@ -93,7 +93,7 @@ of ftrace. Here is a list of some of the key files:
 	that is displayed in one of the above output
 	files.
 
-  trace_max_latency:
+  tracing_max_latency:
 
 	Some of the tracers record the max latency.
 	For example, the time interrupts are disabled.
-- 
1.6.0.6



