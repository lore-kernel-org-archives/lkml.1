Return-Path: <linux-kernel-owner+w=401wt.eu-S1760646AbZF1Qnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760646AbZF1Qnk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754479AbZF1Q2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:28:48 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1193 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246AbZF1Q2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:28:24 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 60/62] kernel/trace/trace_hw_branches.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:27:05 -0700
Message-Id: <f895400fd3ba3a88cf3240f4dc98de8ae9b41b5e.1246173683.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/trace/trace_hw_branches.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
index ca7d7c4..23b6385 100644
--- a/kernel/trace/trace_hw_branches.c
+++ b/kernel/trace/trace_hw_branches.c
@@ -155,7 +155,7 @@ static enum print_line_t bts_trace_print_line(struct trace_iterator *iter)
 		    seq_print_ip_sym(seq, it->from, symflags) &&
 		    trace_seq_printf(seq, "\n"))
 			return TRACE_TYPE_HANDLED;
-		return TRACE_TYPE_PARTIAL_LINE;;
+		return TRACE_TYPE_PARTIAL_LINE;
 	}
 	return TRACE_TYPE_UNHANDLED;
 }
-- 
1.6.3.1.10.g659a0.dirty

