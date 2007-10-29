Return-Path: <linux-kernel-owner+w=401wt.eu-S1751923AbXJ2WuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbXJ2WuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 18:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbXJ2Wtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 18:49:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947AbXJ2Wtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 18:49:50 -0400
Date: Mon, 29 Oct 2007 18:49:36 -0400
From: Dave Jones <davej@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Remove more bogus filenames in comments.
Message-ID: <20071029224936.GA31031@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/include/asm-x86/acpi_32.h b/include/asm-x86/acpi_32.h
index 723493e..4f8730e 100644
--- a/include/asm-x86/acpi_32.h
+++ b/include/asm-x86/acpi_32.h
@@ -1,9 +1,7 @@
 /*
- *  asm-i386/acpi.h
- *
  *  Copyright (C) 2001 Paul Diefenbaugh <paul.s.diefenbaugh@intel.com>
  *  Copyright (C) 2001 Patrick Mochel <mochel@osdl.org>
-  *
+ *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  *
  *  This program is free software; you can redistribute it and/or modify
diff --git a/include/asm-x86/acpi_64.h b/include/asm-x86/acpi_64.h
index 9817335..58114ed 100644
--- a/include/asm-x86/acpi_64.h
+++ b/include/asm-x86/acpi_64.h
@@ -1,9 +1,7 @@
 /*
- *  asm-x86_64/acpi.h
- *
  *  Copyright (C) 2001 Paul Diefenbaugh <paul.s.diefenbaugh@intel.com>
  *  Copyright (C) 2001 Patrick Mochel <mochel@osdl.org>
-  *
+ *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  *
  *  This program is free software; you can redistribute it and/or modify
diff --git a/include/asm-x86/checksum_64.h b/include/asm-x86/checksum_64.h
index 419fe88..e5f7999 100644
--- a/include/asm-x86/checksum_64.h
+++ b/include/asm-x86/checksum_64.h
@@ -4,7 +4,7 @@
 /* 
  * Checksums for x86-64 
  * Copyright 2002 by Andi Kleen, SuSE Labs 
- * with some code from asm-i386/checksum.h
+ * with some code from asm-x86/checksum.h
  */ 
 
 #include <linux/compiler.h>
diff --git a/include/asm-x86/i387_32.h b/include/asm-x86/i387_32.h
index cdd1e24..9ac2502 100644
--- a/include/asm-x86/i387_32.h
+++ b/include/asm-x86/i387_32.h
@@ -1,6 +1,4 @@
 /*
- * include/asm-i386/i387.h
- *
  * Copyright (C) 1994 Linus Torvalds
  *
  * Pentium III FXSR, SSE support
diff --git a/include/asm-x86/i387_64.h b/include/asm-x86/i387_64.h
index 0217b74..1d59222 100644
--- a/include/asm-x86/i387_64.h
+++ b/include/asm-x86/i387_64.h
@@ -1,6 +1,4 @@
 /*
- * include/asm-x86_64/i387.h
- *
  * Copyright (C) 1994 Linus Torvalds
  *
  * Pentium III FXSR, SSE support
diff --git a/include/asm-x86/ia32_unistd.h b/include/asm-x86/ia32_unistd.h
index 5b52ce5..61cea9e 100644
--- a/include/asm-x86/ia32_unistd.h
+++ b/include/asm-x86/ia32_unistd.h
@@ -5,7 +5,7 @@
  * This file contains the system call numbers of the ia32 port,
  * this is for the kernel only.
  * Only add syscalls here where some part of the kernel needs to know
- * the number. This should be otherwise in sync with asm-i386/unistd.h. -AK
+ * the number. This should be otherwise in sync with asm-x86/unistd_32.h. -AK
  */
 
 #define __NR_ia32_restart_syscall 0
diff --git a/include/asm-x86/ide.h b/include/asm-x86/ide.h
index 42130ad..c2552d8 100644
--- a/include/asm-x86/ide.h
+++ b/include/asm-x86/ide.h
@@ -1,6 +1,4 @@
 /*
- *  linux/include/asm-i386/ide.h
- *
  *  Copyright (C) 1994-1996  Linus Torvalds & authors
  */
 
