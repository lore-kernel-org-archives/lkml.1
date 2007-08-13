Return-Path: <linux-kernel-owner+w=401wt.eu-S966955AbXHML3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966955AbXHML3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967255AbXHMGic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:38:32 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2192 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966881AbXHMGia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:38:30 -0400
Date: Sun, 12 Aug 2007 23:38:13 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, jkosina@suse.cz,
       akpm@linux-foundation.org
Subject: [PATCH] [496/2many] MAINTAINERS - USB HID/HIDBP DRIVERS (USB
 KEYBOARDS, MICE, REMOTE CONTROLS, ...)
Message-ID: <46bffc55.PFZbCJDLM7vdarZe%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index ae24def..270952c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4696,6 +4696,8 @@ M:	jkosina@suse.cz
 L:	linux-usb-devel@lists.sourceforge.net
 T:	git kernel.org:/pub/scm/linux/kernel/git/jikos/hid.git
 S:	Maintained
+F:	Documentation/usb/hiddev.txt
+F:	drivers/hid/usbhid/
 
 USB HUB DRIVER
 P:	Johannes Erdfelt
