Return-Path: <linux-kernel-owner+w=401wt.eu-S1763712AbYESWHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763712AbYESWHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765013AbYESWFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:05:12 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:40139 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758733AbYESWFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:05:09 -0400
Date: Tue, 20 May 2008 01:03:03 +0300
From: Adrian Bunk <bunk@kernel.org>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] HID: remove CVS keywords
Message-ID: <20080519220303.GF17716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes CVS keywords that weren't updated for a long time 
from comments.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/hid/hid-debug.c       |    2 --
 drivers/hid/hid-input.c       |    2 --
 drivers/hid/usbhid/usbkbd.c   |    2 --
 drivers/hid/usbhid/usbmouse.c |    2 --
 include/linux/hid.h           |    2 --
 include/linux/hiddev.h        |    2 --
 6 files changed, 12 deletions(-)

92263a976df55d0025a2a1e224582d3478c4d8ab diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
index f88714b..47ac1a7 100644
--- a/drivers/hid/hid-debug.c
+++ b/drivers/hid/hid-debug.c
@@ -1,6 +1,4 @@
 /*
- * $Id: hid-debug.h,v 1.8 2001/09/25 09:37:57 vojtech Exp $
- *
  *  (c) 1999 Andreas Gal		<gal@cs.uni-magdeburg.de>
  *  (c) 2000-2001 Vojtech Pavlik	<vojtech@ucw.cz>
  *  (c) 2007 Jiri Kosina
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index c3eb3f1..cbf2947 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1,6 +1,4 @@
 /*
- * $Id: hid-input.c,v 1.2 2002/04/23 00:59:25 rdamazio Exp $
- *
  *  Copyright (c) 2000-2001 Vojtech Pavlik
  *  Copyright (c) 2006-2007 Jiri Kosina
  *
diff --git a/drivers/hid/usbhid/usbkbd.c b/drivers/hid/usbhid/usbkbd.c
index 5d9dbb4..3cd46d2 100644
--- a/drivers/hid/usbhid/usbkbd.c
+++ b/drivers/hid/usbhid/usbkbd.c
@@ -1,6 +1,4 @@
 /*
- * $Id: usbkbd.c,v 1.27 2001/12/27 10:37:41 vojtech Exp $
- *
  *  Copyright (c) 1999-2001 Vojtech Pavlik
  *
  *  USB HIDBP Keyboard support
diff --git a/drivers/hid/usbhid/usbmouse.c b/drivers/hid/usbhid/usbmouse.c
index df0d96d..703e9d0 100644
--- a/drivers/hid/usbhid/usbmouse.c
+++ b/drivers/hid/usbhid/usbmouse.c
@@ -1,6 +1,4 @@
 /*
- * $Id: usbmouse.c,v 1.15 2001/12/27 10:37:41 vojtech Exp $
- *
  *  Copyright (c) 1999-2001 Vojtech Pavlik
  *
  *  USB HIDBP Mouse support
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 4ce3b7a..4de7806 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -2,8 +2,6 @@
 #define __HID_H
 
 /*
- * $Id: hid.h,v 1.24 2001/12/27 10:37:41 vojtech Exp $
- *
  *  Copyright (c) 1999 Andreas Gal
  *  Copyright (c) 2000-2001 Vojtech Pavlik
  *  Copyright (c) 2006-2007 Jiri Kosina
diff --git a/include/linux/hiddev.h b/include/linux/hiddev.h
index acbdae6..a416b90 100644
--- a/include/linux/hiddev.h
+++ b/include/linux/hiddev.h
@@ -2,8 +2,6 @@
 #define _HIDDEV_H
 
 /*
- * $Id: hiddev.h,v 1.2 2001/04/26 11:26:09 vojtech Exp $
- *
  *  Copyright (c) 1999-2000 Vojtech Pavlik
  *
  *  Sponsored by SuSE

