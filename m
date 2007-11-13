Return-Path: <linux-kernel-owner+w=401wt.eu-S1759432AbXKMQSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432AbXKMQSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 11:18:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758972AbXKMQRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 11:17:44 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:57698 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758864AbXKMQRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 11:17:43 -0500
Date: Tue, 13 Nov 2007 17:17:28 +0100
From: andre@bitwigglers.org
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andre Haupt <andre@bitwigglers.org>
Subject: [patch 2/3] bf54x: remove duplicate include
Message-ID: <20071113161728.GC19470@ahaupt-debian-vm.localdomain>
References: <20071113161613.902793126@ahaupt-debian-vm.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="input-bf54x-remove-duplicate-include.patch"
User-Agent: quilt/0.45-1
X-Provags-ID: V01U2FsdGVkX19s1JNJsJuz/SAzHrr8qb+gOponJeW9Jf9B0qi
 4coWMB2AQT0V0KPHt/8RIO+JHdIm8z03qR0FCkKM6Iu9MiX+bj
 BAzApME/ZIlDuNkQTaX0s981aXcGF0FKCPkC535d5w=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Haupt <andre@bitwigglers.org>
Signed-off-by: Andre Haupt <andre@bitwigglers.org>

---
 drivers/input/keyboard/bf54x-keys.c |    1 -
 1 file changed, 1 deletion(-)

Index: linus/drivers/input/keyboard/bf54x-keys.c
===================================================================
--- linus.orig/drivers/input/keyboard/bf54x-keys.c	2007-11-13 16:31:02.000000000 +0100
+++ linus/drivers/input/keyboard/bf54x-keys.c	2007-11-13 16:31:30.000000000 +0100
@@ -42,7 +42,6 @@
 #include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/input.h>
-#include <linux/irq.h>

 #include <asm/portmux.h>
 #include <asm/mach/bf54x_keys.h>

--
