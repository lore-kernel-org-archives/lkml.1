Return-Path: <linux-kernel-owner+w=401wt.eu-S1764310AbXGRXbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764310AbXGRXbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762834AbXGRX1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:27:10 -0400
Received: from mail.suse.de ([195.135.220.2]:57460 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936194AbXGRX1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:27:07 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
       Li Yang <leoli@freescale.com>, TripleX Chung <xxx.phy@gmail.com>,
       Maggie Chen <chenqi@beyondsoft.com>,
       WANG Cong <xiyou.wangcong@gmail.com>,
       Tsugikazu Shibata <tshibata@ab.jp.nec.com>,
       IKEDA Munehiro <m-ikeda@ds.jp.nec.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 11/14] HOWTO: Add the knwon_regression URI to the documentation
Date: Wed, 18 Jul 2007 16:25:47 -0700
Message-Id: <11848011924027-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <1184801188568-git-send-email-gregkh@suse.de>
References: <20070718232400.GC4620@kroah.com>
 <11848011502972-git-send-email-gregkh@suse.de>
 <11848011551094-git-send-email-gregkh@suse.de>
 <11848011593154-git-send-email-gregkh@suse.de>
 <118480116414-git-send-email-gregkh@suse.de>
 <1184801169806-git-send-email-gregkh@suse.de>
 <11848011731698-git-send-email-gregkh@suse.de>
 <1184801177102-git-send-email-gregkh@suse.de>
 <11848011802979-git-send-email-gregkh@suse.de>
 <11848011842017-git-send-email-gregkh@suse.de>
 <1184801188568-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>

We should let everybody know about where the regression
list is hosted. The more is known the more it is used.

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: Li Yang <leoli@freescale.com>
Cc: TripleX Chung <xxx.phy@gmail.com>
Cc: Maggie Chen <chenqi@beyondsoft.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Tsugikazu Shibata <tshibata@ab.jp.nec.com>
Cc: IKEDA Munehiro <m-ikeda@ds.jp.nec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/HOWTO |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/Documentation/HOWTO b/Documentation/HOWTO
index 98e2701..f8cc3f8 100644
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
1.5.2.2

