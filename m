Return-Path: <linux-kernel-owner+w=401wt.eu-S1762004AbYF3N1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762004AbYF3N1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 09:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932206AbYF3N1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 09:27:21 -0400
Received: from mail51.messagelabs.com ([216.82.244.179]:4528 "EHLO
	mail51.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbYF3N1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 09:27:19 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-11.tower-51.messagelabs.com!1214832437!4658953!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
To: <trivail@bre-cln-ukleine.digi.com>, <linux-kernel@vger.kernel.org>
CC: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH] Fix name of Russell King in various comments
Date: Mon, 30 Jun 2008 15:27:13 +0200
Message-ID: <1214832433-11893-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
X-Mailer: git-send-email 1.5.6
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 30 Jun 2008 13:27:14.0457 (UTC) FILETIME=[026B2090:01C8DAB5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch was created by

	git grep -E -l 'Rus(el|s?e)l King' | xargs -r -t perl -p -i -e 's/Rus(el|s?e)l King/Russell King/g'

Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
---
 drivers/usb/host/ohci-au1xxx.c  |    2 +-
 drivers/usb/host/ohci-lh7a404.c |    2 +-
 drivers/usb/host/ohci-s3c2410.c |    2 +-
 drivers/usb/host/ohci-sa1111.c  |    2 +-
 include/asm-avr32/setup.h       |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/ohci-au1xxx.c b/drivers/usb/host/ohci-au1xxx.c
index 1b9abdb..2ec3584 100644
--- a/drivers/usb/host/ohci-au1xxx.c
+++ b/drivers/usb/host/ohci-au1xxx.c
@@ -8,7 +8,7 @@
  * Bus Glue for AMD Alchemy Au1xxx
  *
  * Written by Christopher Hoover <ch@hpl.hp.com>
- * Based on fragments of previous driver by Rusell King et al.
+ * Based on fragments of previous driver by Russell King et al.
  *
  * Modified for LH7A404 from ohci-sa1111.c
  *  by Durgesh Pattamatta <pattamattad@sharpsec.com>
diff --git a/drivers/usb/host/ohci-lh7a404.c b/drivers/usb/host/ohci-lh7a404.c
index 96d14fa..65fe275 100644
--- a/drivers/usb/host/ohci-lh7a404.c
+++ b/drivers/usb/host/ohci-lh7a404.c
@@ -8,7 +8,7 @@
  * Bus Glue for Sharp LH7A404
  *
  * Written by Christopher Hoover <ch@hpl.hp.com>
- * Based on fragments of previous driver by Rusell King et al.
+ * Based on fragments of previous driver by Russell King et al.
  *
  * Modified for LH7A404 from ohci-sa1111.c
  *  by Durgesh Pattamatta <pattamattad@sharpsec.com>
diff --git a/drivers/usb/host/ohci-s3c2410.c b/drivers/usb/host/ohci-s3c2410.c
index a73d2ff..d3fcd0b 100644
--- a/drivers/usb/host/ohci-s3c2410.c
+++ b/drivers/usb/host/ohci-s3c2410.c
@@ -8,7 +8,7 @@
  * USB Bus Glue for Samsung S3C2410
  *
  * Written by Christopher Hoover <ch@hpl.hp.com>
- * Based on fragments of previous driver by Rusell King et al.
+ * Based on fragments of previous driver by Russell King et al.
  *
  * Modified for S3C2410 from ohci-sa1111.c, ohci-omap.c and ohci-lh7a40.c
  *	by Ben Dooks, <ben@simtec.co.uk>
diff --git a/drivers/usb/host/ohci-sa1111.c b/drivers/usb/host/ohci-sa1111.c
index 99438c6..4f5e423 100644
--- a/drivers/usb/host/ohci-sa1111.c
+++ b/drivers/usb/host/ohci-sa1111.c
@@ -8,7 +8,7 @@
  * SA1111 Bus Glue
  *
  * Written by Christopher Hoover <ch@hpl.hp.com>
- * Based on fragments of previous driver by Rusell King et al.
+ * Based on fragments of previous driver by Russell King et al.
  *
  * This file is licenced under the GPL.
  */
diff --git a/include/asm-avr32/setup.h b/include/asm-avr32/setup.h
index ea3070f..ff5b7cf 100644
--- a/include/asm-avr32/setup.h
+++ b/include/asm-avr32/setup.h
@@ -2,7 +2,7 @@
  * Copyright (C) 2004-2006 Atmel Corporation
  *
  * Based on linux/include/asm-arm/setup.h
- *   Copyright (C) 1997-1999 Russel King
+ *   Copyright (C) 1997-1999 Russell King
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
-- 
1.5.6