diff --git a/include/asm-x86/irqflags_32.h b/include/asm-x86/irqflags_32.h
index d058b04..d8500f4 100644
--- a/include/asm-x86/irqflags_32.h
+++ b/include/asm-x86/irqflags_32.h
@@ -1,6 +1,4 @@
 /*
- * include/asm-i386/irqflags.h
- *
  * IRQ flags handling
  *
  * This file gets included from lowlevel asm headers too, to provide
diff --git a/include/asm-x86/irqflags_64.h b/include/asm-x86/irqflags_64.h
index 5341ea1..857d9eb 100644
--- a/include/asm-x86/irqflags_64.h
+++ b/include/asm-x86/irqflags_64.h
@@ -1,6 +1,4 @@
 /*
- * include/asm-x86_64/irqflags.h
- *
  * IRQ flags handling
  *
  * This file gets included from lowlevel asm headers too, to provide
diff --git a/include/asm-x86/kprobes_32.h b/include/asm-x86/kprobes_32.h
index b772d5b..ad0777d 100644
--- a/include/asm-x86/kprobes_32.h
+++ b/include/asm-x86/kprobes_32.h
@@ -2,7 +2,6 @@
 #define _ASM_KPROBES_H
 /*
  *  Kernel Probes (KProbes)
- *  include/asm-i386/kprobes.h
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/include/asm-x86/kprobes_64.h b/include/asm-x86/kprobes_64.h
index 53f4d85..067642d 100644
--- a/include/asm-x86/kprobes_64.h
+++ b/include/asm-x86/kprobes_64.h
@@ -2,7 +2,6 @@
 #define _ASM_KPROBES_H
 /*
  *  Kernel Probes (KProbes)
- *  include/asm-x86_64/kprobes.h
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/include/asm-x86/mach-default/apm.h b/include/asm-x86/mach-default/apm.h
index 1f730b8..989f34c 100644
--- a/include/asm-x86/mach-default/apm.h
+++ b/include/asm-x86/mach-default/apm.h
@@ -1,6 +1,4 @@
 /*
- *  include/asm-i386/mach-default/apm.h
- *
  *  Machine specific APM BIOS functions for generic.
  *  Split out from apm.c by Osamu Tomita <tomita@cinet.co.jp>
  */
diff --git a/include/asm-x86/mach-default/mach_time.h b/include/asm-x86/mach-default/mach_time.h
index 31eb5de..060b3bb 100644
--- a/include/asm-x86/mach-default/mach_time.h
+++ b/include/asm-x86/mach-default/mach_time.h
@@ -1,6 +1,4 @@
 /*
- *  include/asm-i386/mach-default/mach_time.h
- *
  *  Machine specific set RTC function for generic.
  *  Split out from time.c by Osamu Tomita <tomita@cinet.co.jp>
  */
diff --git a/include/asm-x86/mach-default/mach_timer.h b/include/asm-x86/mach-default/mach_timer.h
index 807992f..4b76e53 100644
--- a/include/asm-x86/mach-default/mach_timer.h
+++ b/include/asm-x86/mach-default/mach_timer.h
@@ -1,6 +1,4 @@
 /*
- *  include/asm-i386/mach-default/mach_timer.h
- *
  *  Machine specific calibrate_tsc() for generic.
  *  Split out from timer_tsc.c by Osamu Tomita <tomita@cinet.co.jp>
  */
diff --git a/include/asm-x86/mach-default/mach_traps.h b/include/asm-x86/mach-default/mach_traps.h
index 625438b..2fe7705 100644
--- a/include/asm-x86/mach-default/mach_traps.h
+++ b/include/asm-x86/mach-default/mach_traps.h
@@ -1,6 +1,4 @@
 /*
- *  include/asm-i386/mach-default/mach_traps.h
- *
  *  Machine specific NMI handling for generic.
  *  Split out from traps.c by Osamu Tomita <tomita@cinet.co.jp>
  */
