Return-Path: <linux-kernel-owner+w=401wt.eu-S1759709AbYCGI4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759709AbYCGI4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 03:56:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbYCGI4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 03:56:36 -0500
Received: from softobject-gw.kiev.ucomline.net ([62.221.40.190]:58993 "EHLO
	localhost" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753680AbYCGI4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 03:56:35 -0500
X-Greylist: delayed 2856 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Mar 2008 03:56:35 EST
From: Andy Shevchenko <andy@smile.org.ua>
To: linux-kernel@vger.kernel.org
Cc: drzeus-list@drzeus.cx, Andy Shevchenko <andy@smile.org.ua>
Subject: [PATCH] [SDIO] add vendor and product pair for SQN1130
Date: Fri,  7 Mar 2008 10:08:30 +0200
Message-Id: <12048773103435-git-send-email-andy@smile.org.ua>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: andy@smile.org.ua
References: andy@smile.org.ua
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the vendor and product ids for Sequans SQN1130 WiMAX chipset.
---
 include/linux/mmc/sdio_ids.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
index ea1bf5b..d1b9883 100644
--- a/include/linux/mmc/sdio_ids.h
+++ b/include/linux/mmc/sdio_ids.h
@@ -26,4 +26,7 @@
 #define SDIO_VENDOR_ID_MARVELL			0x02df
 #define SDIO_DEVICE_ID_MARVELL_LIBERTAS		0x9103
 
+#define SDIO_VENDOR_ID_SEQUANS			0x039d
+#define SDIO_DEVICE_ID_SEQUANS_SQN1130		0x046a
+
 #endif
-- 
1.5.2.5

