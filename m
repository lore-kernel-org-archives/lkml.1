Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbXLSDuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbXLSDuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 22:50:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbXLSDuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 22:50:14 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:4814 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbXLSDuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 22:50:13 -0500
Subject: [PATCH] MAINTAINERS:  mailing list archives are web links
From: Joe Perches <joe@perches.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 18 Dec 2007 19:50:09 -0800
Message-Id: <1198036210.4891.52.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

L: entries should be email addresses
Change L:http entries to W:http

Signed-off-by: Joe Perches <joe@perches.com>
---
diff --git a/MAINTAINERS b/MAINTAINERS
index 3c7db62..907094f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2025,26 +2025,26 @@ S:	Supported
 INTEL PRO/WIRELESS 2100 NETWORK CONNECTION SUPPORT
 P:	Yi Zhu
 M:	yi.zhu@intel.com
 P:	James Ketrenos
 M:	jketreno@linux.intel.com
 L:	linux-wireless@vger.kernel.org
 L:	ipw2100-devel@lists.sourceforge.net
-L:	http://lists.sourceforge.net/mailman/listinfo/ipw2100-devel
+W:	http://lists.sourceforge.net/mailman/listinfo/ipw2100-devel
 W:	http://ipw2100.sourceforge.net
 S:	Supported
 
 INTEL PRO/WIRELESS 2915ABG NETWORK CONNECTION SUPPORT
 P:	Yi Zhu
 M:	yi.zhu@intel.com
 P:	James Ketrenos
 M:	jketreno@linux.intel.com
 L:	linux-wireless@vger.kernel.org
 L:	ipw2100-devel@lists.sourceforge.net
-L:	http://lists.sourceforge.net/mailman/listinfo/ipw2100-devel
+W:	http://lists.sourceforge.net/mailman/listinfo/ipw2100-devel
 W:	http://ipw2200.sourceforge.net
 S:	Supported
 
 INTEL WIRELESS WIFI LINK (iwlwifi)
 P:	Zhu Yi
 M:	yi.zhu@intel.com
 L:	linux-wireless@vger.kernel.org
@@ -2593,15 +2593,15 @@ P:	Jiri Slaby
 M:	jirislaby@gmail.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
 MSI LAPTOP SUPPORT
 P:	Lennart Poettering
 M:	mzxreary@0pointer.de
-L:	https://tango.0pointer.de/mailman/listinfo/s270-linux
+W:	https://tango.0pointer.de/mailman/listinfo/s270-linux
 W:	http://0pointer.de/lennart/tchibo.html
 S:	Maintained
 
 MULTIMEDIA CARD (MMC), SECURE DIGITAL (SD) AND SDIO SUBSYSTEM
 P:	Pierre Ossman
 M:	drzeus-mmc@drzeus.cx
 L:	linux-kernel@vger.kernel.org


