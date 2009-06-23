Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbZFWJaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbZFWJaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 05:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbZFWJaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 05:30:00 -0400
Received: from gw03.mail.saunalahti.fi ([195.197.172.111]:54948 "EHLO
	gw03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbZFWJ37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 05:29:59 -0400
X-Greylist: delayed 494 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jun 2009 05:29:59 EDT
From: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       trivial@kernel.org
Cc: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Subject: [PATCH] Fix a typo in linux/workqueue.h
Date: Tue, 23 Jun 2009 12:21:37 +0300
Message-Id: <1245748897-24912-1-git-send-email-dmitri.vorobiev@movial.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change "useing" -> "using".

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
---
 include/linux/workqueue.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 13e1adf..f3a61fd 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -94,7 +94,7 @@ struct execute_work {
 /*
  * initialize all of a work item in one go
  *
- * NOTE! No point in using "atomic_long_set()": useing a direct
+ * NOTE! No point in using "atomic_long_set()": using a direct
  * assignment of the work data initializer allows the compiler
  * to generate better code.
  */
-- 
1.6.0.4

