Return-Path: <linux-kernel-owner+w=401wt.eu-S1764260AbYESV6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764260AbYESV6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 17:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755202AbYESV6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 17:58:33 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:44713 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764315AbYESV6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 17:58:25 -0400
Date: Tue, 20 May 2008 00:56:18 +0300
From: Adrian Bunk <bunk@kernel.org>
To: wli@holomorphy.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] sparc: remove CVS keywords
Message-ID: <20080519215618.GM17716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the CVS keywords that weren't updated for a long time 
from comments.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/sparc/Kconfig              |    1 -
 arch/sparc/boot/Makefile        |    1 -
 arch/sparc/boot/btfixupprep.c   |    2 +-
 arch/sparc/boot/piggyback.c     |    2 +-
 arch/sparc/kernel/ebus.c        |    2 +-
 arch/sparc/kernel/etrap.S       |    2 +-
 arch/sparc/kernel/head.S        |    2 +-
 arch/sparc/kernel/idprom.c      |    2 +-
 arch/sparc/kernel/ioport.c      |    2 +-
 arch/sparc/kernel/irq.c         |    2 +-
 arch/sparc/kernel/muldiv.c      |    2 +-
 arch/sparc/kernel/rtrap.S       |    2 +-
 arch/sparc/kernel/setup.c       |    2 +-
 arch/sparc/kernel/sparc_ksyms.c |    2 +-
 arch/sparc/kernel/sun4d_irq.c   |    2 +-
 arch/sparc/kernel/trampoline.S  |    2 +-
 arch/sparc/kernel/traps.c       |    2 +-
 arch/sparc/kernel/unaligned.c   |    2 +-
 arch/sparc/kernel/wof.S         |    2 +-
 arch/sparc/kernel/wuf.S         |    2 +-
 arch/sparc/lib/Makefile         |    1 -
 arch/sparc/lib/ashldi3.S        |    2 +-
 arch/sparc/lib/ashrdi3.S        |    2 +-
 arch/sparc/lib/blockops.S       |    2 +-
 arch/sparc/lib/locks.S          |    2 +-
 arch/sparc/lib/lshrdi3.S        |    1 -
 arch/sparc/lib/memscan.S        |    2 +-
 arch/sparc/lib/mul.S            |    2 +-
 arch/sparc/lib/rem.S            |    2 +-
 arch/sparc/lib/rwsem.S          |    2 +-
 arch/sparc/lib/sdiv.S           |    2 +-
 arch/sparc/lib/strncmp.S        |    2 +-
 arch/sparc/lib/udiv.S           |    2 +-
 arch/sparc/lib/umul.S           |    2 +-
 arch/sparc/lib/urem.S           |    2 +-
 arch/sparc/math-emu/ashldi3.S   |    2 +-
 arch/sparc/mm/Makefile          |    1 -
 arch/sparc/mm/fault.c           |    2 +-
 arch/sparc/mm/generic.c         |    2 +-
 arch/sparc/mm/hypersparc.S      |    2 +-
 arch/sparc/mm/init.c            |    2 +-
 arch/sparc/mm/io-unit.c         |    2 +-
 arch/sparc/mm/loadmmu.c         |    2 +-
 arch/sparc/mm/nosrmmu.c         |    2 +-
 arch/sparc/mm/nosun4c.c         |    2 +-
 arch/sparc/mm/swift.S           |    2 +-
 arch/sparc/mm/tsunami.S         |    2 +-
 arch/sparc/mm/viking.S          |    2 +-
 arch/sparc/prom/Makefile        |    1 -
 arch/sparc/prom/bootstr.c       |    2 +-
 arch/sparc/prom/console.c       |    2 +-
 arch/sparc/prom/devmap.c        |    2 +-
 arch/sparc/prom/devops.c        |    2 +-
 arch/sparc/prom/init.c          |    2 +-
 arch/sparc/prom/misc.c          |    2 +-
 arch/sparc/prom/mp.c            |    2 +-
 arch/sparc/prom/palloc.c        |    2 +-
 arch/sparc/prom/ranges.c        |    2 +-
 arch/sparc/prom/segment.c       |    2 +-
 arch/sparc/prom/tree.c          |    2 +-
 include/asm-sparc/asi.h         |    1 -
 include/asm-sparc/auxio.h       |    2 +-
 include/asm-sparc/bitops.h      |    2 +-
 include/asm-sparc/btfixup.h     |    2 +-
 include/asm-sparc/checksum.h    |    1 -
 include/asm-sparc/clock.h       |    2 +-
 include/asm-sparc/contregs.h    |    1 -
 include/asm-sparc/cypress.h     |    2 +-
 include/asm-sparc/delay.h       |    2 +-
 include/asm-sparc/ebus.h        |    2 +-
 include/asm-sparc/ecc.h         |    2 +-
 include/asm-sparc/eeprom.h      |    2 +-
 include/asm-sparc/elf.h         |    1 -
 include/asm-sparc/fcntl.h       |    1 -
 include/asm-sparc/head.h        |    1 -
 include/asm-sparc/idprom.h      |    2 +-
 include/asm-sparc/io.h          |    3 ---
 include/asm-sparc/ioctl.h       |    1 -
 include/asm-sparc/kdebug.h      |    2 +-
 include/asm-sparc/machines.h    |    2 +-
 include/asm-sparc/mbus.h        |    2 +-
 include/asm-sparc/memreg.h      |    1 -
 include/asm-sparc/mman.h        |    1 -
 include/asm-sparc/mostek.h      |    2 +-
 include/asm-sparc/mpmbox.h      |    2 +-
 include/asm-sparc/msi.h         |    2 +-
 include/asm-sparc/mxcc.h        |    2 +-
 include/asm-sparc/namei.h       |    2 +-
 include/asm-sparc/obio.h        |    2 +-
 include/asm-sparc/openprom.h    |    1 -
 include/asm-sparc/oplib.h       |    2 +-
 include/asm-sparc/page.h        |    2 +-
 include/asm-sparc/param.h       |    1 -
 include/asm-sparc/pbm.h         |    2 +-
 include/asm-sparc/pcic.h        |    2 +-
 include/asm-sparc/pgalloc.h     |    1 -
 include/asm-sparc/pgtable.h     |    1 -
 include/asm-sparc/pgtsrmmu.h    |    2 +-
 include/asm-sparc/pgtsun4.h     |    2 +-
 include/asm-sparc/pgtsun4c.h    |    2 +-
 include/asm-sparc/psr.h         |    2 +-
 include/asm-sparc/ptrace.h      |    1 -
 include/asm-sparc/resource.h    |    2 +-
 include/asm-sparc/ross.h        |    2 +-
 include/asm-sparc/rtc.h         |    3 +--
 include/asm-sparc/sbi.h         |    2 +-
 include/asm-sparc/sbus.h        |    2 +-
 include/asm-sparc/scatterlist.h |    1 -
 include/asm-sparc/shmparam.h    |    1 -
 include/asm-sparc/sigcontext.h  |    1 -
 include/asm-sparc/siginfo.h     |    4 ----
 include/asm-sparc/signal.h      |    1 -
 include/asm-sparc/smpprim.h     |    2 +-
 include/asm-sparc/socket.h      |    1 -
 include/asm-sparc/stat.h        |    1 -
 include/asm-sparc/statfs.h      |    1 -
 include/asm-sparc/string.h      |    2 +-
 include/asm-sparc/sun4paddr.h   |    2 +-
 include/asm-sparc/sunbpp.h      |    2 +-
 include/asm-sparc/sysen.h       |    2 +-
 include/asm-sparc/termios.h     |    1 -
 include/asm-sparc/timer.h       |    2 +-
 include/asm-sparc/traps.h       |    2 +-
 include/asm-sparc/tsunami.h     |    2 +-
 include/asm-sparc/turbosparc.h  |    2 +-
 include/asm-sparc/types.h       |    1 -
 include/asm-sparc/uaccess.h     |    2 +-
 include/asm-sparc/vac-ops.h     |    1 -
 include/asm-sparc/vaddrs.h      |    1 -
 include/asm-sparc/viking.h      |    2 +-
 include/asm-sparc/winmacro.h    |    2 +-
 131 files changed, 98 insertions(+), 137 deletions(-)

5d24fdfc58d8923393ad640ce7242b53107e501c diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index d211fdb..789724e 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -1,4 +1,3 @@
-# $Id: config.in,v 1.113 2002/01/24 22:14:44 davem Exp $
 # For a description of the syntax of this configuration file,
 # see Documentation/kbuild/kconfig-language.txt.
 #
diff --git a/arch/sparc/boot/Makefile b/arch/sparc/boot/Makefile
index b365084..22d331e 100644
--- a/arch/sparc/boot/Makefile
+++ b/arch/sparc/boot/Makefile
@@ -1,4 +1,3 @@
-# $Id: Makefile,v 1.10 2000/02/23 08:17:46 jj Exp $
 # Makefile for the Sparc boot stuff.
 #
 # Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/arch/sparc/boot/btfixupprep.c b/arch/sparc/boot/btfixupprep.c
