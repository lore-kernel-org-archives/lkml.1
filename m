Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934395Ab0CKTBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 14:01:05 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:33577 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934367Ab0CKTBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 14:01:00 -0500
Date: Thu, 11 Mar 2010 20:00:47 +0100
From: pavel@ucw.cz
To: jkosina@suse.cz, linux-kernel@vger.kernel.org
Subject: trivial: remove no longer working email address
Message-ID: <20100311190047.GB27619@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


pavel@suse.cz address is no longer working email address, remove its
traces. (And yes, it means I'm looking for a job.)

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/Documentation/hwmon/hpfall.c b/Documentation/hwmon/hpfall.c
index 5ac7e42..0b48254 100644
--- a/Documentation/hwmon/hpfall.c
+++ b/Documentation/hwmon/hpfall.c
@@ -1,7 +1,7 @@
 /* Disk protection for HP machines.
  *
  * Copyright 2008 Eric Piel
- * Copyright 2009 Pavel Machek <pavel@suse.cz>
+ * Copyright 2009 Pavel Machek, suse
  *
  * GPLv2.
  */
diff --git a/Documentation/usb/CREDITS b/Documentation/usb/CREDITS
index 67c59cd..3a70d5b 100644
--- a/Documentation/usb/CREDITS
+++ b/Documentation/usb/CREDITS
@@ -13,7 +13,7 @@ difficult to maintain, add yourself with a patch if desired.
   ham <ham@unsuave.com>
   Bradley M Keryan <keryan@andrew.cmu.edu>
   Greg Kroah-Hartman <greg@kroah.com>
-  Pavel Machek <pavel@suse.cz>
+  Pavel Machek <pavel@ucw.cz>
   Paul Mackerras <paulus@cs.anu.edu.au>
   Petko Manlolov <petkan@dce.bg>
   David E. Nelson <dnelson@jump.net>
diff --git a/Documentation/zh_CN/sparse.txt b/Documentation/zh_CN/sparse.txt
index 75992a6..9446728 100644
--- a/Documentation/zh_CN/sparse.txt
+++ b/Documentation/zh_CN/sparse.txt
@@ -22,7 +22,7 @@ Documentation/sparse.txt çä¸­ćçżťčŻ
 ---------------------------------------------------------------------
 
 Copyright 2004 Linus Torvalds
-Copyright 2004 Pavel Machek <pavel@suse.cz>
+Copyright 2004 Pavel Machek, suse
 Copyright 2006 Bob Copeland <me@bobcopeland.com>
 
 ä˝żç¨ sparse ĺˇĽĺˇĺçąťĺćŁćĽ
diff --git a/arch/arm/mach-sa1100/collie.c b/arch/arm/mach-sa1100/collie.c
index 9982c5c..21a8b79 100644
--- a/arch/arm/mach-sa1100/collie.c
+++ b/arch/arm/mach-sa1100/collie.c
@@ -11,7 +11,7 @@
  * published by the Free Software Foundation.
  *
  * ChangeLog:
- *  2006 Pavel Machek <pavel@suse.cz>
+ *  2006 Pavel Machek, suse
  *  03-06-2004 John Lenz <lenz@cs.wisc.edu>
  *  06-04-2002 Chris Larson <kergoth@digitalnemesis.net>
  *  04-16-2001 Lineo Japan,Inc. ...
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index bb2d315..9bf24c6 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -2,7 +2,7 @@
  * sleep.c - x86-specific ACPI sleep support.
  *
  *  Copyright (C) 2001-2003 Patrick Mochel
- *  Copyright (C) 2001-2003 Pavel Machek <pavel@suse.cz>
+ *  Copyright (C) 2001-2003 Pavel Machek, suse
  */
 
 #include <linux/acpi.h>
diff --git a/arch/x86/kernel/acpi/wakeup_32.S b/arch/x86/kernel/acpi/wakeup_32.S
index 8ded418..b8f4213 100644
--- a/arch/x86/kernel/acpi/wakeup_32.S
+++ b/arch/x86/kernel/acpi/wakeup_32.S
@@ -3,7 +3,7 @@
 #include <asm/segment.h>
 #include <asm/page_types.h>
 
-# Copyright 2003, 2008 Pavel Machek <pavel@suse.cz>, distribute under GPLv2
+# Copyright 2003, 2008 Pavel Machek, suse, distribute under GPLv2
 
 	.code32
 	ALIGN
diff --git a/arch/x86/kernel/acpi/wakeup_64.S b/arch/x86/kernel/acpi/wakeup_64.S
index 8ea5164..e55a563 100644
--- a/arch/x86/kernel/acpi/wakeup_64.S
+++ b/arch/x86/kernel/acpi/wakeup_64.S
@@ -6,7 +6,7 @@
 #include <asm/msr.h>
 #include <asm/asm-offsets.h>
 
-# Copyright 2003 Pavel Machek <pavel@suse.cz>, distribute under GPLv2
+# Copyright 2003 Pavel Machek, suse, distribute under GPLv2
 
 .code64
 	/*
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index f125e5c..091a722 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -10,7 +10,7 @@
  *  Based on the powernow-k7.c module written by Dave Jones.
  *  (C) 2003 Dave Jones on behalf of SuSE Labs
  *  (C) 2004 Dominik Brodowski <linux@brodo.de>
- *  (C) 2004 Pavel Machek <pavel@suse.cz>
+ *  (C) 2004 Pavel Machek, suse
  *  Licensed under the terms of the GNU GPL License version 2.
  *  Based upon datasheets & sample CPUs kindly provided by AMD.
  *
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 0697ff1..459b430 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -3,7 +3,7 @@
  *
  *  Copyright (C) 1991, 1992  Linus Torvalds
  *  Copyright (C) 2000, 2001, 2002  Andi Kleen SuSE Labs
- *  Copyright (C) 2000  Pavel Machek <pavel@suse.cz>
+ *  Copyright (C) 2000  Pavel Machek, suse
  */
 
 /*
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 2d8b503..7fa8915 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -2,7 +2,7 @@
  *  linux/arch/x86_64/kernel/head.S -- start in 32bit and switch to 64bit
  *
  *  Copyright (C) 2000 Andrea Arcangeli <andrea@suse.de> SuSE
- *  Copyright (C) 2000 Pavel Machek <pavel@suse.cz>
+ *  Copyright (C) 2000 Pavel Machek, suse
  *  Copyright (C) 2000 Karsten Keil <kkeil@suse.de>
  *  Copyright (C) 2001,2002 Andi Kleen <ak@suse.de>
  *  Copyright (C) 2005 Eric Biederman <ebiederm@xmission.com>
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 5198b9b..f4f7b19 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -2,7 +2,7 @@
  *  linux/arch/x86_64/mm/init.c
  *
  *  Copyright (C) 1995  Linus Torvalds
- *  Copyright (C) 2000  Pavel Machek <pavel@suse.cz>
+ *  Copyright (C) 2000  Pavel Machek, suse
  *  Copyright (C) 2002,2003 Andi Kleen <ak@suse.de>
  */
 
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 0a979f3..82a86e6 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -4,7 +4,7 @@
  * Distribute under GPLv2
  *
  * Copyright (c) 2007 Rafael J. Wysocki <rjw@sisk.pl>
- * Copyright (c) 2002 Pavel Machek <pavel@suse.cz>
+ * Copyright (c) 2002 Pavel Machek, suse
  * Copyright (c) 2001 Patrick Mochel <mochel@osdl.org>
  */
 
diff --git a/arch/x86/power/hibernate_64.c b/arch/x86/power/hibernate_64.c
index 65fdc86..b5e42e0 100644
--- a/arch/x86/power/hibernate_64.c
+++ b/arch/x86/power/hibernate_64.c
@@ -4,7 +4,7 @@
  * Distribute under GPLv2
  *
  * Copyright (c) 2007 Rafael J. Wysocki <rjw@sisk.pl>
- * Copyright (c) 2002 Pavel Machek <pavel@suse.cz>
+ * Copyright (c) 2002 Pavel Machek, suse
  * Copyright (c) 2001 Patrick Mochel <mochel@osdl.org>
  */
 
diff --git a/arch/x86/power/hibernate_asm_64.S b/arch/x86/power/hibernate_asm_64.S
index 9356547..39be8c1 100644
--- a/arch/x86/power/hibernate_asm_64.S
+++ b/arch/x86/power/hibernate_asm_64.S
@@ -5,7 +5,7 @@
  *
  * Copyright 2007 Rafael J. Wysocki <rjw@sisk.pl>
  * Copyright 2005 Andi Kleen <ak@suse.de>
- * Copyright 2004 Pavel Machek <pavel@suse.cz>
+ * Copyright 2004 Pavel Machek, suse
  *
  * swsusp_arch_resume must not use any stack or any nonlocal variables while
  * copying pages:
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index cc923a5..5532b13 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -4,7 +4,7 @@
  * Note that you can not swap over this thing, yet. Seems to work but
  * deadlocks sometimes - you can not swap over TCP in general.
  * 
- * Copyright 1997-2000, 2008 Pavel Machek <pavel@suse.cz>
+ * Copyright 1997-2000, 2008 Pavel Machek, suse
  * Parts copyright 2001 Steven Whitehouse <steve@chygwyn.com>
  *
  * This file is released under GPLv2 or later.
diff --git a/drivers/leds/leds-input.c b/drivers/leds/leds-input.c
index 8ffb4fc..ef07e06 100644
--- a/drivers/leds/leds-input.c
+++ b/drivers/leds/leds-input.c
@@ -1,11 +1,11 @@
 /*
  * LED <-> input subsystem glue
  *
- * Copyright 2007 Pavel Machek <pavel@suse.cz>
+ * Copyright 2007 Pavel Machek, suse
  * Copyright 2007 Dmitry Torokhov
  * Copyright 2005-2006 Openedhand Ltd.
  *
- * Author: Pavel Machek <pavel@suse.cz>
+ * Author: Pavel Machek, suse
  * Based on code by: Richard Purdie <rpurdie@openedhand.com>
  * 		     
  *
diff --git a/drivers/media/video/usbvideo/vicam.c b/drivers/media/video/usbvideo/vicam.c
index 6030410..390a50f 100644
--- a/drivers/media/video/usbvideo/vicam.c
+++ b/drivers/media/video/usbvideo/vicam.c
@@ -2,7 +2,7 @@
  * USB ViCam WebCam driver
  * Copyright (c) 2002 Joe Burks (jburks@wavicle.org),
  *                    Christopher L Cheney (ccheney@cheney.cx),
- *                    Pavel Machek (pavel@suse.cz),
+ *                    Pavel Machek, suse,
  *                    John Tyner (jtyner@cs.ucr.edu),
  *                    Monroe Williams (monroe@pobox.com)
  *
diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index c4150bd..3e403cc 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -5,7 +5,7 @@
  * Copyright (C) 1997-2000  Jakub Jelinek  (jakub@redhat.com)
  * Copyright (C) 1998  Eddie C. Dost  (ecd@skynet.be)
  * Copyright (C) 2001,2002  Andi Kleen, SuSE Labs
- * Copyright (C) 2003       Pavel Machek (pavel@suse.cz)
+ * Copyright (C) 2003       Pavel Machek, suse
  * Copyright (C) 2005       Philippe De Muyter (phdm@macqel.be)
  * Copyright (C) 2008       Hans Verkuil <hverkuil@xs4all.nl>
  *
diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 067082a..1b2ed12 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -1,5 +1,5 @@
 /*
- * Copyright 2008 Pavel Machek <pavel@suse.cz>
+ * Copyright 2008 Pavel Machek, suse
  *
  * Distribute under GPLv2.
  *
diff --git a/drivers/video/backlight/locomolcd.c b/drivers/video/backlight/locomolcd.c
index 00a9591..4ca6d19 100644
--- a/drivers/video/backlight/locomolcd.c
+++ b/drivers/video/backlight/locomolcd.c
@@ -2,7 +2,7 @@
  * Backlight control code for Sharp Zaurus SL-5500
  *
  * Copyright 2005 John Lenz <lenz@cs.wisc.edu>
- * Maintainer: Pavel Machek <pavel@suse.cz> (unless John wants to :-)
+ * Maintainer: Pavel Machek <pavel@ucw.cz> (unless John wants to :-)
  * GPL v2
  *
  * This driver assumes single CPU. That's okay, because collie is
diff --git a/fs/compat.c b/fs/compat.c
index 00d90c2..e38089f 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -8,7 +8,7 @@
  *  Copyright (C) 1997-2000  Jakub Jelinek  (jakub@redhat.com)
  *  Copyright (C) 1998       Eddie C. Dost  (ecd@skynet.be)
  *  Copyright (C) 2001,2002  Andi Kleen, SuSE Labs 
- *  Copyright (C) 2003       Pavel Machek (pavel@suse.cz)
+ *  Copyright (C) 2003       Pavel Machek, suse
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License version 2 as
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 332dd00..0e4c8eb 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -4,7 +4,7 @@
  * Copyright (C) 1997-2000  Jakub Jelinek  (jakub@redhat.com)
  * Copyright (C) 1998  Eddie C. Dost  (ecd@skynet.be)
  * Copyright (C) 2001,2002  Andi Kleen, SuSE Labs 
- * Copyright (C) 2003       Pavel Machek (pavel@suse.cz)
+ * Copyright (C) 2003       Pavel Machek, suse
  *
  * These routines maintain argument size conversion between 32bit and 64bit
  * ioctls.
diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index 2eb517e..2f12811 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -6,7 +6,7 @@
  * Copyright (C) 2000-2001 VERITAS Software Corporation.
  * Copyright (C) 2002-2004 Timesys Corporation
  * Copyright (C) 2003-2004 Amit S. Kale <amitkale@linsyssoft.com>
- * Copyright (C) 2004 Pavel Machek <pavel@suse.cz>
+ * Copyright (C) 2004 Pavel Machek, suse
  * Copyright (C) 2004-2006 Tom Rini <trini@kernel.crashing.org>
  * Copyright (C) 2004-2006 LinSysSoft Technologies Pvt. Ltd.
  * Copyright (C) 2005-2008 Wind River Systems, Inc.
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index d060fed..037f6aa 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -3,7 +3,7 @@
  *
  * Copyright (c) 2003 Patrick Mochel
  * Copyright (c) 2003 Open Source Development Lab
- * Copyright (c) 2004 Pavel Machek <pavel@suse.cz>
+ * Copyright (c) 2004 Pavel Machek, suse
  * Copyright (c) 2009 Rafael J. Wysocki, Novell Inc.
  *
  * This file is released under the GPLv2.
diff --git a/kernel/power/main.c b/kernel/power/main.c
index bfc49c9..a7eb315 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -3,7 +3,7 @@
  *
  * Copyright (c) 2003 Patrick Mochel
  * Copyright (c) 2003 Open Source Development Lab
- * Copyright (c) 2007 Pavel Machek <pavel@suse.cz>
+ * Copyright (c) 2007 Pavel Machek, suse
  * 
  * This file is released under the GPLv2
  *
diff --git a/kernel/power/sleepy.c b/kernel/power/sleepy.c
index 71a6f9e..2ddc0a3 100644
--- a/kernel/power/sleepy.c
+++ b/kernel/power/sleepy.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2007 Pavel Machek <pavel@suse.cz>
+ * Copyright (c) 2007 Pavel Machek, suse
  * 
  * This file is released under the GPLv2
  *
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index d98be03..df71c72 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -3,7 +3,7 @@
  *
  * This file provides system snapshot/restore functionality for swsusp.
  *
- * Copyright (C) 1998-2005 Pavel Machek <pavel@suse.cz>
+ * Copyright (C) 1998-2005 Pavel Machek, suse
  * Copyright (C) 2006 Rafael J. Wysocki <rjw@sisk.pl>
  *
  * This file is released under the GPLv2.
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 09b2b0a..b98400b 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -4,7 +4,7 @@
  * This file provides functions for reading the suspend image from
  * and writing it to a swap partition.
  *
- * Copyright (C) 1998,2001-2005 Pavel Machek <pavel@suse.cz>
+ * Copyright (C) 1998,2001-2005 Pavel Machek, suse
  * Copyright (C) 2006 Rafael J. Wysocki <rjw@sisk.pl>
  *
  * This file is released under the GPLv2.
