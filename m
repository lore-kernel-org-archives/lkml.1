Return-Path: <linux-kernel-owner+w=401wt.eu-S1760185AbZAMGO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760185AbZAMGO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 01:14:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759381AbZAMGMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 01:12:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52477 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756848AbZAMGLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 01:11:50 -0500
Message-Id: <20090113061148.807298761@goodmis.org>
References: <20090113061110.856268617@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 13 Jan 2009 01:11:19 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Shaohua Li <shaohua.li@intel.com>, ia64 <linux-ia64@vger.kernel.org>,
       Tony Luck <tony.luck@intel.com>, Sam Ravnborg <sam@ravnborg.org>,
       u.kleine-koenig@pengutronix.de, Uwe Kleine-K?nig <ukleinek@strlen.de>,
       trivial@kernel.org, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 9/9] ftrace, trivial: fix typo "resgister" -> "register"
Content-Disposition: inline; filename=0009-ftrace-trivial-fix-typo-resgister-register.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>

Signed-off-by: Uwe Kleine-K?nig <ukleinek@strlen.de>
Cc: trivial@kernel.org
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 9f53610..8c1c9c0 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1894,7 +1894,7 @@ int register_ftrace_function(struct ftrace_ops *ops)
 }
 
 /**
- * unregister_ftrace_function - unresgister a function for profiling.
+ * unregister_ftrace_function - unregister a function for profiling.
  * @ops - ops structure that holds the function to unregister
  *
  * Unregister a function that was added to be called by ftrace profiling.
-- 
1.5.6.5

-- 
