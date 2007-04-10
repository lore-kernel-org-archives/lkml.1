Return-Path: <linux-kernel-owner+w=401wt.eu-S1753153AbXDJTVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbXDJTVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 15:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbXDJTVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 15:21:19 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:42929 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753153AbXDJTVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 15:21:18 -0400
Message-Id: <20070410192007.245266192@mvista.com>
User-Agent: quilt/0.46-1
Date: Tue, 10 Apr 2007 12:20:07 -0700
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH] clocksource: acpi_pm trivial comment update
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 drivers/clocksource/acpi_pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.20/drivers/clocksource/acpi_pm.c
===================================================================
--- linux-2.6.20.orig/drivers/clocksource/acpi_pm.c
+++ linux-2.6.20/drivers/clocksource/acpi_pm.c
@@ -26,7 +26,7 @@
 /*
  * The I/O port the PMTMR resides at.
  * The location is detected during setup_arch(),
- * in arch/i386/acpi/boot.c
+ * in arch/i386/kernel/acpi/boot.c
  */
 u32 pmtmr_ioport __read_mostly;
 
-- 

-- 
