Return-Path: <linux-kernel-owner+w=401wt.eu-S1752020AbZFPKEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbZFPKEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 06:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbZFPKEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 06:04:13 -0400
Received: from mail.atmel.fr ([81.80.104.162]:39158 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbZFPKEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 06:04:13 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com,
       pierre@ossman.eu
Cc: linux-arm-kernel@lists.arm.linux.org.uk, poorarm@shoreis.com,
       nicolas.ferre@atmel.com
Subject: [PATCH] MAINTAINERS: add myself as atmel-mci maintainer (sd/mmc interface)
Date: Tue, 16 Jun 2009 13:05:50 +0200
Message-Id: <1245150350-4798-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.3.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add MAINTAINERS entry for atmel-mci driver.
This driver was maintained by its author: Haavard Skinnemoen. I take the
maintainance of it.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 MAINTAINERS |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c944d61..b6851f4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -991,6 +991,13 @@ W:	http://www.at91.com/
 S:	Maintained
 F:	drivers/mmc/host/at91_mci.c
 
+ATMEL AT91 / AT32 MCI DRIVER
+P:	Nicolas Ferre
+M:	nicolas.ferre@atmel.com
+S:	Maintained
+F:	drivers/mmc/host/atmel-mci.c
+F:	drivers/mmc/host/atmel-mci-regs.h
+
 ATMEL AT91 / AT32 SERIAL DRIVER
 P:	Haavard Skinnemoen
 M:	hskinnemoen@atmel.com
-- 
1.5.3.7

