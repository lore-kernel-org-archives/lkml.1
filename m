Return-Path: <linux-kernel-owner+w=401wt.eu-S1759653AbXKMQSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759653AbXKMQSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 11:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759400AbXKMQSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 11:18:00 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:50408 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759378AbXKMQR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 11:17:59 -0500
Date: Tue, 13 Nov 2007 17:17:36 +0100
From: andre@bitwigglers.org
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andre Haupt <andre@bitwigglers.org>
Subject: [patch 3/3] jonada720: remove duplicate include
Message-ID: <20071113161736.GD19470@ahaupt-debian-vm.localdomain>
References: <20071113161613.902793126@ahaupt-debian-vm.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="input-jonada720-remove-duplicate-include.patch"
User-Agent: quilt/0.45-1
X-Provags-ID: V01U2FsdGVkX1/EH56Adbsk2JQcyhFc4PXWvruzTvsUta8vA/2
 D5iQLuXMGkJSdoyuuFecD1nxEkn8nS4Q9yNCPUtIpH14G/p5S/
 devce6Jcg3xiOJrwRCLYOF2364hQrVoC+0R6XUjHVg=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Haupt <andre@bitwigglers.org>
Signed-off-by: Andre Haupt <andre@bitwigglers.org>

---
 drivers/input/keyboard/jornada720_kbd.c |    1 -
 1 file changed, 1 deletion(-)

Index: linus/drivers/input/keyboard/jornada720_kbd.c
===================================================================
--- linus.orig/drivers/input/keyboard/jornada720_kbd.c	2007-11-13 16:33:24.000000000 +0100
+++ linus/drivers/input/keyboard/jornada720_kbd.c	2007-11-13 16:33:41.000000000 +0100
@@ -17,7 +17,6 @@
  */
 #include <linux/device.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/input.h>

--