diff --git a/include/asm-x86/nmi_32.h b/include/asm-x86/nmi_32.h
index 70a958a..7206c7e 100644
--- a/include/asm-x86/nmi_32.h
+++ b/include/asm-x86/nmi_32.h
@@ -1,6 +1,3 @@
-/*
- *  linux/include/asm-i386/nmi.h
- */
 #ifndef ASM_NMI_H
 #define ASM_NMI_H
 
diff --git a/include/asm-x86/nmi_64.h b/include/asm-x86/nmi_64.h
index 65b6acf..92f36fb 100644
--- a/include/asm-x86/nmi_64.h
+++ b/include/asm-x86/nmi_64.h
@@ -1,6 +1,3 @@
-/*
- *  linux/include/asm-i386/nmi.h
- */
 #ifndef ASM_NMI_H
 #define ASM_NMI_H
 
diff --git a/include/asm-x86/processor_32.h b/include/asm-x86/processor_32.h
index 13976b0..1724791 100644
--- a/include/asm-x86/processor_32.h
+++ b/include/asm-x86/processor_32.h
@@ -1,6 +1,4 @@
 /*
- * include/asm-i386/processor.h
- *
  * Copyright (C) 1994 Linus Torvalds
  */
 
diff --git a/include/asm-x86/processor_64.h b/include/asm-x86/processor_64.h
index e4f1997..493d7ff 100644
--- a/include/asm-x86/processor_64.h
+++ b/include/asm-x86/processor_64.h
@@ -1,6 +1,4 @@
 /*
- * include/asm-x86_64/processor.h
- *
  * Copyright (C) 1994 Linus Torvalds
  */
 
diff --git a/include/asm-x86/rio.h b/include/asm-x86/rio.h
index c7350f6..97cdcc9 100644
--- a/include/asm-x86/rio.h
+++ b/include/asm-x86/rio.h
@@ -1,6 +1,6 @@
 /*
- * Derived from include/asm-i386/mach-summit/mach_mpparse.h
- *          and include/asm-i386/mach-default/bios_ebda.h
+ * Derived from include/asm-x86/mach-summit/mach_mpparse.h
+ *          and include/asm-x86/mach-default/bios_ebda.h
  *
  * Author: Laurent Vivier <Laurent.Vivier@bull.net>
  */
diff --git a/include/asm-x86/rwsem.h b/include/asm-x86/rwsem.h
index 041906f..a7e7e14 100644
--- a/include/asm-x86/rwsem.h
+++ b/include/asm-x86/rwsem.h
@@ -2,7 +2,7 @@
  *
  * Written by David Howells (dhowells@redhat.com).
  *
- * Derived from asm-i386/semaphore.h
+ * Derived from asm-x86/semaphore.h
  *
  *
  * The MSW of the count is the negated number of active writers and waiting
diff --git a/include/asm-x86/topology_32.h b/include/asm-x86/topology_32.h
index 9040f5a..fdca80a 100644
--- a/include/asm-x86/topology_32.h
+++ b/include/asm-x86/topology_32.h
@@ -1,6 +1,4 @@
 /*
- * linux/include/asm-i386/topology.h
- *
  * Written by: Matthew Dobson, IBM Corporation
  *
  * Copyright (C) 2002, IBM Corp.
diff --git a/include/asm-x86/xor_32.h b/include/asm-x86/xor_32.h
index 23c86ce..a41ef1b 100644
--- a/include/asm-x86/xor_32.h
+++ b/include/asm-x86/xor_32.h
@@ -1,6 +1,4 @@
 /*
- * include/asm-i386/xor.h
- *
  * Optimized RAID-5 checksumming functions for MMX and SSE.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/include/asm-x86/xor_64.h b/include/asm-x86/xor_64.h
index f942fcc..1eee7fc 100644
--- a/include/asm-x86/xor_64.h
+++ b/include/asm-x86/xor_64.h
@@ -1,6 +1,4 @@
 /*
- * include/asm-x86_64/xor.h
- *
  * Optimized RAID-5 checksumming functions for MMX and SSE.
  *
  * This program is free software; you can redistribute it and/or modify

-- 
http://www.codemonkey.org.uk
