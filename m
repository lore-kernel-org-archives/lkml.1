Return-Path: <linux-kernel-owner+w=401wt.eu-S1751516AbZIWKEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbZIWKEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 06:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbZIWKEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 06:04:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbZIWKEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 06:04:47 -0400
Date: Wed, 23 Sep 2009 06:03:53 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@xenotime.net>, Jiri Kosina <jkosina@suse.cz>,
       Thomas Gleixner <tglx@linutronix.de>, Amerigo Wang <amwang@redhat.com>,
       akpm@linux-foundation.org, Matt LaPlante <kernel1@cyberdogtech.com>
Message-Id: <20090923100627.23628.96394.sendpatchset@localhost.localdomain>
Subject: [Patch] trivial: fix a URL in hpet.txt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


That URL is out of date. Update it.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Matt LaPlante <kernel1@cyberdogtech.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: WANG Cong <amwang@redhat.com>

---
diff --git a/Documentation/timers/hpet.txt b/Documentation/timers/hpet.txt
index 04763a3..16d25e6 100644
--- a/Documentation/timers/hpet.txt
+++ b/Documentation/timers/hpet.txt
@@ -3,7 +3,7 @@
 The High Precision Event Timer (HPET) hardware follows a specification
 by Intel and Microsoft which can be found at
 
-	http://www.intel.com/technology/architecture/hpetspec.htm
+	http://www.intel.com/hardwaredesign/hpetspec_1.pdf
 
 Each HPET has one fixed-rate counter (at 10+ MHz, hence "High Precision")
 and up to 32 comparators.  Normally three or more comparators are provided,