index dc7b054..52a4208 100644
--- a/arch/sparc/boot/btfixupprep.c
+++ b/arch/sparc/boot/btfixupprep.c
@@ -1,4 +1,4 @@
-/* $Id: btfixupprep.c,v 1.6 2001/08/22 15:27:47 davem Exp $
+/*
    Simple utility to prepare vmlinux image for sparc.
    Resolves all BTFIXUP uses and settings and creates
    a special .s object to link to the image.
diff --git a/arch/sparc/boot/piggyback.c b/arch/sparc/boot/piggyback.c
index 6962cc6..c9f500c 100644
--- a/arch/sparc/boot/piggyback.c
+++ b/arch/sparc/boot/piggyback.c
@@ -1,4 +1,4 @@
-/* $Id: piggyback.c,v 1.4 2000/12/05 00:48:57 anton Exp $
+/*
    Simple utility to make a single-image install kernel with initial ramdisk
    for Sparc tftpbooting without need to set up nfs.
 
diff --git a/arch/sparc/kernel/ebus.c b/arch/sparc/kernel/ebus.c
index 96344ff..92c6fc0 100644
--- a/arch/sparc/kernel/ebus.c
+++ b/arch/sparc/kernel/ebus.c
@@ -1,4 +1,4 @@
-/* $Id: ebus.c,v 1.20 2002/01/05 01:13:43 davem Exp $
+/*
  * ebus.c: PCI to EBus bridge device.
  *
  * Copyright (C) 1997  Eddie C. Dost  (ecd@skynet.be)
diff --git a/arch/sparc/kernel/etrap.S b/arch/sparc/kernel/etrap.S
index a8b35be..f37d961 100644
--- a/arch/sparc/kernel/etrap.S
+++ b/arch/sparc/kernel/etrap.S
@@ -1,4 +1,4 @@
-/* $Id: etrap.S,v 1.31 2000/01/08 16:38:18 anton Exp $
+/*
  * etrap.S: Sparc trap window preparation for entry into the
  *          Linux kernel.
  *
diff --git a/arch/sparc/kernel/head.S b/arch/sparc/kernel/head.S
index 8bec05f..3bfd608 100644
--- a/arch/sparc/kernel/head.S
+++ b/arch/sparc/kernel/head.S
@@ -1,4 +1,4 @@
-/* $Id: head.S,v 1.105 2001/08/12 09:08:56 davem Exp $
+/*
  * head.S: The initial boot code for the Sparc port of Linux.
  *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/arch/sparc/kernel/idprom.c b/arch/sparc/kernel/idprom.c
index 3a5bad5..7220562 100644
--- a/arch/sparc/kernel/idprom.c
+++ b/arch/sparc/kernel/idprom.c
@@ -1,4 +1,4 @@
-/* $Id: idprom.c,v 1.24 1999/08/31 06:54:20 davem Exp $
+/*
  * idprom.c: Routines to load the idprom into kernel addresses and
  *           interpret the data contained within.
  *
diff --git a/arch/sparc/kernel/ioport.c b/arch/sparc/kernel/ioport.c
index ad0ede2..7b17522 100644
--- a/arch/sparc/kernel/ioport.c
+++ b/arch/sparc/kernel/ioport.c
@@ -1,4 +1,4 @@
-/* $Id: ioport.c,v 1.45 2001/10/30 04:54:21 davem Exp $
+/*
  * ioport.c:  Simple io mapping allocator.
  *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/arch/sparc/kernel/irq.c b/arch/sparc/kernel/irq.c
index 01a6756..087390b 100644
--- a/arch/sparc/kernel/irq.c
+++ b/arch/sparc/kernel/irq.c
@@ -1,4 +1,4 @@
-/*  $Id: irq.c,v 1.114 2001/12/11 04:55:51 davem Exp $
+/*
  *  arch/sparc/kernel/irq.c:  Interrupt request handling routines. On the
  *                            Sparc the IRQs are basically 'cast in stone'
  *                            and you are supposed to probe the prom's device
diff --git a/arch/sparc/kernel/muldiv.c b/arch/sparc/kernel/muldiv.c
index 37b9a49..e352239 100644
--- a/arch/sparc/kernel/muldiv.c
+++ b/arch/sparc/kernel/muldiv.c
@@ -1,4 +1,4 @@
-/* $Id: muldiv.c,v 1.5 1997/12/15 20:07:20 ecd Exp $
+/*
  * muldiv.c: Hardware multiply/division illegal instruction trap
  *		for sun4c/sun4 (which do not have those instructions)
  *
diff --git a/arch/sparc/kernel/rtrap.S b/arch/sparc/kernel/rtrap.S
index ab818cd..ce30082 100644
--- a/arch/sparc/kernel/rtrap.S
+++ b/arch/sparc/kernel/rtrap.S
@@ -1,4 +1,4 @@
-/* $Id: rtrap.S,v 1.58 2002/01/31 03:30:05 davem Exp $
+/*
  * rtrap.S: Return from Sparc trap low-level code.
  *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/arch/sparc/kernel/setup.c b/arch/sparc/kernel/setup.c
index 8a55c4f..a0ea0bc 100644
--- a/arch/sparc/kernel/setup.c
+++ b/arch/sparc/kernel/setup.c
@@ -1,4 +1,4 @@
-/*  $Id: setup.c,v 1.126 2001/11/13 00:49:27 davem Exp $
+/*
  *  linux/arch/sparc/kernel/setup.c
  *
  *  Copyright (C) 1995  David S. Miller (davem@caip.rutgers.edu)
diff --git a/arch/sparc/kernel/sparc_ksyms.c b/arch/sparc/kernel/sparc_ksyms.c
index aa8ee06..b23cea5 100644
--- a/arch/sparc/kernel/sparc_ksyms.c
+++ b/arch/sparc/kernel/sparc_ksyms.c
@@ -1,4 +1,4 @@
-/* $Id: sparc_ksyms.c,v 1.107 2001/07/17 16:17:33 anton Exp $
+/*
  * arch/sparc/kernel/ksyms.c: Sparc specific ksyms support.
  *
  * Copyright (C) 1996 David S. Miller (davem@caip.rutgers.edu)
diff --git a/arch/sparc/kernel/sun4d_irq.c b/arch/sparc/kernel/sun4d_irq.c
index e0efab2..8ac5661 100644
--- a/arch/sparc/kernel/sun4d_irq.c
+++ b/arch/sparc/kernel/sun4d_irq.c
@@ -1,4 +1,4 @@
-/*  $Id: sun4d_irq.c,v 1.29 2001/12/11 04:55:51 davem Exp $
+/*
  *  arch/sparc/kernel/sun4d_irq.c:
  *			SS1000/SC2000 interrupt handling.
  *
diff --git a/arch/sparc/kernel/trampoline.S b/arch/sparc/kernel/trampoline.S
index 2dcdaa1..356c56a 100644
--- a/arch/sparc/kernel/trampoline.S
+++ b/arch/sparc/kernel/trampoline.S
@@ -1,4 +1,4 @@
-/* $Id: trampoline.S,v 1.14 2002/01/11 08:45:38 davem Exp $
+/*
  * trampoline.S: SMP cpu boot-up trampoline code.
  *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/arch/sparc/kernel/traps.c b/arch/sparc/kernel/traps.c
index d404e79..978e9d8 100644
--- a/arch/sparc/kernel/traps.c
+++ b/arch/sparc/kernel/traps.c
@@ -1,4 +1,4 @@
-/* $Id: traps.c,v 1.64 2000/09/03 15:00:49 anton Exp $
+/*
  * arch/sparc/kernel/traps.c
  *
  * Copyright 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/arch/sparc/kernel/unaligned.c b/arch/sparc/kernel/unaligned.c
index 33857be..c2a28c5 100644
--- a/arch/sparc/kernel/unaligned.c
+++ b/arch/sparc/kernel/unaligned.c
@@ -1,4 +1,4 @@
-/* $Id: unaligned.c,v 1.23 2001/12/21 00:54:31 davem Exp $
+/*
  * unaligned.c: Unaligned load/store trap handling with special
  *              cases for the kernel to do them more quickly.
  *
diff --git a/arch/sparc/kernel/wof.S b/arch/sparc/kernel/wof.S
index 083b121..4bce38d 100644
--- a/arch/sparc/kernel/wof.S
+++ b/arch/sparc/kernel/wof.S
@@ -1,4 +1,4 @@
-/* $Id: wof.S,v 1.40 2000/01/08 16:38:18 anton Exp $
+/*
  * wof.S: Sparc window overflow handler.
  *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/arch/sparc/kernel/wuf.S b/arch/sparc/kernel/wuf.S
index d1a266b..82e5145 100644
--- a/arch/sparc/kernel/wuf.S
+++ b/arch/sparc/kernel/wuf.S
@@ -1,4 +1,4 @@
-/* $Id: wuf.S,v 1.39 2000/01/08 16:38:18 anton Exp $
+/*
  * wuf.S: Window underflow trap handler for the Sparc.
  *
  * Copyright (C) 1995 David S. Miller
diff --git a/arch/sparc/lib/Makefile b/arch/sparc/lib/Makefile
index 76effdb..6e303e1 100644
--- a/arch/sparc/lib/Makefile
+++ b/arch/sparc/lib/Makefile
@@ -1,4 +1,3 @@
-# $Id: Makefile,v 1.35 2000/12/15 00:41:18 davem Exp $
 # Makefile for Sparc library files..
 #
 
diff --git a/arch/sparc/lib/ashldi3.S b/arch/sparc/lib/ashldi3.S
index 52418a0..17912e6 100644
--- a/arch/sparc/lib/ashldi3.S
+++ b/arch/sparc/lib/ashldi3.S
@@ -1,4 +1,4 @@
-/* $Id: ashldi3.S,v 1.2 1999/11/19 04:11:46 davem Exp $
+/*
  * ashldi3.S:	GCC emits these for certain drivers playing
  *		with long longs.
  *
diff --git a/arch/sparc/lib/ashrdi3.S b/arch/sparc/lib/ashrdi3.S
index 2848237..85398fd 100644
--- a/arch/sparc/lib/ashrdi3.S
+++ b/arch/sparc/lib/ashrdi3.S
@@ -1,4 +1,4 @@
-/* $Id: ashrdi3.S,v 1.4 1999/11/19 04:11:49 davem Exp $
+/*
  * ashrdi3.S:	The filesystem code creates all kinds of references to
  *              this little routine on the sparc with gcc.
  *
diff --git a/arch/sparc/lib/blockops.S b/arch/sparc/lib/blockops.S
index a7c7ffa..804be87 100644
--- a/arch/sparc/lib/blockops.S
+++ b/arch/sparc/lib/blockops.S
@@ -1,4 +1,4 @@
-/* $Id: blockops.S,v 1.8 1998/01/30 10:58:44 jj Exp $
+/*
  * blockops.S: Common block zero optimized routines.
  *
  * Copyright (C) 1996 David S. Miller (davem@caip.rutgers.edu)
diff --git a/arch/sparc/lib/locks.S b/arch/sparc/lib/locks.S
index b1df55c..64f53f2 100644
--- a/arch/sparc/lib/locks.S
+++ b/arch/sparc/lib/locks.S
@@ -1,4 +1,4 @@
-/* $Id: locks.S,v 1.16 2000/02/26 11:02:47 anton Exp $
+/*
  * locks.S: SMP low-level lock primitives on Sparc.
  *
  * Copyright (C) 1996 David S. Miller (davem@caip.rutgers.edu)
diff --git a/arch/sparc/lib/lshrdi3.S b/arch/sparc/lib/lshrdi3.S
index 35abf5b..47a1354 100644
--- a/arch/sparc/lib/lshrdi3.S
+++ b/arch/sparc/lib/lshrdi3.S
@@ -1,4 +1,3 @@
-/* $Id: lshrdi3.S,v 1.1 1999/03/21 06:37:45 davem Exp $ */
 
 	.globl	__lshrdi3
 __lshrdi3:
