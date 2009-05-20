Return-Path: <linux-kernel-owner+w=401wt.eu-S1756475AbZETT6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475AbZETT6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 15:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbZETT6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 15:58:04 -0400
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:3712 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbZETT6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 15:58:03 -0400
X-Greylist: delayed 3163 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 May 2009 15:58:03 EDT
From: Alberto Bertogli <albertito@blitiri.com.ar>
To: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       Alberto Bertogli <albertito@blitiri.com.ar>
Subject: [PATCH 4/4] ftrace: Use function_graph instead of function_graph_tracer in the docs
Date: Wed, 20 May 2009 16:06:41 -0300
Message-Id: <1242846401-1417-1-git-send-email-albertito@blitiri.com.ar>
X-Mailer: git-send-email 1.6.2.2.646.gb214
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>
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
1.6.2.2.646.gb214

