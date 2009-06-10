Return-Path: <linux-kernel-owner+w=401wt.eu-S1758201AbZFJIs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201AbZFJIs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 04:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbZFJIsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 04:48:51 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45412 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469AbZFJIsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 04:48:51 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ftrace.txt: fix typo in function grapher name
Date: Wed, 10 Jun 2009 04:48:41 -0400
Message-Id: <1244623722-6325-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function graph tracer is called just "function_graph" (no trailing
"_tracer" needed).

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
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
-- 
1.6.3.1

