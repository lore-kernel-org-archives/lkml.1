Return-Path: <linux-kernel-owner+w=401wt.eu-S968499AbXG3TN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968499AbXG3TN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968160AbXG3TNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:13:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42438 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967577AbXG3TNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:13:44 -0400
Subject: patch usb-clean-up-duplicate-includes-in-drivers-usb.patch added to gregkh-2.6 tree
To: jesper.juhl@gmail.com, akpm@linux-foundation.org, greg@kroah.com,
       gregkh@suse.de, linux-kernel@vger.kernel.org,
       tony.olech@elandigitalsystems.com
From: <gregkh@suse.de>
Date: Mon, 30 Jul 2007 12:13:34 -0700
In-Reply-To: <200707211702.59265.jesper.juhl@gmail.com>
Message-Id: <20070730191341.D16E7144586E@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: USB: Clean up duplicate includes in drivers/usb/

to my gregkh-2.6 tree.  Its filename is

     usb-clean-up-duplicate-includes-in-drivers-usb.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From jesper.juhl@gmail.com Sat Jul 21 08:03:57 2007
From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Sat, 21 Jul 2007 17:02:59 +0200
Subject: USB: Clean up duplicate includes in drivers/usb/
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jesper Juhl <jesper.juhl@gmail.com>, Greg Kroah-Hartman <greg@kroah.com>, gregkh@suse.de, linux-usb-users@lists.sourceforge.net, Tony Olech <tony.olech@elandigitalsystems.com>
Message-ID: <200707211702.59265.jesper.juhl@gmail.com>
Content-Disposition: inline


This patch cleans up duplicate includes in
	drivers/usb/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/u132-hcd.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/host/u132-hcd.c
+++ b/drivers/usb/host/u132-hcd.c
@@ -51,7 +51,6 @@
 #include <linux/usb.h>
 #include <linux/workqueue.h>
 #include <linux/platform_device.h>
-#include <linux/pci_ids.h>
 #include <linux/mutex.h>
 #include <asm/io.h>
 #include <asm/irq.h>


Patches currently in gregkh-2.6 which might be from jesper.juhl@gmail.com are

bad/speakup-kconfig-fix.patch
driver/howto-adjust-translation-header-of-japanese-stable_api_nonsense.txt.patch
usb/usb-clean-up-duplicate-includes-in-drivers-usb.patch