diff --git a/arch/sparc/lib/memscan.S b/arch/sparc/lib/memscan.S
index 28e78ff..4ff1657 100644
--- a/arch/sparc/lib/memscan.S
+++ b/arch/sparc/lib/memscan.S
@@ -1,4 +1,4 @@
-/* $Id: memscan.S,v 1.4 1996/09/08 02:01:20 davem Exp $
+/*
  * memscan.S: Optimized memscan for the Sparc.
  *
  * Copyright (C) 1996 David S. Miller (davem@caip.rutgers.edu)
diff --git a/arch/sparc/lib/mul.S b/arch/sparc/lib/mul.S
index da69356..c45470d 100644
--- a/arch/sparc/lib/mul.S
+++ b/arch/sparc/lib/mul.S
@@ -1,4 +1,4 @@
-/* $Id: mul.S,v 1.4 1996/09/30 02:22:32 davem Exp $
+/*
  * mul.S:       This routine was taken from glibc-1.09 and is covered
  *              by the GNU Library General Public License Version 2.
  */
diff --git a/arch/sparc/lib/rem.S b/arch/sparc/lib/rem.S
index bf015a9..42fb862 100644
--- a/arch/sparc/lib/rem.S
+++ b/arch/sparc/lib/rem.S
@@ -1,4 +1,4 @@
-/* $Id: rem.S,v 1.7 1996/09/30 02:22:34 davem Exp $
+/*
  * rem.S:       This routine was taken from glibc-1.09 and is covered
  *              by the GNU Library General Public License Version 2.
  */
diff --git a/arch/sparc/lib/rwsem.S b/arch/sparc/lib/rwsem.S
index f406b1f..9675268 100644
--- a/arch/sparc/lib/rwsem.S
+++ b/arch/sparc/lib/rwsem.S
@@ -1,4 +1,4 @@
-/* $Id: rwsem.S,v 1.5 2000/05/09 17:40:13 davem Exp $
+/*
  * Assembly part of rw semaphores.
  *
  * Copyright (C) 1999 Jakub Jelinek (jakub@redhat.com)
diff --git a/arch/sparc/lib/sdiv.S b/arch/sparc/lib/sdiv.S
index af94516..f0a0d4e 100644
--- a/arch/sparc/lib/sdiv.S
+++ b/arch/sparc/lib/sdiv.S
@@ -1,4 +1,4 @@
-/* $Id: sdiv.S,v 1.6 1996/10/02 17:37:00 davem Exp $
+/*
  * sdiv.S:      This routine was taken from glibc-1.09 and is covered
  *              by the GNU Library General Public License Version 2.
  */
diff --git a/arch/sparc/lib/strncmp.S b/arch/sparc/lib/strncmp.S
index 6156268..494ec66 100644
--- a/arch/sparc/lib/strncmp.S
+++ b/arch/sparc/lib/strncmp.S
@@ -1,4 +1,4 @@
-/* $Id: strncmp.S,v 1.2 1996/09/09 02:47:20 davem Exp $
+/*
  * strncmp.S: Hand optimized Sparc assembly of GCC output from GNU libc
  *            generic strncmp routine.
  */
diff --git a/arch/sparc/lib/udiv.S b/arch/sparc/lib/udiv.S
index 169e01d..2101405 100644
--- a/arch/sparc/lib/udiv.S
+++ b/arch/sparc/lib/udiv.S
@@ -1,4 +1,4 @@
-/* $Id: udiv.S,v 1.4 1996/09/30 02:22:38 davem Exp $
+/*
  * udiv.S:      This routine was taken from glibc-1.09 and is covered
  *              by the GNU Library General Public License Version 2.
  */
diff --git a/arch/sparc/lib/umul.S b/arch/sparc/lib/umul.S
index f0e5b20..1f36ae6 100644
--- a/arch/sparc/lib/umul.S
+++ b/arch/sparc/lib/umul.S
@@ -1,4 +1,4 @@
-/* $Id: umul.S,v 1.4 1996/09/30 02:22:39 davem Exp $
+/*
  * umul.S:      This routine was taken from glibc-1.09 and is covered
  *              by the GNU Library General Public License Version 2.
  */
diff --git a/arch/sparc/lib/urem.S b/arch/sparc/lib/urem.S
index 6b92bdc..77123eb 100644
--- a/arch/sparc/lib/urem.S
+++ b/arch/sparc/lib/urem.S
@@ -1,4 +1,4 @@
-/* $Id: urem.S,v 1.4 1996/09/30 02:22:42 davem Exp $
+/*
  * urem.S:      This routine was taken from glibc-1.09 and is covered
  *              by the GNU Library General Public License Version 2.
  */
