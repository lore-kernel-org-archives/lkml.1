Return-Path: <linux-kernel-owner+w=401wt.eu-S968165AbXEHPcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968165AbXEHPcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 11:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbXEHPYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 11:24:40 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:12412 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966428AbXEHPTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 11:19:11 -0400
Message-Id: <20070508151800.352375359@mvista.com>
User-Agent: quilt/0.46-1
Date: Tue, 08 May 2007 08:18:00 -0700
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] clocksource: spell error in watchdog code
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 kernel/time/clocksource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.21/kernel/time/clocksource.c
===================================================================
--- linux-2.6.21.orig/kernel/time/clocksource.c
+++ linux-2.6.21/kernel/time/clocksource.c
@@ -77,7 +77,7 @@ static cycle_t watchdog_last;
 static int watchdog_resumed;
 
 /*
- * Interval: 0.5sec Treshold: 0.0625s
+ * Interval: 0.5sec Threshold: 0.0625s
  */
 #define WATCHDOG_INTERVAL (HZ >> 1)
 #define WATCHDOG_TRESHOLD (NSEC_PER_SEC >> 4)
-- 

-- 
