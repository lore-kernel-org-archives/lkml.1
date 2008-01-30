Return-Path: <linux-kernel-owner+w=401wt.eu-S1759071AbYA3JQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759071AbYA3JQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 04:16:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755543AbYA3JNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 04:13:53 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:63544 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707AbYA3JNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 04:13:47 -0500
X-IronPort-AV: E=Sophos;i="4.25,276,1199682000"; 
   d="scan'208";a="47623408"
From: Bryan Wu <bryan.wu@analog.com>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org,
       Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 6/6] [Blackfin] SPI driver: use simpler comment headers and strip out information that is maintained in the scm's log
Date: Wed, 30 Jan 2008 17:13:41 +0800
Message-Id: <1201684421-26124-7-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1201684421-26124-1-git-send-email-bryan.wu@analog.com>
References: <1201684421-26124-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/spi/spi_bfin5xx.c |   32 +++-----------------------------
 1 files changed, 3 insertions(+), 29 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 9f12639..6338235 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -1,37 +1,11 @@
 /*
- * File:	drivers/spi/bfin5xx_spi.c
- * Maintainer:
- *		Bryan Wu <bryan.wu@analog.com>
- * Original Author:
- *		Luke Yang (Analog Devices Inc.)
- *
- * Created:	March. 10th 2006
- * Description:	SPI controller driver for Blackfin BF5xx
- * Bugs:	Enter bugs at http://blackfin.uclinux.org/
- *
- * Modified:
- *	March 10, 2006  bfin5xx_spi.c Created. (Luke Yang)
- *      August 7, 2006  added full duplex mode (Axel Weiss & Luke Yang)
- *      July  17, 2007  add support for BF54x SPI0 controller (Bryan Wu)
- *      July  30, 2007  add platfrom_resource interface to support multi-port
- *                      SPI controller (Bryan Wu)
+ * Blackfin On-Chip SPI Driver
  *
  * Copyright 2004-2007 Analog Devices Inc.
  *
- * This program is free software ;  you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation ;  either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY ;  without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
+ * Enter bugs at http://blackfin.uclinux.org/
  *
- * You should have received a copy of the GNU General Public License
- * along with this program ;  see the file COPYING.
- * If not, write to the Free Software Foundation,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * Licensed under the GPL-2 or later.
  */
 
 #include <linux/init.h>
-- 
1.5.3.4