diff --git a/arch/sparc/math-emu/ashldi3.S b/arch/sparc/math-emu/ashldi3.S
index eab1d09..7230ff5 100644
--- a/arch/sparc/math-emu/ashldi3.S
+++ b/arch/sparc/math-emu/ashldi3.S
@@ -1,4 +1,4 @@
-/* $Id: ashldi3.S,v 1.1 1998/04/06 16:09:28 jj Exp $
+/*
  * ashldi3.S:	Math-emu code creates all kinds of references to
  *              this little routine on the sparc with gcc.
  *
diff --git a/arch/sparc/mm/Makefile b/arch/sparc/mm/Makefile
index 16eeba4..109c8b2 100644
--- a/arch/sparc/mm/Makefile
+++ b/arch/sparc/mm/Makefile
@@ -1,4 +1,3 @@
-# $Id: Makefile,v 1.38 2000/12/15 00:41:22 davem Exp $
 # Makefile for the linux Sparc-specific parts of the memory manager.
 #
 
diff --git a/arch/sparc/mm/fault.c b/arch/sparc/mm/fault.c
index abd5079..0a3cd8f 100644
--- a/arch/sparc/mm/fault.c
+++ b/arch/sparc/mm/fault.c
@@ -1,4 +1,4 @@
-/* $Id: fault.c,v 1.122 2001/11/17 07:19:26 davem Exp $
+/*
  * fault.c:  Page fault handlers for the Sparc.
  *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/arch/sparc/mm/generic.c b/arch/sparc/mm/generic.c
index 1ef7fa0..a289261 100644
--- a/arch/sparc/mm/generic.c
+++ b/arch/sparc/mm/generic.c
@@ -1,4 +1,4 @@
-/* $Id: generic.c,v 1.14 2001/12/21 04:56:15 davem Exp $
+/*
  * generic.c: Generic Sparc mm routines that are not dependent upon
  *            MMU type but are Sparc specific.
  *
diff --git a/arch/sparc/mm/hypersparc.S b/arch/sparc/mm/hypersparc.S
index d29cc24..44aad32 100644
--- a/arch/sparc/mm/hypersparc.S
+++ b/arch/sparc/mm/hypersparc.S
@@ -1,4 +1,4 @@
-/* $Id: hypersparc.S,v 1.18 2001/12/21 04:56:15 davem Exp $
+/*
  * hypersparc.S: High speed Hypersparc mmu/cache operations.
  *
  * Copyright (C) 1997 David S. Miller (davem@caip.rutgers.edu)
diff --git a/arch/sparc/mm/init.c b/arch/sparc/mm/init.c
index b89837a..7794ecb 100644
--- a/arch/sparc/mm/init.c
+++ b/arch/sparc/mm/init.c
@@ -1,4 +1,4 @@
-/*  $Id: init.c,v 1.103 2001/11/19 19:03:08 davem Exp $
+/*
  *  linux/arch/sparc/mm/init.c
  *
  *  Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/arch/sparc/mm/io-unit.c b/arch/sparc/mm/io-unit.c
index b86dfce..f167835 100644
--- a/arch/sparc/mm/io-unit.c
+++ b/arch/sparc/mm/io-unit.c
@@ -1,4 +1,4 @@
-/* $Id: io-unit.c,v 1.24 2001/12/17 07:05:09 davem Exp $
+/*
  * io-unit.c:  IO-UNIT specific routines for memory management.
  *
  * Copyright (C) 1997,1998 Jakub Jelinek    (jj@sunsite.mff.cuni.cz)
diff --git a/arch/sparc/mm/loadmmu.c b/arch/sparc/mm/loadmmu.c
index 2d9cd65..652be05 100644
--- a/arch/sparc/mm/loadmmu.c
+++ b/arch/sparc/mm/loadmmu.c
@@ -1,4 +1,4 @@
-/* $Id: loadmmu.c,v 1.56 2000/02/08 20:24:21 davem Exp $
+/*
  * loadmmu.c:  This code loads up all the mm function pointers once the
  *             machine type has been determined.  It also sets the static
  *             mmu values such as PAGE_NONE, etc.
diff --git a/arch/sparc/mm/nosrmmu.c b/arch/sparc/mm/nosrmmu.c
index 9e21565..3701f70 100644
--- a/arch/sparc/mm/nosrmmu.c
+++ b/arch/sparc/mm/nosrmmu.c
@@ -1,4 +1,4 @@
-/* $Id: nosrmmu.c,v 1.5 1999/11/19 04:11:54 davem Exp $
+/*
  * nosrmmu.c: This file is a bunch of dummies for sun4 compiles, 
  *         so that it does not need srmmu and avoid ifdefs.
  *
diff --git a/arch/sparc/mm/nosun4c.c b/arch/sparc/mm/nosun4c.c
index ea2e210..196263f 100644
--- a/arch/sparc/mm/nosun4c.c
+++ b/arch/sparc/mm/nosun4c.c
@@ -1,4 +1,4 @@
-/* $Id: nosun4c.c,v 1.3 2000/02/14 04:52:36 jj Exp $
+/*
  * nosun4c.c: This file is a bunch of dummies for SMP compiles, 
  *         so that it does not need sun4c and avoid ifdefs.
  *
diff --git a/arch/sparc/mm/swift.S b/arch/sparc/mm/swift.S
index 9f4cd39..c801c39 100644
--- a/arch/sparc/mm/swift.S
+++ b/arch/sparc/mm/swift.S
@@ -1,4 +1,4 @@
-/* $Id: swift.S,v 1.9 2002/01/08 11:11:59 davem Exp $
+/*
  * swift.S: MicroSparc-II mmu/cache operations.
  *
  * Copyright (C) 1999 David S. Miller (davem@redhat.com)
diff --git a/arch/sparc/mm/tsunami.S b/arch/sparc/mm/tsunami.S
index 4988e6a..db0d6de 100644
--- a/arch/sparc/mm/tsunami.S
+++ b/arch/sparc/mm/tsunami.S
@@ -1,4 +1,4 @@
-/* $Id: tsunami.S,v 1.7 2001/12/21 04:56:15 davem Exp $
+/*
  * tsunami.S: High speed MicroSparc-I mmu/cache operations.
  *
  * Copyright (C) 1997 David S. Miller (davem@caip.rutgers.edu)
diff --git a/arch/sparc/mm/viking.S b/arch/sparc/mm/viking.S
index 754c622..6dfcc13 100644
--- a/arch/sparc/mm/viking.S
+++ b/arch/sparc/mm/viking.S
@@ -1,4 +1,4 @@
-/* $Id: viking.S,v 1.19 2001/12/21 04:56:15 davem Exp $
+/*
  * viking.S: High speed Viking cache/mmu operations
  *
  * Copyright (C) 1997  Eddie C. Dost  (ecd@skynet.be)
diff --git a/arch/sparc/prom/Makefile b/arch/sparc/prom/Makefile
index 2b217ee..7f5eacf 100644
--- a/arch/sparc/prom/Makefile
+++ b/arch/sparc/prom/Makefile
@@ -1,4 +1,3 @@
-# $Id: Makefile,v 1.8 2000/12/15 00:41:22 davem Exp $
 # Makefile for the Sun Boot PROM interface library under
 # Linux.
 #
diff --git a/arch/sparc/prom/bootstr.c b/arch/sparc/prom/bootstr.c
index cfdeac2..5a35c76 100644
--- a/arch/sparc/prom/bootstr.c
+++ b/arch/sparc/prom/bootstr.c
@@ -1,4 +1,4 @@
-/* $Id: bootstr.c,v 1.20 2000/02/08 20:24:23 davem Exp $
+/*
  * bootstr.c:  Boot string/argument acquisition from the PROM.
  *
  * Copyright(C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/arch/sparc/prom/console.c b/arch/sparc/prom/console.c
index 2a007a7..790057a 100644
--- a/arch/sparc/prom/console.c
+++ b/arch/sparc/prom/console.c
@@ -1,4 +1,4 @@
-/* $Id: console.c,v 1.25 2001/10/30 04:54:22 davem Exp $
+/*
  * console.c: Routines that deal with sending and receiving IO
  *            to/from the current console device using the PROM.
  *
diff --git a/arch/sparc/prom/devmap.c b/arch/sparc/prom/devmap.c
index eb12073..1e51791 100644
--- a/arch/sparc/prom/devmap.c
+++ b/arch/sparc/prom/devmap.c
@@ -1,4 +1,4 @@
-/* $Id: devmap.c,v 1.7 2000/08/26 02:38:03 anton Exp $
+/*
  * promdevmap.c:  Map device/IO areas to virtual addresses.
  *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/arch/sparc/prom/devops.c b/arch/sparc/prom/devops.c
index 61919b5..9f1a95c 100644
--- a/arch/sparc/prom/devops.c
+++ b/arch/sparc/prom/devops.c
@@ -1,4 +1,4 @@
-/* $Id: devops.c,v 1.13 2000/08/26 02:38:03 anton Exp $
+/*
  * devops.c:  Device operations using the PROM.
  *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/arch/sparc/prom/init.c b/arch/sparc/prom/init.c
index 2fa3a47..729f870 100644
--- a/arch/sparc/prom/init.c
+++ b/arch/sparc/prom/init.c
@@ -1,4 +1,4 @@
-/* $Id: init.c,v 1.14 2000/01/29 01:09:12 anton Exp $
+/*
  * init.c:  Initialize internal variables used by the PROM
  *          library functions.
  *
diff --git a/arch/sparc/prom/misc.c b/arch/sparc/prom/misc.c
index d9fb3af..49b5057 100644
--- a/arch/sparc/prom/misc.c
+++ b/arch/sparc/prom/misc.c
@@ -1,4 +1,4 @@
-/* $Id: misc.c,v 1.18 2000/08/26 02:38:03 anton Exp $
+/*
  * misc.c:  Miscellaneous prom functions that don't belong
  *          anywhere else.
  *
diff --git a/arch/sparc/prom/mp.c b/arch/sparc/prom/mp.c
index 92fe373..4c4dc79 100644
--- a/arch/sparc/prom/mp.c
+++ b/arch/sparc/prom/mp.c
@@ -1,4 +1,4 @@
-/* $Id: mp.c,v 1.12 2000/08/26 02:38:03 anton Exp $
+/*
  * mp.c:  OpenBoot Prom Multiprocessor support routines.  Don't call
  *        these on a UP or else you will halt and catch fire. ;)
  *
diff --git a/arch/sparc/prom/palloc.c b/arch/sparc/prom/palloc.c
index 84ce8bc..20be339 100644
--- a/arch/sparc/prom/palloc.c
+++ b/arch/sparc/prom/palloc.c
@@ -1,4 +1,4 @@
-/* $Id: palloc.c,v 1.4 1996/04/25 06:09:48 davem Exp $
+/*
  * palloc.c:  Memory allocation from the Sun PROM.
  *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/arch/sparc/prom/ranges.c b/arch/sparc/prom/ranges.c
index a292032..f9b7def 100644
--- a/arch/sparc/prom/ranges.c
+++ b/arch/sparc/prom/ranges.c
@@ -1,4 +1,4 @@
-/* $Id: ranges.c,v 1.15 2001/12/19 00:29:51 davem Exp $
+/*
  * ranges.c: Handle ranges in newer proms for obio/sbus.
  *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/arch/sparc/prom/segment.c b/arch/sparc/prom/segment.c
index 09d6460..04fd03a 100644
--- a/arch/sparc/prom/segment.c
+++ b/arch/sparc/prom/segment.c
@@ -1,4 +1,4 @@
-/* $Id: segment.c,v 1.7 2000/08/26 02:38:03 anton Exp $
+/*
  * segment.c:  Prom routine to map segments in other contexts before
  *             a standalone is completely mapped.  This is for sun4 and
  *             sun4c architectures only.
diff --git a/arch/sparc/prom/tree.c b/arch/sparc/prom/tree.c
index 5ec2465..f228fe0 100644
--- a/arch/sparc/prom/tree.c
+++ b/arch/sparc/prom/tree.c
@@ -1,4 +1,4 @@
-/* $Id: tree.c,v 1.26 2000/08/26 02:38:03 anton Exp $
+/*
  * tree.c: Basic device tree traversal/scanning for the Linux
  *         prom library.
  *
diff --git a/include/asm-sparc/asi.h b/include/asm-sparc/asi.h
index 58c3754..158f9b0 100644
--- a/include/asm-sparc/asi.h
+++ b/include/asm-sparc/asi.h
@@ -1,4 +1,3 @@
-/* $Id: asi.h,v 1.18 1998/03/09 14:04:46 jj Exp $ */
 #ifndef _SPARC_ASI_H
 #define _SPARC_ASI_H
 
