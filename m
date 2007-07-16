Return-Path: <linux-kernel-owner+w=401wt.eu-S1764030AbXGPVzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764030AbXGPVzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 17:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760133AbXGPVzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 17:55:11 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:6544 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759777AbXGPVzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 17:55:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=uj1bZahRFXs8P6KkRMX5e3d4wWu54vjK4aPO2ATQKFs656ZyJzDvzo5iRcHcnH99nTEeIZBxA4NUoCyX/oVZWK+HCl4PmMVe7ma9pHAfs/njmSxnapRGYktlHHPLPc6xkl7/EqpHrK/FT3hl4CWu++t0rhLpqRXuzlSFIbyfQGQ=
Date: Mon, 16 Jul 2007 23:55:05 +0200
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: michal.k.k.piotrowski@gmail.com
Subject: [PATCH] Add the knwon_regression URI to the documentation
Message-ID: <20070716235505.51ebe812@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We should let everybody know about where the regression
list is hosted. The more is known the more it is used.

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 Documentation/HOWTO |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/Documentation/HOWTO b/Documentation/HOWTO
index 98e2701..08f4eb4 100644
--- a/Documentation/HOWTO
+++ b/Documentation/HOWTO
@@ -249,6 +249,9 @@ process is as follows:
     release a new -rc kernel every week.
   - Process continues until the kernel is considered "ready", the
     process should last around 6 weeks.
+  - A list of known regressions present in each -rc release is 
+    tracked at the following URI:
+    http://kernelnewbies.org/known_regressions 
 
 It is worth mentioning what Andrew Morton wrote on the linux-kernel
 mailing list about kernel releases:
-- 
1.5.3.rc2

