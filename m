Return-Path: <linux-kernel-owner+w=401wt.eu-S1753750AbYJIX4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbYJIX4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 19:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbYJIXzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 19:55:00 -0400
Received: from xenotime.net ([66.160.160.81]:59569 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752858AbYJIXy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 19:54:57 -0400
Date: Thu, 09 Oct 2008 16:52:35 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] docs: add URL for paper on submitting patches
Message-ID: <12235963552620@xenotime.net>
In-Reply-To: <12235963551043@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a reference to paper to SubmittingPatches

For this year's OLS I wrote a paper on successfull strategies
to submit difficult kernel patches. Add a reference to it to
SubmittingPatches.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

---
 Documentation/SubmittingPatches |    5 +++++
 1 file changed, 5 insertions(+)

--- linux-2.6.27-rc9-git2.orig/Documentation/SubmittingPatches
+++ linux-2.6.27-rc9-git2/Documentation/SubmittingPatches
@@ -672,4 +672,9 @@ Kernel Documentation/CodingStyle:
 
 Linus Torvalds's mail on the canonical patch format:
   <http://lkml.org/lkml/2005/4/7/183>
+
+Andi Kleen, "On submitting kernel patches"
+  Some strategies to get difficult or controversal changes in.
+  http://halobates.de/on-submitting-patches.pdf
+
 --


-- 