diff --git a/include/asm-sparc/auxio.h b/include/asm-sparc/auxio.h
index ee83aef..e552b8d 100644
--- a/include/asm-sparc/auxio.h
+++ b/include/asm-sparc/auxio.h
@@ -1,4 +1,4 @@
-/* $Id: auxio.h,v 1.18 1997/11/07 15:01:45 jj Exp $
+/*
  * auxio.h:  Definitions and code for the Auxiliary I/O register.
  *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/include/asm-sparc/bitops.h b/include/asm-sparc/bitops.h
index cb3cefa..68b98a7 100644
--- a/include/asm-sparc/bitops.h
+++ b/include/asm-sparc/bitops.h
@@ -1,4 +1,4 @@
-/* $Id: bitops.h,v 1.67 2001/11/19 18:36:34 davem Exp $
+/*
  * bitops.h: Bit string operations on the Sparc.
  *
  * Copyright 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/include/asm-sparc/btfixup.h b/include/asm-sparc/btfixup.h
index c2868d0..08277e6 100644
--- a/include/asm-sparc/btfixup.h
+++ b/include/asm-sparc/btfixup.h
@@ -1,4 +1,4 @@
-/* $Id: btfixup.h,v 1.4 1998/03/09 14:04:43 jj Exp $
+/*
  *  asm-sparc/btfixup.h:    Macros for boot time linking.
  *
  *  Copyright (C) 1998 Jakub Jelinek (jj@sunsite.mff.cuni.cz)
diff --git a/include/asm-sparc/checksum.h b/include/asm-sparc/checksum.h
index 34518ea..d044ddb 100644
--- a/include/asm-sparc/checksum.h
+++ b/include/asm-sparc/checksum.h
@@ -1,4 +1,3 @@
-/* $Id: checksum.h,v 1.33 2002/02/01 22:01:05 davem Exp $ */
 #ifndef __SPARC_CHECKSUM_H
 #define __SPARC_CHECKSUM_H
 
diff --git a/include/asm-sparc/clock.h b/include/asm-sparc/clock.h
index e708e6b..2cf99da 100644
--- a/include/asm-sparc/clock.h
+++ b/include/asm-sparc/clock.h
@@ -1,4 +1,4 @@
-/* $Id: clock.h,v 1.3 1995/11/25 02:31:25 davem Exp $
+/*
  * clock.h:  Definitions for clock operations on the Sparc.
  *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/include/asm-sparc/contregs.h b/include/asm-sparc/contregs.h
index 0e05afe..48fa8a4 100644
--- a/include/asm-sparc/contregs.h
+++ b/include/asm-sparc/contregs.h
@@ -1,4 +1,3 @@
-/* $Id: contregs.h,v 1.8 2000/12/28 22:49:11 davem Exp $ */
 #ifndef _SPARC_CONTREGS_H
 #define _SPARC_CONTREGS_H
 
diff --git a/include/asm-sparc/cypress.h b/include/asm-sparc/cypress.h
index 9959953..95e9772 100644
--- a/include/asm-sparc/cypress.h
+++ b/include/asm-sparc/cypress.h
@@ -1,4 +1,4 @@
-/* $Id: cypress.h,v 1.6 1996/08/29 09:48:09 davem Exp $
+/*
  * cypress.h: Cypress module specific definitions and defines.
  *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/include/asm-sparc/delay.h b/include/asm-sparc/delay.h
index 48aa70e..bc9aba2 100644
--- a/include/asm-sparc/delay.h
+++ b/include/asm-sparc/delay.h
@@ -1,4 +1,4 @@
-/* $Id: delay.h,v 1.11 2001/01/01 01:46:15 davem Exp $
+/*
  * delay.h: Linux delay routines on the Sparc.
  *
  * Copyright (C) 1994 David S. Miller (davem@caip.rutgers.edu).
diff --git a/include/asm-sparc/ebus.h b/include/asm-sparc/ebus.h
index 5465288..491f85d 100644
--- a/include/asm-sparc/ebus.h
+++ b/include/asm-sparc/ebus.h
@@ -1,4 +1,4 @@
-/* $Id: ebus.h,v 1.2 1999/09/11 23:05:55 zaitcev Exp $
+/*
  * ebus.h: PCI to Ebus pseudo driver software state.
  *
  * Copyright (C) 1997 Eddie C. Dost (ecd@skynet.be) 
diff --git a/include/asm-sparc/ecc.h b/include/asm-sparc/ecc.h
index 8e27cec..ccb84b6 100644
--- a/include/asm-sparc/ecc.h
+++ b/include/asm-sparc/ecc.h
@@ -1,4 +1,4 @@
-/* $Id: ecc.h,v 1.3 1996/04/25 06:12:57 davem Exp $
+/*
  * ecc.h: Definitions and defines for the external cache/memory
  *        controller on the sun4m.
  *
diff --git a/include/asm-sparc/eeprom.h b/include/asm-sparc/eeprom.h
index a8ff749..e17beec 100644
--- a/include/asm-sparc/eeprom.h
+++ b/include/asm-sparc/eeprom.h
@@ -1,4 +1,4 @@
-/* $Id: eeprom.h,v 1.3 1995/11/25 02:31:38 davem Exp $
+/*
  * eeprom.h:  Definitions for the Sun eeprom.
  *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/include/asm-sparc/elf.h b/include/asm-sparc/elf.h
index d2516ee..d043f80 100644
--- a/include/asm-sparc/elf.h
+++ b/include/asm-sparc/elf.h
@@ -1,4 +1,3 @@
-/* $Id: elf.h,v 1.22 2000/07/12 01:27:08 davem Exp $ */
 #ifndef __ASMSPARC_ELF_H
 #define __ASMSPARC_ELF_H
 
diff --git a/include/asm-sparc/fcntl.h b/include/asm-sparc/fcntl.h
index 5ec5463..07bd2d8 100644
--- a/include/asm-sparc/fcntl.h
+++ b/include/asm-sparc/fcntl.h
@@ -1,4 +1,3 @@
-/* $Id: fcntl.h,v 1.16 2001/09/20 00:35:33 davem Exp $ */
 #ifndef _SPARC_FCNTL_H
 #define _SPARC_FCNTL_H
 
diff --git a/include/asm-sparc/head.h b/include/asm-sparc/head.h
index e6532c3..7c35491 100644
--- a/include/asm-sparc/head.h
+++ b/include/asm-sparc/head.h
@@ -1,4 +1,3 @@
-/* $Id: head.h,v 1.39 2000/05/26 22:18:45 ecd Exp $ */
 #ifndef __SPARC_HEAD_H
 #define __SPARC_HEAD_H
 
