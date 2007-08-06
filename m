Return-Path: <linux-kernel-owner+w=401wt.eu-S933289AbXHFWiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933289AbXHFWiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 18:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761397AbXHFWiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 18:38:07 -0400
Received: from sp604001mt.neufgp.fr ([84.96.92.60]:61290 "EHLO Smtp.neuf.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756366AbXHFWiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 18:38:06 -0400
X-Greylist: delayed 491 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Aug 2007 18:38:06 EDT
Date: Tue, 07 Aug 2007 00:38:00 +0200
From: Vincent Legoll <vincent.legoll@gmail.com>
Subject: [PATCH] - Fix typo in Documentation/SubmitChecklist
To: LKML <linux-kernel@vger.kernel.org>
Reply-to: vincent.legoll@gmail.com
Message-id: <1186439880.21014.14.camel@quad>
MIME-version: 1.0
X-Mailer: Evolution 2.10.2
Content-type: text/plain
Content-transfer-encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 065f7037a99d14c8678384c60046b8d39b1524c8 Mon Sep 17 00:00:00 2001
From: Vincent Legoll <vincent.legoll@gmail.com>
Date: Sat, 4 Aug 2007 17:07:25 +0200
Subject: [PATCH] - Fix typo in Documentation/SubmitChecklist


Signed-off-by: Vincent Legoll <vincent.legoll@gmail.com>
---
 Documentation/SubmitChecklist |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/SubmitChecklist b/Documentation/SubmitChecklist
index 19e7f65..34e06d2 100644
--- a/Documentation/SubmitChecklist
+++ b/Documentation/SubmitChecklist
@@ -67,7 +67,7 @@ kernel patches.
 20: Check that it all passes `make headers_check'.
 
 21: Has been checked with injection of at least slab and
page-allocation
-    fauilures.  See Documentation/fault-injection/.
+    failures.  See Documentation/fault-injection/.
 
     If the new code is substantial, addition of subsystem-specific
fault
     injection might be appropriate.
-- 
1.5.2.4



