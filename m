Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbZHSWrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbZHSWrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 18:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbZHSWrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 18:47:42 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35272 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbZHSWrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 18:47:41 -0400
Message-ID: <43836.192.168.10.88.1250722017.squirrel@dbdmail.itg.ti.com>
Date: Thu, 20 Aug 2009 04:16:57 +0530 (IST)
Subject: [PATCH] Maintainers update for TI OMAP hsmmc driver
From: "Madhusudhan Chikkature" <madhu.cr@ti.com>
To: akpm@linux-foundation.org, linux-mmc@vger.kernel.org
Cc: jarkko.lavinen@nokia.com, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have posted this patch to linux-mmc@vger.kernel.org list earlier. I am
reposting it to Andrew as I am not clear on the upstream path from
linux-mmc@vger.kernel.org list currently.

Regards,
Madhu
---

Update maintainers entry for TI OMAP HS MMC support.

Signed-off-by: Madhusudhan Chikkature <madhu.cr@ti.com>
Acked-by: Kevin Hilman <khilman@deeprootsystems.com>
---
 MAINTAINERS |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6/MAINTAINERS
===================================================================
--- linux-2.6.orig/MAINTAINERS
+++ linux-2.6/MAINTAINERS
@@ -3712,7 +3712,13 @@ OMAP MMC SUPPORT
 M:	Jarkko Lavinen <jarkko.lavinen@nokia.com>
 L:	linux-omap@vger.kernel.org
 S:	Maintained
-F:	drivers/mmc/host/*omap*
+F:	drivers/mmc/host/omap.c
+
+OMAP HS MMC SUPPORT
+M:	Madhusudhan Chikkature <madhu.cr@ti.com>
+L:	linux-omap@vger.kernel.org
+S:	Maintained
+F:	drivers/mmc/host/omap_hsmmc.c

 OMAP RANDOM NUMBER GENERATOR SUPPORT
 M:	Deepak Saxena <dsaxena@plexity.net>


