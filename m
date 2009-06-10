Return-Path: <linux-kernel-owner+w=401wt.eu-S1760507AbZFJWeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760507AbZFJWeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 18:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757312AbZFJWd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 18:33:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:50061 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757231AbZFJWd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 18:33:57 -0400
Date: Wed, 10 Jun 2009 22:33:15 GMT
From: tip-bot for Mike Frysinger <vapier@gentoo.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, vapier@gentoo.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, vapier@gentoo.org, tglx@linutronix.de
In-Reply-To: <1244623722-6325-1-git-send-email-vapier@gentoo.org>
References: <1244623722-6325-1-git-send-email-vapier@gentoo.org>
Subject: [tip:tracing/core] ftrace/documentation: fix typo in function grapher name
Message-ID: <tip-bc5c6c043d8381676339fb3da59cc4cc5921d368@git.kernel.org>
Git-Commit-ID: bc5c6c043d8381676339fb3da59cc4cc5921d368
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 10 Jun 2009 22:33:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bc5c6c043d8381676339fb3da59cc4cc5921d368
Gitweb:     http://git.kernel.org/tip/bc5c6c043d8381676339fb3da59cc4cc5921d368
Author:     Mike Frysinger <vapier@gentoo.org>
AuthorDate: Wed, 10 Jun 2009 04:48:41 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 10 Jun 2009 13:06:25 -0400

ftrace/documentation: fix typo in function grapher name

The function graph tracer is called just "function_graph" (no trailing
"_tracer" needed).

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
LKML-Reference: <1244623722-6325-1-git-send-email-vapier@gentoo.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


---
 Documentation/trace/ftrace.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
