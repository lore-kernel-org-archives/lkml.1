Return-Path: <linux-kernel-owner+w=401wt.eu-S1759264AbYA3Iyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264AbYA3Iyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 03:54:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757447AbYA3Iww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 03:52:52 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:51389 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245AbYA3Iws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 03:52:48 -0500
X-IronPort-AV: E=Sophos;i="4.25,276,1199682000"; 
   d="scan'208";a="47621982"
From: Bryan Wu <bryan.wu@analog.com>
To: jeff@garzik.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 4/8] [Blackfin] EMAC driver: use simpler comment headers and strip out information that is maintained in the scm's log
Date: Wed, 30 Jan 2008 16:52:24 +0800
Message-Id: <1201683148-23931-5-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1201683148-23931-1-git-send-email-bryan.wu@analog.com>
References: <1201683148-23931-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/net/bfin_mac.c |   32 ++++----------------------------
 drivers/net/bfin_mac.h |   31 ++++---------------------------
 2 files changed, 8 insertions(+), 55 deletions(-)

diff --git a/drivers/net/bfin_mac.c b/drivers/net/bfin_mac.c
index c6586cd..ed935e1 100644
--- a/drivers/net/bfin_mac.c
+++ b/drivers/net/bfin_mac.c
@@ -1,35 +1,11 @@
 /*
- * File:	drivers/net/bfin_mac.c
- * Based on:
- * Maintainer:
- * 		Bryan Wu <bryan.wu@analog.com>
+ * Blackfin On-Chip MAC Driver
  *
- * Original author:
- * 		Luke Yang <luke.yang@analog.com>
+ * Copyright 2004-2007 Analog Devices Inc.
  *
- * Created:
- * Description:
+ * Enter bugs at http://blackfin.uclinux.org/
  *
- * Modified:
- * 		2006-12-19 Aidan Williams, multicast hash support
- *		Copyright 2004-2006 Analog Devices Inc.
- *
- * Bugs:	Enter bugs at http://blackfin.uclinux.org/
- *
- * This program is free software ;  you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation ;  either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY ;  without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program ;  see the file COPYING.
- * If not, write to the Free Software Foundation,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * Licensed under the GPL-2 or later.
  */
 
 #include <linux/init.h>
diff --git a/drivers/net/bfin_mac.h b/drivers/net/bfin_mac.h
index 5970ea7..f774d5a 100644
--- a/drivers/net/bfin_mac.h
+++ b/drivers/net/bfin_mac.h
@@ -1,34 +1,11 @@
 /*
- * File:	drivers/net/bfin_mac.c
- * Based on:
- * Maintainer:
- * 		Bryan Wu <bryan.wu@analog.com>
+ * Blackfin On-Chip MAC Driver
  *
- * Original author:
- * 		Luke Yang <luke.yang@analog.com>
+ * Copyright 2004-2007 Analog Devices Inc.
  *
- * Created:
- * Description:
+ * Enter bugs at http://blackfin.uclinux.org/
  *
- * Modified:
- *		Copyright 2004-2006 Analog Devices Inc.
- *
- * Bugs:	Enter bugs at http://blackfin.uclinux.org/
- *
- * This program is free software ;  you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation ;  either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY ;  without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program ;  see the file COPYING.
- * If not, write to the Free Software Foundation,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * Licensed under the GPL-2 or later.
  */
 
 #define BFIN_MAC_CSUM_OFFLOAD
-- 
1.5.3.4
