Return-Path: <linux-kernel-owner+w=401wt.eu-S1761370AbZFJRI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761370AbZFJRI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 13:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754430AbZFJRIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 13:08:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62292 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbZFJRIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 13:08:20 -0400
Date: Wed, 10 Jun 2009 13:08:22 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH][GIT PULL] ftrace/documentation: fix typo in function grapher
 name
In-Reply-To: <1244623722-6325-1-git-send-email-vapier@gentoo.org>
Message-ID: <alpine.DEB.2.00.0906101307100.30552@gandalf.stny.rr.com>
References: <1244623722-6325-1-git-send-email-vapier@gentoo.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Mike Frysinger (1):
      ftrace/documentation: fix typo in function grapher name

----
 Documentation/trace/ftrace.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
---------------------------
commit bc5c6c043d8381676339fb3da59cc4cc5921d368
Author: Mike Frysinger <vapier@gentoo.org>
Date:   Wed Jun 10 04:48:41 2009 -0400

    ftrace/documentation: fix typo in function grapher name
    
    The function graph tracer is called just "function_graph" (no trailing
    "_tracer" needed).
    
    Signed-off-by: Mike Frysinger <vapier@gentoo.org>
    LKML-Reference: <1244623722-6325-1-git-send-email-vapier@gentoo.org>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index fd9a3e6..5ad2ded 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -179,7 +179,7 @@ Here is the list of current tracers that may be configured.
 
 	Function call tracer to trace all kernel functions.
 
-  "function_graph_tracer"
+  "function_graph"
 
 	Similar to the function tracer except that the
 	function tracer probes the functions on their entry