diff --git a/include/asm-sparc/idprom.h b/include/asm-sparc/idprom.h
index 59083ed..41adb41 100644
--- a/include/asm-sparc/idprom.h
+++ b/include/asm-sparc/idprom.h
@@ -1,4 +1,4 @@
-/* $Id: idprom.h,v 1.6 1996/08/04 10:35:07 ecd Exp $
+/*
  * idprom.h: Macros and defines for idprom routines
  *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/include/asm-sparc/io.h b/include/asm-sparc/io.h
index 243bf8e..3a3e7bd 100644
--- a/include/asm-sparc/io.h
+++ b/include/asm-sparc/io.h
@@ -1,6 +1,3 @@
-/*
- * $Id: io.h,v 1.30 2001/12/21 01:23:21 davem Exp $
- */
 #ifndef __SPARC_IO_H
 #define __SPARC_IO_H
 
diff --git a/include/asm-sparc/ioctl.h b/include/asm-sparc/ioctl.h
index e6fc4de..7d6bd51 100644
--- a/include/asm-sparc/ioctl.h
+++ b/include/asm-sparc/ioctl.h
@@ -1,4 +1,3 @@
-/* $Id: ioctl.h,v 1.6 1999/12/01 23:58:36 davem Exp $ */
 #ifndef _SPARC_IOCTL_H
 #define _SPARC_IOCTL_H
 
diff --git a/include/asm-sparc/kdebug.h b/include/asm-sparc/kdebug.h
index 631f15f..f69fe7d 100644
--- a/include/asm-sparc/kdebug.h
+++ b/include/asm-sparc/kdebug.h
@@ -1,4 +1,4 @@
-/* $Id: kdebug.h,v 1.11 2000/06/04 06:23:53 anton Exp $
+/*
  * kdebug.h:  Defines and definitions for debugging the Linux kernel
  *            under various kernel debuggers.
  *
diff --git a/include/asm-sparc/machines.h b/include/asm-sparc/machines.h
index d831350..d6c6bf8 100644
--- a/include/asm-sparc/machines.h
+++ b/include/asm-sparc/machines.h
@@ -1,4 +1,4 @@
-/* $Id: machines.h,v 1.4 1995/11/25 02:31:58 davem Exp $
+/*
  * machines.h:  Defines for taking apart the machine type value in the
  *              idprom and determining the kind of machine we are on.
  *
diff --git a/include/asm-sparc/mbus.h b/include/asm-sparc/mbus.h
index ecacdf4..bb5ae61 100644
--- a/include/asm-sparc/mbus.h
+++ b/include/asm-sparc/mbus.h
@@ -1,4 +1,4 @@
-/* $Id: mbus.h,v 1.9 1997/06/24 15:48:12 jj Exp $
+/*
  * mbus.h:  Various defines for MBUS modules.
  *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/include/asm-sparc/memreg.h b/include/asm-sparc/memreg.h
index 5fb95c8..845ad2b 100644
--- a/include/asm-sparc/memreg.h
+++ b/include/asm-sparc/memreg.h
@@ -1,4 +1,3 @@
-/* $Id: memreg.h,v 1.8 1996/08/29 09:48:23 davem Exp $ */
 #ifndef _SPARC_MEMREG_H
 #define _SPARC_MEMREG_H
 /* memreg.h:  Definitions of the values found in the synchronous
diff --git a/include/asm-sparc/mman.h b/include/asm-sparc/mman.h
index 3d16b40..fdfbbf0 100644
--- a/include/asm-sparc/mman.h
+++ b/include/asm-sparc/mman.h
@@ -1,4 +1,3 @@
-/* $Id: mman.h,v 1.9 2000/03/15 02:44:23 davem Exp $ */
 #ifndef __SPARC_MMAN_H__
 #define __SPARC_MMAN_H__
 
diff --git a/include/asm-sparc/mostek.h b/include/asm-sparc/mostek.h
index 958d051..29aad11 100644
--- a/include/asm-sparc/mostek.h
+++ b/include/asm-sparc/mostek.h
@@ -1,4 +1,4 @@
-/* $Id: mostek.h,v 1.13 2001/01/11 15:07:09 davem Exp $
+/*
  * mostek.h:  Describes the various Mostek time of day clock registers.
  *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/include/asm-sparc/mpmbox.h b/include/asm-sparc/mpmbox.h
index 0e1bc58..f842303 100644
--- a/include/asm-sparc/mpmbox.h
+++ b/include/asm-sparc/mpmbox.h
@@ -1,4 +1,4 @@
-/* $Id: mpmbox.h,v 1.4 1996/04/25 06:13:19 davem Exp $
+/*
  * mpmbox.h:  Interface and defines for the OpenProm mailbox
  *               facilities for MP machines under Linux.
  *
diff --git a/include/asm-sparc/msi.h b/include/asm-sparc/msi.h
index ff72cbd..724ca56 100644
--- a/include/asm-sparc/msi.h
+++ b/include/asm-sparc/msi.h
@@ -1,4 +1,4 @@
-/* $Id: msi.h,v 1.3 1996/08/29 09:48:25 davem Exp $
+/*
  * msi.h:  Defines specific to the MBus - Sbus - Interface.
  *
  * Copyright (C) 1996 David S. Miller (davem@caip.rutgers.edu)
diff --git a/include/asm-sparc/mxcc.h b/include/asm-sparc/mxcc.h
index 128fe97..c0517bd 100644
--- a/include/asm-sparc/mxcc.h
+++ b/include/asm-sparc/mxcc.h
@@ -1,4 +1,4 @@
-/* $Id: mxcc.h,v 1.7 1997/04/20 14:11:46 ecd Exp $
+/*
  * mxcc.h:  Definitions of the Viking MXCC registers
  *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/include/asm-sparc/namei.h b/include/asm-sparc/namei.h
index 618344d..0646102 100644
--- a/include/asm-sparc/namei.h
+++ b/include/asm-sparc/namei.h
@@ -1,4 +1,4 @@
-/* $Id: namei.h,v 1.16 2000/04/13 00:55:54 davem Exp $
+/*
  * linux/include/asm-sparc/namei.h
  *
  * Routines to handle famous /usr/gnemul/s*.
diff --git a/include/asm-sparc/obio.h b/include/asm-sparc/obio.h
index 47854a2..1a7544c 100644
--- a/include/asm-sparc/obio.h
+++ b/include/asm-sparc/obio.h
@@ -1,4 +1,4 @@
-/* $Id: obio.h,v 1.4 1998/03/09 14:04:55 jj Exp $
+/*
  * obio.h:  Some useful locations in 0xFXXXXXXXX PA obio space on sun4d.
  *
  * Copyright (C) 1997 Jakub Jelinek <jj@sunsite.mff.cuni.cz>
diff --git a/include/asm-sparc/openprom.h b/include/asm-sparc/openprom.h
index 12929a2..ed4b6bc 100644
--- a/include/asm-sparc/openprom.h
+++ b/include/asm-sparc/openprom.h
@@ -1,4 +1,3 @@
-/* $Id: openprom.h,v 1.24 2000/06/04 06:23:53 anton Exp $ */
 #ifndef __SPARC_OPENPROM_H
 #define __SPARC_OPENPROM_H
 
diff --git a/include/asm-sparc/oplib.h b/include/asm-sparc/oplib.h
index 7becc84..61c3ca6 100644
--- a/include/asm-sparc/oplib.h
+++ b/include/asm-sparc/oplib.h
@@ -1,4 +1,4 @@
-/* $Id: oplib.h,v 1.23 2001/12/21 00:54:31 davem Exp $
+/*
  * oplib.h:  Describes the interface and available routines in the
  *           Linux Prom library.
  *
diff --git a/include/asm-sparc/page.h b/include/asm-sparc/page.h
index 1625a8c..6aa9e4c 100644
--- a/include/asm-sparc/page.h
+++ b/include/asm-sparc/page.h
@@ -1,4 +1,4 @@
-/* $Id: page.h,v 1.55 2000/10/30 21:01:41 davem Exp $
+/*
  * page.h:  Various defines and such for MMU operations on the Sparc for
  *          the Linux kernel.
  *
diff --git a/include/asm-sparc/param.h b/include/asm-sparc/param.h
index 86ba59a..9836d9a 100644
--- a/include/asm-sparc/param.h
+++ b/include/asm-sparc/param.h
@@ -1,4 +1,3 @@
-/* $Id: param.h,v 1.4 2000/10/30 21:01:41 davem Exp $ */
 #ifndef _ASMSPARC_PARAM_H
 #define _ASMSPARC_PARAM_H
 
