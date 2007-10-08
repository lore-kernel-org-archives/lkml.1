Return-Path: <linux-kernel-owner+w=401wt.eu-S1752433AbXJHSzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbXJHSzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 14:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754245AbXJHSzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 14:55:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451AbXJHSzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 14:55:33 -0400
Date: Mon, 8 Oct 2007 14:55:12 -0400
From: James Bowes <jbowes@dangerouslyinc.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org
Subject: [PATCH] Documentation: Fix typo in SubmitChecklist.
Message-ID: <20071008185510.GA28549@crux.toronto.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: James Bowes <jbowes@dangerouslyinc.com>
---
 Documentation/SubmitChecklist |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/SubmitChecklist b/Documentation/SubmitChecklist
index 19e7f65..34e06d2 100644
--- a/Documentation/SubmitChecklist
+++ b/Documentation/SubmitChecklist
@@ -67,7 +67,7 @@ kernel patches.
 20: Check that it all passes `make headers_check'.
 
 21: Has been checked with injection of at least slab and page-allocation
-    fauilures.  See Documentation/fault-injection/.
+    failures.  See Documentation/fault-injection/.
 
     If the new code is substantial, addition of subsystem-specific fault
     injection might be appropriate.
-- 
1.5.3.4.1155.gfe96ee

