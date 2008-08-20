Return-Path: <linux-kernel-owner+w=401wt.eu-S1757594AbYHTVEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbYHTVEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 17:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756045AbYHTVEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 17:04:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:53221 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755946AbYHTVE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 17:04:29 -0400
Subject: patch uio-uio_pdrv-fix-license-specification.patch added to gregkh-2.6 tree
To: Uwe.Kleine-Koenig@digi.com, gregkh@suse.de, greg@kroah.com,
       hjk@linutronix.de, linux-kernel@vger.kernel.org, magnus.damm@gmail.com
From: <gregkh@suse.de>
Date: Wed, 20 Aug 2008 13:56:10 -0700
In-Reply-To: <1215767437-20583-3-git-send-email-Uwe.Kleine-Koenig@digi.com>
Message-ID: <12192657693767@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: UIO: uio_pdrv: fix license specification

to my gregkh-2.6 tree.  Its filename is

    uio-uio_pdrv-fix-license-specification.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From Uwe.Kleine-Koenig@digi.com  Wed Aug 20 13:45:09 2008
From: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
Date: Fri, 11 Jul 2008 11:10:37 +0200
Subject: UIO: uio_pdrv: fix license specification
To: Greg KH <greg@kroah.com>, "Hans J. Koch" <hjk@linutronix.de>
Cc: Magnus Damm <magnus.damm@gmail.com>, <linux-kernel@vger.kernel.org>
Message-ID: <1215767437-20583-3-git-send-email-Uwe.Kleine-Koenig@digi.com>


Thanks to Magnus Damm for pointing that out.

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Acked-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/uio/uio_pdrv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/uio/uio_pdrv.c
+++ b/drivers/uio/uio_pdrv.c
@@ -116,5 +116,5 @@ module_exit(uio_pdrv_exit);
 
 MODULE_AUTHOR("Uwe Kleine-Koenig");
 MODULE_DESCRIPTION("Userspace I/O platform driver");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("platform:" DRIVER_NAME);


Patches currently in gregkh-2.6 which might be from Uwe.Kleine-Koenig@digi.com are

driver-core.current/uio-uio_pdrv-fix-license-specification.patch
driver-core.current/uio-uio_pdrv-fix-memory-leak.patch
driver-core.current/uio-generic-irq-handling-for-some-uio-platform-devices.patch