diff --git a/include/asm-sparc/pbm.h b/include/asm-sparc/pbm.h
index fedd9c6..458a491 100644
--- a/include/asm-sparc/pbm.h
+++ b/include/asm-sparc/pbm.h
@@ -1,4 +1,4 @@
-/* $Id: pbm.h,v 1.3 1999/12/20 17:06:35 zaitcev Exp $
+/*
  *
  * pbm.h: PCI bus module pseudo driver software state
  *        Adopted from sparc64 by V. Roganov and G. Raiko
diff --git a/include/asm-sparc/pcic.h b/include/asm-sparc/pcic.h
index dedea14..f20ef56 100644
--- a/include/asm-sparc/pcic.h
+++ b/include/asm-sparc/pcic.h
@@ -1,4 +1,4 @@
-/* $Id: pcic.h,v 1.4 1999/11/17 07:34:20 zaitcev Exp $
+/*
  * pcic.h: JavaEngine 1 specific PCI definitions.
  *
  * Copyright (C) 1998 V. Roganov and G. Raiko
diff --git a/include/asm-sparc/pgalloc.h b/include/asm-sparc/pgalloc.h
index 6292cd0..681582d 100644
--- a/include/asm-sparc/pgalloc.h
+++ b/include/asm-sparc/pgalloc.h
@@ -1,4 +1,3 @@
-/* $Id: pgalloc.h,v 1.16 2001/12/21 04:56:17 davem Exp $ */
 #ifndef _SPARC_PGALLOC_H
 #define _SPARC_PGALLOC_H
 
diff --git a/include/asm-sparc/pgtable.h b/include/asm-sparc/pgtable.h
index d84af6d..6051229 100644
--- a/include/asm-sparc/pgtable.h
+++ b/include/asm-sparc/pgtable.h
@@ -1,4 +1,3 @@
-/* $Id: pgtable.h,v 1.110 2001/12/21 04:56:17 davem Exp $ */
 #ifndef _SPARC_PGTABLE_H
 #define _SPARC_PGTABLE_H
 
diff --git a/include/asm-sparc/pgtsrmmu.h b/include/asm-sparc/pgtsrmmu.h
index edeb981..808555f 100644
--- a/include/asm-sparc/pgtsrmmu.h
+++ b/include/asm-sparc/pgtsrmmu.h
@@ -1,4 +1,4 @@
-/* $Id: pgtsrmmu.h,v 1.31 2000/07/16 21:48:52 anton Exp $
+/*
  * pgtsrmmu.h:  SRMMU page table defines and code.
  *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/include/asm-sparc/pgtsun4.h b/include/asm-sparc/pgtsun4.h
index 60bda10..5a0d661 100644
--- a/include/asm-sparc/pgtsun4.h
+++ b/include/asm-sparc/pgtsun4.h
@@ -1,4 +1,4 @@
-/* $Id: pgtsun4.h,v 1.5 2000/06/05 06:08:46 anton Exp $
+/*
  * pgtsun4.h:  Sun4 specific pgtable.h defines and code.
  *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/include/asm-sparc/pgtsun4c.h b/include/asm-sparc/pgtsun4c.h
index f53b6db..aeb25e9 100644
--- a/include/asm-sparc/pgtsun4c.h
+++ b/include/asm-sparc/pgtsun4c.h
@@ -1,4 +1,4 @@
-/* $Id: pgtsun4c.h,v 1.37 2000/06/05 06:08:46 anton Exp $
+/*
  * pgtsun4c.h:  Sun4c specific pgtable.h defines and code.
  *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/include/asm-sparc/psr.h b/include/asm-sparc/psr.h
index 2139704..b8c0e5f 100644
--- a/include/asm-sparc/psr.h
+++ b/include/asm-sparc/psr.h
@@ -1,4 +1,4 @@
-/* $Id: psr.h,v 1.15 1997/10/04 08:54:22 ecd Exp $
+/*
  * psr.h: This file holds the macros for masking off various parts of
  *        the processor status register on the Sparc. This is valid
  *        for Version 8. On the V9 this is renamed to the PSTATE
diff --git a/include/asm-sparc/ptrace.h b/include/asm-sparc/ptrace.h
index 0afb867..11f3bc2 100644
--- a/include/asm-sparc/ptrace.h
+++ b/include/asm-sparc/ptrace.h
@@ -1,4 +1,3 @@
-/* $Id: ptrace.h,v 1.25 1997/03/04 16:27:25 jj Exp $ */
 #ifndef _SPARC_PTRACE_H
 #define _SPARC_PTRACE_H
 
diff --git a/include/asm-sparc/resource.h b/include/asm-sparc/resource.h
index 0514c30..985948a 100644
--- a/include/asm-sparc/resource.h
+++ b/include/asm-sparc/resource.h
@@ -1,4 +1,4 @@
-/* $Id: resource.h,v 1.12 2000/09/23 02:09:21 davem Exp $
+/*
  * resource.h: Resource definitions.
  *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/include/asm-sparc/ross.h b/include/asm-sparc/ross.h
index f2c14b5..ecb6e81 100644
--- a/include/asm-sparc/ross.h
+++ b/include/asm-sparc/ross.h
@@ -1,4 +1,4 @@
-/* $Id: ross.h,v 1.13 1998/01/07 06:49:11 baccala Exp $
+/*
  * ross.h: Ross module specific definitions and defines.
  *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/include/asm-sparc/rtc.h b/include/asm-sparc/rtc.h
index f4f261d..f9ecb1f 100644
--- a/include/asm-sparc/rtc.h
+++ b/include/asm-sparc/rtc.h
@@ -1,5 +1,4 @@
-/* $Id: rtc.h,v 1.2 1996/08/21 23:17:39 ecd Exp $
- *
+/*
  * rtc.h: Definitions for access to the Mostek real time clock
  *
  * Copyright (C) 1996 Thomas K. Dyas (tdyas@eden.rutgers.edu)
diff --git a/include/asm-sparc/sbi.h b/include/asm-sparc/sbi.h
index 86a603a..5eb7f19 100644
--- a/include/asm-sparc/sbi.h
+++ b/include/asm-sparc/sbi.h
@@ -1,4 +1,4 @@
-/* $Id: sbi.h,v 1.2 1998/03/09 14:04:48 jj Exp $
+/*
  * sbi.h:  SBI (Sbus Interface on sun4d) definitions
  *
  * Copyright (C) 1997 Jakub Jelinek <jj@sunsite.mff.cuni.cz>
diff --git a/include/asm-sparc/sbus.h b/include/asm-sparc/sbus.h
index 27d076c..f1d2fe1 100644
--- a/include/asm-sparc/sbus.h
+++ b/include/asm-sparc/sbus.h
@@ -1,4 +1,4 @@
-/* $Id: sbus.h,v 1.22 2000/02/18 13:50:50 davem Exp $
+/*
  * sbus.h:  Defines for the Sun SBus.
  *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/include/asm-sparc/scatterlist.h b/include/asm-sparc/scatterlist.h
index e08d3d7..c82609c 100644
--- a/include/asm-sparc/scatterlist.h
+++ b/include/asm-sparc/scatterlist.h
@@ -1,4 +1,3 @@
-/* $Id: scatterlist.h,v 1.8 2001/12/17 07:05:15 davem Exp $ */
 #ifndef _SPARC_SCATTERLIST_H
 #define _SPARC_SCATTERLIST_H
 
diff --git a/include/asm-sparc/shmparam.h b/include/asm-sparc/shmparam.h
index bb93a6f..59a1243 100644
--- a/include/asm-sparc/shmparam.h
+++ b/include/asm-sparc/shmparam.h
@@ -1,4 +1,3 @@
-/* $Id: shmparam.h,v 1.6 1999/12/09 10:32:41 davem Exp $ */
 #ifndef _ASMSPARC_SHMPARAM_H
 #define _ASMSPARC_SHMPARAM_H
 
diff --git a/include/asm-sparc/sigcontext.h b/include/asm-sparc/sigcontext.h
index 7fa2c7d..c5fb60d 100644
--- a/include/asm-sparc/sigcontext.h
+++ b/include/asm-sparc/sigcontext.h
@@ -1,4 +1,3 @@
-/* $Id: sigcontext.h,v 1.14 1999/09/06 08:22:05 jj Exp $ */
 #ifndef __SPARC_SIGCONTEXT_H
 #define __SPARC_SIGCONTEXT_H
 
diff --git a/include/asm-sparc/siginfo.h b/include/asm-sparc/siginfo.h
index 2c3ea8b..3c71af1 100644
--- a/include/asm-sparc/siginfo.h
+++ b/include/asm-sparc/siginfo.h
@@ -1,7 +1,3 @@
-/* $Id: siginfo.h,v 1.9 2002/02/08 03:57:18 davem Exp $
- * siginfo.c:
- */
-
 #ifndef _SPARC_SIGINFO_H
 #define _SPARC_SIGINFO_H
 
diff --git a/include/asm-sparc/signal.h b/include/asm-sparc/signal.h
index 94071c7..683657d 100644
--- a/include/asm-sparc/signal.h
+++ b/include/asm-sparc/signal.h
@@ -1,4 +1,3 @@
-/* $Id: signal.h,v 1.35 1999/09/06 08:22:04 jj Exp $ */
 #ifndef _ASMSPARC_SIGNAL_H
 #define _ASMSPARC_SIGNAL_H
 
