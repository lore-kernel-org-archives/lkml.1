Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868AbYI0Lgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbYI0Lgz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 07:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbYI0Lgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 07:36:47 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:37334 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbYI0Lgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 07:36:46 -0400
Date: Sat, 27 Sep 2008 13:36:36 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, alsa-devel@alsa-project.org
Subject: [PATCH] Drop Vladimir Barinov's e-mail address
Message-ID: <20080927133636.02a58b0a@hyperion.delvare>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every e-mail I've sent to Vladimir Barinov bounced back to me, so I
guess he no longer works at MontaVista.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 arch/arm/plat-omap/include/mach/mtd-xip.h |    2 +-
 drivers/usb/host/ehci-ixp4xx.c            |    2 +-
 sound/soc/codecs/tlv320aic3x.c            |    2 +-
 sound/soc/codecs/tlv320aic3x.h            |    2 +-
 sound/soc/davinci/davinci-evm.c           |    2 +-
 sound/soc/davinci/davinci-i2s.c           |    2 +-
 sound/soc/davinci/davinci-i2s.h           |    2 +-
 sound/soc/davinci/davinci-pcm.c           |    2 +-
 sound/soc/davinci/davinci-pcm.h           |    2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

--- linux-2.6.27-rc7.orig/arch/arm/plat-omap/include/mach/mtd-xip.h	2008-09-27 12:53:06.000000000 +0200
+++ linux-2.6.27-rc7/arch/arm/plat-omap/include/mach/mtd-xip.h	2008-09-27 12:56:40.000000000 +0200
@@ -3,7 +3,7 @@
  *
  * Do not include this file directly. It's included from linux/mtd/xip.h
  *
- * Author: Vladimir Barinov <vbarinov@ru.mvista.com>
+ * Author: Vladimir Barinov
  *
  * (c) 2005 MontaVista Software, Inc.  This file is licensed under the
  * terms of the GNU General Public License version 2.  This program is
--- linux-2.6.27-rc7.orig/drivers/usb/host/ehci-ixp4xx.c	2008-09-27 12:53:06.000000000 +0200
+++ linux-2.6.27-rc7/drivers/usb/host/ehci-ixp4xx.c	2008-09-27 12:56:30.000000000 +0200
@@ -1,7 +1,7 @@
 /*
  * IXP4XX EHCI Host Controller Driver
  *
- * Author: Vladimir Barinov <vbarinov@ru.mvista.com>
+ * Author: Vladimir Barinov
  *
  * Based on "ehci-fsl.c" by Randy Vinson <rvinson@mvista.com>
  *
--- linux-2.6.27-rc7.orig/sound/soc/codecs/tlv320aic3x.c	2008-09-27 12:53:06.000000000 +0200
+++ linux-2.6.27-rc7/sound/soc/codecs/tlv320aic3x.c	2008-09-27 12:56:23.000000000 +0200
@@ -1,7 +1,7 @@
 /*
  * ALSA SoC TLV320AIC3X codec driver
  *
- * Author:      Vladimir Barinov, <vbarinov@ru.mvista.com>
+ * Author:      Vladimir Barinov
  * Copyright:   (C) 2007 MontaVista Software, Inc., <source@mvista.com>
  *
  * Based on sound/soc/codecs/wm8753.c by Liam Girdwood
--- linux-2.6.27-rc7.orig/sound/soc/codecs/tlv320aic3x.h	2008-09-27 12:53:06.000000000 +0200
+++ linux-2.6.27-rc7/sound/soc/codecs/tlv320aic3x.h	2008-09-27 12:56:19.000000000 +0200
@@ -1,7 +1,7 @@
 /*
  * ALSA SoC TLV320AIC3X codec driver
  *
- * Author:      Vladimir Barinov, <vbarinov@ru.mvista.com>
+ * Author:      Vladimir Barinov
  * Copyright:   (C) 2007 MontaVista Software, Inc., <source@mvista.com>
  *
  * This program is free software; you can redistribute it and/or modify
--- linux-2.6.27-rc7.orig/sound/soc/davinci/davinci-evm.c	2008-09-27 12:53:06.000000000 +0200
+++ linux-2.6.27-rc7/sound/soc/davinci/davinci-evm.c	2008-09-27 12:56:14.000000000 +0200
@@ -1,7 +1,7 @@
 /*
  * ASoC driver for TI DAVINCI EVM platform
  *
- * Author:      Vladimir Barinov, <vbarinov@ru.mvista.com>
+ * Author:      Vladimir Barinov
  * Copyright:   (C) 2007 MontaVista Software, Inc., <source@mvista.com>
  *
  * This program is free software; you can redistribute it and/or modify
--- linux-2.6.27-rc7.orig/sound/soc/davinci/davinci-i2s.c	2008-09-27 12:53:06.000000000 +0200
+++ linux-2.6.27-rc7/sound/soc/davinci/davinci-i2s.c	2008-09-27 12:56:11.000000000 +0200
@@ -1,7 +1,7 @@
 /*
  * ALSA SoC I2S (McBSP) Audio Layer for TI DAVINCI processor
  *
- * Author:      Vladimir Barinov, <vbarinov@ru.mvista.com>
+ * Author:      Vladimir Barinov
  * Copyright:   (C) 2007 MontaVista Software, Inc., <source@mvista.com>
  *
  * This program is free software; you can redistribute it and/or modify
--- linux-2.6.27-rc7.orig/sound/soc/davinci/davinci-i2s.h	2008-09-27 12:53:06.000000000 +0200
+++ linux-2.6.27-rc7/sound/soc/davinci/davinci-i2s.h	2008-09-27 12:56:07.000000000 +0200
@@ -1,7 +1,7 @@
 /*
  * ALSA SoC I2S (McBSP) Audio Layer for TI DAVINCI processor
  *
- * Author:      Vladimir Barinov, <vbarinov@ru.mvista.com>
+ * Author:      Vladimir Barinov
  * Copyright:   (C) 2007 MontaVista Software, Inc., <source@mvista.com>
  *
  * This program is free software; you can redistribute it and/or modify
--- linux-2.6.27-rc7.orig/sound/soc/davinci/davinci-pcm.c	2008-09-27 12:53:06.000000000 +0200
+++ linux-2.6.27-rc7/sound/soc/davinci/davinci-pcm.c	2008-09-27 12:56:03.000000000 +0200
@@ -1,7 +1,7 @@
 /*
  * ALSA PCM interface for the TI DAVINCI processor
  *
- * Author:      Vladimir Barinov, <vbarinov@ru.mvista.com>
+ * Author:      Vladimir Barinov
  * Copyright:   (C) 2007 MontaVista Software, Inc., <source@mvista.com>
  *
  * This program is free software; you can redistribute it and/or modify
--- linux-2.6.27-rc7.orig/sound/soc/davinci/davinci-pcm.h	2008-09-27 12:53:06.000000000 +0200
+++ linux-2.6.27-rc7/sound/soc/davinci/davinci-pcm.h	2008-09-27 12:55:59.000000000 +0200
@@ -1,7 +1,7 @@
 /*
  * ALSA PCM interface for the TI DAVINCI processor
  *
- * Author:      Vladimir Barinov, <vbarinov@ru.mvista.com>
+ * Author:      Vladimir Barinov
  * Copyright:   (C) 2007 MontaVista Software, Inc., <source@mvista.com>
  *
  * This program is free software; you can redistribute it and/or modify


-- 
Jean Delvare
