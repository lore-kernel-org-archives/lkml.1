Return-Path: <linux-kernel-owner+w=401wt.eu-S1752593AbXLQUGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbXLQUGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:06:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763709AbXLQTmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:42:05 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3241 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934024AbXLQTle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:41:34 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jamal Hadi Salim <hadi@cyberus.ca>, netdev@vger.kernel.org
Subject: [PATCH] net/sched/: Spelling fixes
Date: Mon, 17 Dec 2007 11:40:36 -0800
Message-Id: <1197920439-5455-30-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918894.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 net/sched/sch_hfsc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index 55e7e45..a6ad491 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -160,7 +160,7 @@ struct hfsc_class
 	u64	cl_vtoff;		/* inter-period cumulative vt offset */
 	u64	cl_cvtmax;		/* max child's vt in the last period */
 	u64	cl_cvtoff;		/* cumulative cvtmax of all periods */
-	u64	cl_pcvtoff;		/* parent's cvtoff at initalization
+	u64	cl_pcvtoff;		/* parent's cvtoff at initialization
 					   time */
 
 	struct internal_sc cl_rsc;	/* internal real-time service curve */
-- 
1.5.3.7.949.g2221a6