diff --git a/include/asm-sparc/smpprim.h b/include/asm-sparc/smpprim.h
index e7b6d34..eb849d8 100644
--- a/include/asm-sparc/smpprim.h
+++ b/include/asm-sparc/smpprim.h
@@ -1,4 +1,4 @@
-/*  $Id: smpprim.h,v 1.5 1996/08/29 09:48:49 davem Exp $
+/*
  *  smpprim.h:  SMP locking primitives on the Sparc
  *
  *  God knows we won't be actually using this code for some time
diff --git a/include/asm-sparc/socket.h b/include/asm-sparc/socket.h
index a00e15d..bf50d0c 100644
--- a/include/asm-sparc/socket.h
+++ b/include/asm-sparc/socket.h
@@ -1,4 +1,3 @@
-/* $Id: socket.h,v 1.17 2001/06/13 16:25:03 davem Exp $ */
 #ifndef _ASM_SOCKET_H
 #define _ASM_SOCKET_H
 
diff --git a/include/asm-sparc/stat.h b/include/asm-sparc/stat.h
index a5b4272..2299e1d 100644
--- a/include/asm-sparc/stat.h
+++ b/include/asm-sparc/stat.h
@@ -1,4 +1,3 @@
-/* $Id: stat.h,v 1.12 2000/08/04 05:35:55 davem Exp $ */
 #ifndef _SPARC_STAT_H
 #define _SPARC_STAT_H
 
diff --git a/include/asm-sparc/statfs.h b/include/asm-sparc/statfs.h
index d623f14..304520f 100644
--- a/include/asm-sparc/statfs.h
+++ b/include/asm-sparc/statfs.h
@@ -1,4 +1,3 @@
-/* $Id: statfs.h,v 1.4 1996/06/07 00:41:05 ecd Exp $ */
 #ifndef _SPARC_STATFS_H
 #define _SPARC_STATFS_H
 
diff --git a/include/asm-sparc/string.h b/include/asm-sparc/string.h
index cb1e923..8d7c0dd 100644
--- a/include/asm-sparc/string.h
+++ b/include/asm-sparc/string.h
@@ -1,4 +1,4 @@
-/* $Id: string.h,v 1.36 2001/12/21 00:54:31 davem Exp $
+/*
  * string.h: External definitions for optimized assembly string
  *           routines for the Linux Kernel.
  *
diff --git a/include/asm-sparc/sun4paddr.h b/include/asm-sparc/sun4paddr.h
index d863bfd..d52985f 100644
--- a/include/asm-sparc/sun4paddr.h
+++ b/include/asm-sparc/sun4paddr.h
@@ -1,4 +1,4 @@
-/* $Id: sun4paddr.h,v 1.3 1998/07/28 16:53:27 jj Exp $
+/*
  * sun4paddr.h:  Various physical addresses on sun4 machines
  *
  * Copyright (C) 1997 Anton Blanchard (anton@progsoc.uts.edu.au)
diff --git a/include/asm-sparc/sunbpp.h b/include/asm-sparc/sunbpp.h
index 568db79..92ee1a8 100644
--- a/include/asm-sparc/sunbpp.h
+++ b/include/asm-sparc/sunbpp.h
@@ -1,4 +1,4 @@
-/* $Id: sunbpp.h,v 1.1 1999/08/08 14:09:49 shadow Exp $
+/*
  * include/asm-sparc/sunbpp.h
  */
 
diff --git a/include/asm-sparc/sysen.h b/include/asm-sparc/sysen.h
index 692fa6f..6af34ab 100644
--- a/include/asm-sparc/sysen.h
+++ b/include/asm-sparc/sysen.h
@@ -1,4 +1,4 @@
-/* $Id: sysen.h,v 1.3 1995/11/25 02:32:58 davem Exp $
+/*
  * sysen.h:  Bit fields within the "System Enable" register accessed via
  *           the ASI_CONTROL address space at address AC_SYSENABLE.
  *
diff --git a/include/asm-sparc/termios.h b/include/asm-sparc/termios.h
index 733d405..f7b4409 100644
--- a/include/asm-sparc/termios.h
+++ b/include/asm-sparc/termios.h
@@ -1,4 +1,3 @@
-/* $Id: termios.h,v 1.32 2001/06/01 08:12:11 davem Exp $ */
 #ifndef _SPARC_TERMIOS_H
 #define _SPARC_TERMIOS_H
 
diff --git a/include/asm-sparc/timer.h b/include/asm-sparc/timer.h
index cb1fa1d..d909565 100644
--- a/include/asm-sparc/timer.h
+++ b/include/asm-sparc/timer.h
@@ -1,4 +1,4 @@
-/* $Id: timer.h,v 1.21 1999/04/20 13:22:51 anton Exp $
+/*
  * timer.h:  Definitions for the timer chips on the Sparc.
  *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/include/asm-sparc/traps.h b/include/asm-sparc/traps.h
index f62c7f8..bebdbf8 100644
--- a/include/asm-sparc/traps.h
+++ b/include/asm-sparc/traps.h
@@ -1,4 +1,4 @@
-/* $Id: traps.h,v 1.9 1998/03/09 14:04:53 jj Exp $
+/*
  * traps.h:  Format of entries for the Sparc trap table.
  *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/include/asm-sparc/tsunami.h b/include/asm-sparc/tsunami.h
index 887add5..5bbd1d5 100644
--- a/include/asm-sparc/tsunami.h
+++ b/include/asm-sparc/tsunami.h
@@ -1,4 +1,4 @@
-/* $Id: tsunami.h,v 1.5 1996/08/29 09:49:03 davem Exp $
+/*
  * tsunami.h:  Module specific definitions for Tsunami V8 Sparcs
  *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/include/asm-sparc/turbosparc.h b/include/asm-sparc/turbosparc.h
index 31d2350..17c7328 100644
--- a/include/asm-sparc/turbosparc.h
+++ b/include/asm-sparc/turbosparc.h
@@ -1,4 +1,4 @@
-/* $Id: turbosparc.h,v 1.4 1998/08/16 16:02:42 ecd Exp $
+/*
  * turbosparc.h:  Defines specific to the TurboSparc module.
  *            This is SRMMU stuff.
  *
diff --git a/include/asm-sparc/types.h b/include/asm-sparc/types.h
index 1b08ef8..07734f9 100644
--- a/include/asm-sparc/types.h
+++ b/include/asm-sparc/types.h
@@ -1,4 +1,3 @@
-/* $Id: types.h,v 1.13 2001/12/21 01:22:59 davem Exp $ */
 #ifndef _SPARC_TYPES_H
 #define _SPARC_TYPES_H
 
diff --git a/include/asm-sparc/uaccess.h b/include/asm-sparc/uaccess.h
index 366b116..47d5619 100644
--- a/include/asm-sparc/uaccess.h
+++ b/include/asm-sparc/uaccess.h
@@ -1,4 +1,4 @@
-/* $Id: uaccess.h,v 1.24 2001/10/30 04:32:24 davem Exp $
+/*
  * uaccess.h: User space memore access functions.
  *
  * Copyright (C) 1996 David S. Miller (davem@caip.rutgers.edu)
diff --git a/include/asm-sparc/vac-ops.h b/include/asm-sparc/vac-ops.h
index ab6f53b..d105276 100644
--- a/include/asm-sparc/vac-ops.h
+++ b/include/asm-sparc/vac-ops.h
@@ -1,4 +1,3 @@
-/* $Id: vac-ops.h,v 1.13 1998/01/30 10:59:59 jj Exp $ */
 #ifndef _SPARC_VAC_OPS_H
 #define _SPARC_VAC_OPS_H
 
diff --git a/include/asm-sparc/vaddrs.h b/include/asm-sparc/vaddrs.h
index 9109739..f6ca477 100644
--- a/include/asm-sparc/vaddrs.h
+++ b/include/asm-sparc/vaddrs.h
@@ -1,4 +1,3 @@
-/* $Id: vaddrs.h,v 1.27 2001/07/04 00:18:18 davem Exp $ */
 #ifndef _SPARC_VADDRS_H
 #define _SPARC_VADDRS_H
 
diff --git a/include/asm-sparc/viking.h b/include/asm-sparc/viking.h
index 7541da7..989930a 100644
--- a/include/asm-sparc/viking.h
+++ b/include/asm-sparc/viking.h
@@ -1,4 +1,4 @@
-/* $Id: viking.h,v 1.19 1997/04/20 14:11:48 ecd Exp $
+/*
  * viking.h:  Defines specific to the GNU/Viking MBUS module.
  *            This is SRMMU stuff.
  *
diff --git a/include/asm-sparc/winmacro.h b/include/asm-sparc/winmacro.h
index 096f3d3..5b0a06d 100644
--- a/include/asm-sparc/winmacro.h
+++ b/include/asm-sparc/winmacro.h
@@ -1,4 +1,4 @@
-/* $Id: winmacro.h,v 1.22 2000/05/09 17:40:15 davem Exp $
+/*
  * winmacro.h: Window loading-unloading macros.
  *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)

