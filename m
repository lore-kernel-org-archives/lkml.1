Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbYHSGBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbYHSGBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 02:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbYHSGBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 02:01:16 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42370 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbYHSGBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 02:01:16 -0400
Date: Tue, 19 Aug 2008 09:01:14 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: wim@iguana.be
cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] watchdog/at91: fix misleading indentation
Message-ID: <Pine.LNX.4.64.0808190859320.4551@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696208474-1486158005-1219125674=:4551"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696208474-1486158005-1219125674=:4551
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT


Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
---
 drivers/watchdog/at91rm9200_wdt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/at91rm9200_wdt.c b/drivers/watchdog/at91rm9200_wdt.c
index d061f0a..993e5f5 100644
--- a/drivers/watchdog/at91rm9200_wdt.c
+++ b/drivers/watchdog/at91rm9200_wdt.c
@@ -241,7 +241,7 @@ static int at91wdt_resume(struct platform_device *pdev)
 {
 	if (at91wdt_busy)
 		at91_wdt_start();
-		return 0;
+	return 0;
 }
 
 #else
-- 
1.5.2.2

---696208474-1486158005-1219125674=:4551--
