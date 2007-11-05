Return-Path: <linux-kernel-owner+w=401wt.eu-S1756965AbXKEPL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965AbXKEPL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 10:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbXKEPLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 10:11:23 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:59568 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbXKEPLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 10:11:22 -0500
Date: Mon, 5 Nov 2007 16:11:02 +0100
From: Andre Haupt <andre@bitwigglers.org>
To: linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, Andre Haupt <andre@bitwigglers.org>
Subject: [patch 1/1] omap2: remove double include
Message-ID: <20071105151101.GA30549@ahaupt-debian-vm.localdomain>
References: <20071105150921.414137198@ahaupt-debian-vm.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=omap2_fix_includes
User-Agent: quilt/0.45-1
X-Provags-ID: V01U2FsdGVkX18+D8irx0SKfH45FhWrCankOMEf1i4JoUvnXDb
 ZgsQfLDMv3TsmT5bKmCwB9kut74KPWMV+Tuo169rFHaTTbK3PZ
 pVQ2LoyjJw5rrHQVanAAvtLdnlzd/C5DCqqblgwV8g=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Haupt <andre@bitwigglers.org>
Signed-off-by: Andre Haupt <andre@bitwigglers.org>

---
 arch/arm/mach-omap2/board-apollon.c |    1 -
 1 file changed, 1 deletion(-)

Index: linus/arch/arm/mach-omap2/board-apollon.c
===================================================================
--- linus.orig/arch/arm/mach-omap2/board-apollon.c	2007-11-05 16:06:55.000000000 +0100
+++ linus/arch/arm/mach-omap2/board-apollon.c	2007-11-05 16:07:13.000000000 +0100
@@ -26,7 +26,6 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/leds.h>
-#include <linux/irq.h>
 
 #include <asm/hardware.h>
 #include <asm/mach-types.h>

--
