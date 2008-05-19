Return-Path: <linux-kernel-owner+w=401wt.eu-S1764454AbYESV7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764454AbYESV7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 17:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763733AbYESV6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 17:58:44 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:42077 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764352AbYESV6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 17:58:39 -0400
Date: Tue, 20 May 2008 00:56:32 +0300
From: Adrian Bunk <bunk@kernel.org>
To: davem@davemloft.net
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] sparc64: remove CVS keywords
Message-ID: <20080519215632.GN17716@cs181133002.pp.htv.fi>
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

 arch/sparc64/Makefile                |    1 -
 arch/sparc64/boot/Makefile           |    1 -
 arch/sparc64/boot/piggyback.c        |    2 +-
 arch/sparc64/kernel/dtlb_prot.S      |    2 +-
 arch/sparc64/kernel/ebus.c           |    2 +-
 arch/sparc64/kernel/etrap.S          |    2 +-
 arch/sparc64/kernel/idprom.c         |    2 +-
 arch/sparc64/kernel/rtrap.S          |    2 +-
 arch/sparc64/kernel/sbus.c           |    2 +-
 arch/sparc64/kernel/setup.c          |    2 +-
 arch/sparc64/kernel/signal.c         |    2 +-
 arch/sparc64/kernel/starfire.c       |    2 +-
 arch/sparc64/kernel/sys32.S          |    2 +-
 arch/sparc64/kernel/trampoline.S     |    2 +-
 arch/sparc64/kernel/unaligned.c      |    2 +-
 arch/sparc64/lib/PeeCeeI.c           |    2 +-
 arch/sparc64/lib/VISsave.S           |    2 +-
 arch/sparc64/lib/memcmp.S            |    2 +-
 arch/sparc64/lib/memscan.S           |    2 +-
 arch/sparc64/lib/strncmp.S           |    2 +-
 arch/sparc64/lib/strncpy_from_user.S |    2 +-
 arch/sparc64/math-emu/math.c         |    2 +-
 arch/sparc64/math-emu/sfp-util.h     |    2 +-
 arch/sparc64/mm/Makefile             |    1 -
 arch/sparc64/mm/fault.c              |    2 +-
 arch/sparc64/mm/generic.c            |    2 +-
 arch/sparc64/mm/init.c               |    2 +-
 arch/sparc64/mm/ultra.S              |    2 +-
 arch/sparc64/prom/Makefile           |    1 -
 arch/sparc64/prom/bootstr.c          |    2 +-
 arch/sparc64/prom/devops.c           |    2 +-
 arch/sparc64/prom/init.c             |    2 +-
 arch/sparc64/prom/misc.c             |    2 +-
 arch/sparc64/prom/p1275.c            |    2 +-
 arch/sparc64/prom/tree.c             |    2 +-
 include/asm-sparc64/apb.h            |    2 +-
 include/asm-sparc64/asi.h            |    1 -
 include/asm-sparc64/auxio.h          |    2 +-
 include/asm-sparc64/bbc.h            |    2 +-
 include/asm-sparc64/bitops.h         |    2 +-
 include/asm-sparc64/chafsr.h         |    1 -
 include/asm-sparc64/checksum.h       |    1 -
 include/asm-sparc64/chmctrl.h        |    1 -
 include/asm-sparc64/dcr.h            |    1 -
 include/asm-sparc64/display7seg.h    |    2 +-
 include/asm-sparc64/dma.h            |    2 +-
 include/asm-sparc64/ebus.h           |    2 +-
 include/asm-sparc64/elf.h            |    1 -
 include/asm-sparc64/envctrl.h        |    2 +-
 include/asm-sparc64/estate.h         |    1 -
 include/asm-sparc64/fcntl.h          |    1 -
 include/asm-sparc64/fhc.h            |    2 +-
 include/asm-sparc64/head.h           |    1 -
 include/asm-sparc64/ide.h            |    2 +-
 include/asm-sparc64/idprom.h         |    2 +-
 include/asm-sparc64/ioctl.h          |    1 -
 include/asm-sparc64/ioctls.h         |    1 -
 include/asm-sparc64/lsu.h            |    1 -
 include/asm-sparc64/mman.h           |    1 -
 include/asm-sparc64/mmu_context.h    |    1 -
 include/asm-sparc64/namei.h          |    2 +-
 include/asm-sparc64/openprom.h       |    1 -
 include/asm-sparc64/page.h           |    2 --
 include/asm-sparc64/pgalloc.h        |    1 -
 include/asm-sparc64/pgtable.h        |    2 +-
 include/asm-sparc64/pil.h            |    1 -
 include/asm-sparc64/processor.h      |    2 +-
 include/asm-sparc64/psrcompat.h      |    1 -
 include/asm-sparc64/pstate.h         |    1 -
 include/asm-sparc64/reg.h            |    2 +-
 include/asm-sparc64/resource.h       |    2 +-
 include/asm-sparc64/rtc.h            |    3 +--
 include/asm-sparc64/rwsem.h          |    2 +-
 include/asm-sparc64/scatterlist.h    |    1 -
 include/asm-sparc64/shmparam.h       |    1 -
 include/asm-sparc64/sigcontext.h     |    1 -
 include/asm-sparc64/signal.h         |    1 -
 include/asm-sparc64/socket.h         |    1 -
 include/asm-sparc64/starfire.h       |    2 +-
 include/asm-sparc64/stat.h           |    1 -
 include/asm-sparc64/statfs.h         |    1 -
 include/asm-sparc64/string.h         |    2 +-
 include/asm-sparc64/sunbpp.h         |    2 +-
 include/asm-sparc64/termios.h        |    1 -
 include/asm-sparc64/ttable.h         |    1 -
 include/asm-sparc64/types.h          |    1 -
 include/asm-sparc64/uaccess.h        |    1 -
 include/asm-sparc64/uctx.h           |    2 +-
 include/asm-sparc64/utrap.h          |    2 +-
 include/asm-sparc64/watchdog.h       |    2 +-
 90 files changed, 55 insertions(+), 92 deletions(-)

41cc631f10606160060fa7e8bc6c2f203ef166c2 diff --git a/arch/sparc64/Makefile b/arch/sparc64/Makefile
index 9cb75c8..4b8f2b0 100644
--- a/arch/sparc64/Makefile
+++ b/arch/sparc64/Makefile
@@ -1,4 +1,3 @@
-# $Id: Makefile,v 1.52 2002/02/09 19:49:31 davem Exp $
 # sparc64/Makefile
 #
 # Makefile for the architecture dependent flags and dependencies on the
diff --git a/arch/sparc64/boot/Makefile b/arch/sparc64/boot/Makefile
index 6968a6d..0458b52 100644
--- a/arch/sparc64/boot/Makefile
+++ b/arch/sparc64/boot/Makefile
@@ -1,4 +1,3 @@
-# $Id: Makefile,v 1.4 1997/12/15 20:08:56 ecd Exp $
 # Makefile for the Sparc64 boot stuff.
 #
 # Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/arch/sparc64/boot/piggyback.c b/arch/sparc64/boot/piggyback.c
index 36f9074..de364bf 100644
--- a/arch/sparc64/boot/piggyback.c
+++ b/arch/sparc64/boot/piggyback.c
@@ -1,4 +1,4 @@
-/* $Id: piggyback.c,v 1.2 2000/09/19 14:34:39 anton Exp $
+/*
    Simple utility to make a single-image install kernel with initial ramdisk
    for Sparc64 tftpbooting without need to set up nfs.
    
diff --git a/arch/sparc64/kernel/dtlb_prot.S b/arch/sparc64/kernel/dtlb_prot.S
index e0a9201..b2c2c5b 100644
--- a/arch/sparc64/kernel/dtlb_prot.S
+++ b/arch/sparc64/kernel/dtlb_prot.S
@@ -1,4 +1,4 @@
-/* $Id: dtlb_prot.S,v 1.22 2001/04/11 23:40:32 davem Exp $
+/*
  * dtlb_prot.S: DTLB protection trap strategy.
  *              This is included directly into the trap table.
  *
diff --git a/arch/sparc64/kernel/ebus.c b/arch/sparc64/kernel/ebus.c
index bc26322..c49d038 100644
--- a/arch/sparc64/kernel/ebus.c
+++ b/arch/sparc64/kernel/ebus.c
@@ -1,4 +1,4 @@
-/* $Id: ebus.c,v 1.64 2001/11/08 04:41:33 davem Exp $
+/*
  * ebus.c: PCI to EBus bridge device.
  *
  * Copyright (C) 1997  Eddie C. Dost  (ecd@skynet.be)
diff --git a/arch/sparc64/kernel/etrap.S b/arch/sparc64/kernel/etrap.S
index f25e1da..29ce489 100644
--- a/arch/sparc64/kernel/etrap.S
+++ b/arch/sparc64/kernel/etrap.S
@@ -1,4 +1,4 @@
-/* $Id: etrap.S,v 1.46 2002/02/09 19:49:30 davem Exp $
+/*
  * etrap.S: Preparing for entry into the kernel on Sparc V9.
  *
  * Copyright (C) 1996, 1997 David S. Miller (davem@caip.rutgers.edu)
diff --git a/arch/sparc64/kernel/idprom.c b/arch/sparc64/kernel/idprom.c
index 3b6789e..5b45a80 100644
--- a/arch/sparc64/kernel/idprom.c
+++ b/arch/sparc64/kernel/idprom.c
@@ -1,4 +1,4 @@
-/* $Id: idprom.c,v 1.3 1999/08/31 06:54:53 davem Exp $
+/*
  * idprom.c: Routines to load the idprom into kernel addresses and
  *           interpret the data contained within.
  *
diff --git a/arch/sparc64/kernel/rtrap.S b/arch/sparc64/kernel/rtrap.S
index 16689b2..3afacbb 100644
--- a/arch/sparc64/kernel/rtrap.S
+++ b/arch/sparc64/kernel/rtrap.S
@@ -1,4 +1,4 @@
-/* $Id: rtrap.S,v 1.61 2002/02/09 19:49:31 davem Exp $
+/*
  * rtrap.S: Preparing for return from trap on Sparc V9.
  *
  * Copyright (C) 1997,1998 Jakub Jelinek (jj@sunsite.mff.cuni.cz)
diff --git a/arch/sparc64/kernel/sbus.c b/arch/sparc64/kernel/sbus.c
index fa2827c..e33a8a6 100644
--- a/arch/sparc64/kernel/sbus.c
+++ b/arch/sparc64/kernel/sbus.c
@@ -1,4 +1,4 @@
-/* $Id: sbus.c,v 1.19 2002/01/23 11:27:32 davem Exp $
+/*
  * sbus.c: UltraSparc SBUS controller support.
  *
  * Copyright (C) 1999 David S. Miller (davem@redhat.com)
diff --git a/arch/sparc64/kernel/setup.c b/arch/sparc64/kernel/setup.c
index da5e6ee..c8b03a4 100644
--- a/arch/sparc64/kernel/setup.c
+++ b/arch/sparc64/kernel/setup.c
@@ -1,4 +1,4 @@
-/*  $Id: setup.c,v 1.72 2002/02/09 19:49:30 davem Exp $
+/*
  *  linux/arch/sparc64/kernel/setup.c
  *
  *  Copyright (C) 1995,1996  David S. Miller (davem@caip.rutgers.edu)
diff --git a/arch/sparc64/kernel/signal.c b/arch/sparc64/kernel/signal.c
index 6e4dc67..9667e96 100644
--- a/arch/sparc64/kernel/signal.c
+++ b/arch/sparc64/kernel/signal.c
@@ -1,4 +1,4 @@
-/*  $Id: signal.c,v 1.60 2002/02/09 19:49:31 davem Exp $
+/*
  *  arch/sparc64/kernel/signal.c
  *
  *  Copyright (C) 1991, 1992  Linus Torvalds
diff --git a/arch/sparc64/kernel/starfire.c b/arch/sparc64/kernel/starfire.c
index b930fee..7461581 100644
--- a/arch/sparc64/kernel/starfire.c
+++ b/arch/sparc64/kernel/starfire.c
@@ -1,4 +1,4 @@
-/* $Id: starfire.c,v 1.10 2001/04/14 21:13:45 davem Exp $
+/*
  * starfire.c: Starfire/E10000 support.
  *
  * Copyright (C) 1998 David S. Miller (davem@redhat.com)
diff --git a/arch/sparc64/kernel/sys32.S b/arch/sparc64/kernel/sys32.S
index 010a737..ade18ba 100644
--- a/arch/sparc64/kernel/sys32.S
+++ b/arch/sparc64/kernel/sys32.S
@@ -1,4 +1,4 @@
-/* $Id: sys32.S,v 1.12 2000/03/24 04:17:37 davem Exp $
+/*
  * sys32.S: I-cache tricks for 32-bit compatibility layer simple
  *          conversions.
  *
diff --git a/arch/sparc64/kernel/trampoline.S b/arch/sparc64/kernel/trampoline.S
index 56ff552..704a3af 100644
--- a/arch/sparc64/kernel/trampoline.S
+++ b/arch/sparc64/kernel/trampoline.S
@@ -1,4 +1,4 @@
-/* $Id: trampoline.S,v 1.26 2002/02/09 19:49:30 davem Exp $
+/*
  * trampoline.S: Jump start slave processors on sparc64.
  *
  * Copyright (C) 1997 David S. Miller (davem@caip.rutgers.edu)
diff --git a/arch/sparc64/kernel/unaligned.c b/arch/sparc64/kernel/unaligned.c
index 1a511e9..afa7fc4 100644
--- a/arch/sparc64/kernel/unaligned.c
+++ b/arch/sparc64/kernel/unaligned.c
@@ -1,4 +1,4 @@
-/* $Id: unaligned.c,v 1.24 2002/02/09 19:49:31 davem Exp $
+/*
  * unaligned.c: Unaligned load/store trap handling with special
  *              cases for the kernel to do them more quickly.
  *
diff --git a/arch/sparc64/lib/PeeCeeI.c b/arch/sparc64/lib/PeeCeeI.c
index 3c6cfbb..8b313f1 100644
--- a/arch/sparc64/lib/PeeCeeI.c
+++ b/arch/sparc64/lib/PeeCeeI.c
@@ -1,4 +1,4 @@
-/* $Id: PeeCeeI.c,v 1.4 1999/09/06 01:17:35 davem Exp $
+/*
  * PeeCeeI.c: The emerging standard...
  *
  * Copyright (C) 1997 David S. Miller (davem@caip.rutgers.edu)
diff --git a/arch/sparc64/lib/VISsave.S b/arch/sparc64/lib/VISsave.S
index a0ded5c..b320ae9 100644
--- a/arch/sparc64/lib/VISsave.S
+++ b/arch/sparc64/lib/VISsave.S
@@ -1,4 +1,4 @@
-/* $Id: VISsave.S,v 1.6 2002/02/09 19:49:30 davem Exp $
+/*
  * VISsave.S: Code for saving FPU register state for
  *            VIS routines. One should not call this directly,
  *            but use macros provided in <asm/visasm.h>.
diff --git a/arch/sparc64/lib/memcmp.S b/arch/sparc64/lib/memcmp.S
index c90ad96..d3fdaa8 100644
--- a/arch/sparc64/lib/memcmp.S
+++ b/arch/sparc64/lib/memcmp.S
@@ -1,4 +1,4 @@
-/* $Id: memcmp.S,v 1.3 2000/03/23 07:51:08 davem Exp $
+/*
  * Sparc64 optimized memcmp code.
  *
  * Copyright (C) 1997 Jakub Jelinek (jj@sunsite.mff.cuni.cz)
diff --git a/arch/sparc64/lib/memscan.S b/arch/sparc64/lib/memscan.S
index 5e72d49..5686dfa 100644
--- a/arch/sparc64/lib/memscan.S
+++ b/arch/sparc64/lib/memscan.S
@@ -1,4 +1,4 @@
-/* $Id: memscan.S,v 1.3 2000/01/31 04:59:10 davem Exp $
+/*
  * memscan.S: Optimized memscan for Sparc64.
  *
  * Copyright (C) 1997,1998 Jakub Jelinek (jj@ultra.linux.cz)
diff --git a/arch/sparc64/lib/strncmp.S b/arch/sparc64/lib/strncmp.S
index 6f14f53..980e837 100644
--- a/arch/sparc64/lib/strncmp.S
+++ b/arch/sparc64/lib/strncmp.S
@@ -1,4 +1,4 @@
-/* $Id: strncmp.S,v 1.2 1997/03/11 17:51:44 jj Exp $
+/*
  * Sparc64 optimized strncmp code.
  *
  * Copyright (C) 1997 Jakub Jelinek (jj@sunsite.mff.cuni.cz)
diff --git a/arch/sparc64/lib/strncpy_from_user.S b/arch/sparc64/lib/strncpy_from_user.S
index b2f499f..511c8f1 100644
--- a/arch/sparc64/lib/strncpy_from_user.S
+++ b/arch/sparc64/lib/strncpy_from_user.S
@@ -1,4 +1,4 @@
-/* $Id: strncpy_from_user.S,v 1.6 1999/05/25 16:53:05 jj Exp $
+/*
  * strncpy_from_user.S: Sparc64 strncpy from userspace.
  *
  *  Copyright (C) 1997, 1999 Jakub Jelinek (jj@ultra.linux.cz)
diff --git a/arch/sparc64/math-emu/math.c b/arch/sparc64/math-emu/math.c
index 6ee496c..add053e 100644
--- a/arch/sparc64/math-emu/math.c
+++ b/arch/sparc64/math-emu/math.c
@@ -1,4 +1,4 @@
-/* $Id: math.c,v 1.11 1999/12/20 05:02:25 davem Exp $
+/*
  * arch/sparc64/math-emu/math.c
  *
  * Copyright (C) 1997,1999 Jakub Jelinek (jj@ultra.linux.cz)
diff --git a/arch/sparc64/math-emu/sfp-util.h b/arch/sparc64/math-emu/sfp-util.h
index 31e4747..425d3cf 100644
--- a/arch/sparc64/math-emu/sfp-util.h
+++ b/arch/sparc64/math-emu/sfp-util.h
@@ -1,4 +1,4 @@
-/* $Id: sfp-util.h,v 1.5 2001/06/10 06:48:46 davem Exp $
+/*
  * arch/sparc64/math-emu/sfp-util.h
  *
  * Copyright (C) 1999 Jakub Jelinek (jj@ultra.linux.cz)
diff --git a/arch/sparc64/mm/Makefile b/arch/sparc64/mm/Makefile
index e415bf9..68d04c0 100644
--- a/arch/sparc64/mm/Makefile
+++ b/arch/sparc64/mm/Makefile
@@ -1,4 +1,3 @@
-# $Id: Makefile,v 1.8 2000/12/14 22:57:25 davem Exp $
 # Makefile for the linux Sparc64-specific parts of the memory manager.
 #
 
diff --git a/arch/sparc64/mm/fault.c b/arch/sparc64/mm/fault.c
index 2650d0d..236f4d2 100644
--- a/arch/sparc64/mm/fault.c
+++ b/arch/sparc64/mm/fault.c
@@ -1,4 +1,4 @@
-/* $Id: fault.c,v 1.59 2002/02/09 19:49:31 davem Exp $
+/*
  * arch/sparc64/mm/fault.c: Page fault handlers for the 64-bit Sparc.
  *
  * Copyright (C) 1996 David S. Miller (davem@caip.rutgers.edu)
diff --git a/arch/sparc64/mm/generic.c b/arch/sparc64/mm/generic.c
index af9d81d..f362c20 100644
--- a/arch/sparc64/mm/generic.c
+++ b/arch/sparc64/mm/generic.c
@@ -1,4 +1,4 @@
-/* $Id: generic.c,v 1.18 2001/12/21 04:56:15 davem Exp $
+/*
  * generic.c: Generic Sparc mm routines that are not dependent upon
  *            MMU type but are Sparc specific.
  *
diff --git a/arch/sparc64/mm/init.c b/arch/sparc64/mm/init.c
index a9828d7..bbc34d8 100644
--- a/arch/sparc64/mm/init.c
+++ b/arch/sparc64/mm/init.c
@@ -1,4 +1,4 @@
-/*  $Id: init.c,v 1.209 2002/02/09 19:49:31 davem Exp $
+/*
  *  arch/sparc64/mm/init.c
  *
  *  Copyright (C) 1996-1999 David S. Miller (davem@caip.rutgers.edu)
diff --git a/arch/sparc64/mm/ultra.S b/arch/sparc64/mm/ultra.S
index 796e005..15d1249 100644
--- a/arch/sparc64/mm/ultra.S
+++ b/arch/sparc64/mm/ultra.S
@@ -1,4 +1,4 @@
-/* $Id: ultra.S,v 1.72 2002/02/09 19:49:31 davem Exp $
+/*
  * ultra.S: Don't expand these all over the place...
  *
  * Copyright (C) 1997, 2000 David S. Miller (davem@redhat.com)
diff --git a/arch/sparc64/prom/Makefile b/arch/sparc64/prom/Makefile
index 3d33ed2..8c94483 100644
--- a/arch/sparc64/prom/Makefile
+++ b/arch/sparc64/prom/Makefile
@@ -1,4 +1,3 @@
-# $Id: Makefile,v 1.7 2000/12/14 22:57:25 davem Exp $
 # Makefile for the Sun Boot PROM interface library under
 # Linux.
 #
diff --git a/arch/sparc64/prom/bootstr.c b/arch/sparc64/prom/bootstr.c
index a727861..ab9ccc6 100644
--- a/arch/sparc64/prom/bootstr.c
+++ b/arch/sparc64/prom/bootstr.c
@@ -1,4 +1,4 @@
-/* $Id: bootstr.c,v 1.6 1999/08/31 06:55:01 davem Exp $
+/*
  * bootstr.c:  Boot string/argument acquisition from the PROM.
  *
  * Copyright(C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/arch/sparc64/prom/devops.c b/arch/sparc64/prom/devops.c
index 4641839..9dbd803 100644
--- a/arch/sparc64/prom/devops.c
+++ b/arch/sparc64/prom/devops.c
@@ -1,4 +1,4 @@
-/* $Id: devops.c,v 1.3 1997/10/29 07:43:28 ecd Exp $
+/*
  * devops.c:  Device operations using the PROM.
  *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/arch/sparc64/prom/init.c b/arch/sparc64/prom/init.c
index 87e7c7e..7b00f89 100644
--- a/arch/sparc64/prom/init.c
+++ b/arch/sparc64/prom/init.c
@@ -1,4 +1,4 @@
-/* $Id: init.c,v 1.10 1999/09/21 14:35:59 davem Exp $
+/*
  * init.c:  Initialize internal variables used by the PROM
  *          library functions.
  *
diff --git a/arch/sparc64/prom/misc.c b/arch/sparc64/prom/misc.c
index 47a877a..9b0c076 100644
--- a/arch/sparc64/prom/misc.c
+++ b/arch/sparc64/prom/misc.c
@@ -1,4 +1,4 @@
-/* $Id: misc.c,v 1.20 2001/09/21 03:17:07 kanoj Exp $
+/*
  * misc.c:  Miscellaneous prom functions that don't belong
  *          anywhere else.
  *
diff --git a/arch/sparc64/prom/p1275.c b/arch/sparc64/prom/p1275.c
index 7fcccc0..4b7c937 100644
--- a/arch/sparc64/prom/p1275.c
+++ b/arch/sparc64/prom/p1275.c
@@ -1,4 +1,4 @@
-/* $Id: p1275.c,v 1.22 2001/10/18 09:40:00 davem Exp $
+/*
  * p1275.c: Sun IEEE 1275 PROM low level interface routines
  *
  * Copyright (C) 1996,1997 Jakub Jelinek (jj@sunsite.mff.cuni.cz)
diff --git a/arch/sparc64/prom/tree.c b/arch/sparc64/prom/tree.c
index a99ccd7..281aea4 100644
--- a/arch/sparc64/prom/tree.c
+++ b/arch/sparc64/prom/tree.c
@@ -1,4 +1,4 @@
-/* $Id: tree.c,v 1.10 1998/01/10 22:39:00 ecd Exp $
+/*
  * tree.c: Basic device tree traversal/scanning for the Linux
  *         prom library.
  *
diff --git a/include/asm-sparc64/apb.h b/include/asm-sparc64/apb.h
index 80f0df2..8f3b57d 100644
--- a/include/asm-sparc64/apb.h
+++ b/include/asm-sparc64/apb.h
@@ -1,4 +1,4 @@
-/* $Id: apb.h,v 1.2 1998/04/01 20:41:49 ecd Exp $
+/*
  * apb.h: Advanced PCI Bridge Configuration Registers and Bits
  *
  * Copyright (C) 1998  Eddie C. Dost  (ecd@skynet.be)
diff --git a/include/asm-sparc64/asi.h b/include/asm-sparc64/asi.h
index 662a211..bc57c40 100644
--- a/include/asm-sparc64/asi.h
+++ b/include/asm-sparc64/asi.h
@@ -1,4 +1,3 @@
-/* $Id: asi.h,v 1.5 2001/03/29 11:47:47 davem Exp $ */
 #ifndef _SPARC64_ASI_H
 #define _SPARC64_ASI_H
 
diff --git a/include/asm-sparc64/auxio.h b/include/asm-sparc64/auxio.h
index 81a590a..c410049 100644
--- a/include/asm-sparc64/auxio.h
+++ b/include/asm-sparc64/auxio.h
@@ -1,4 +1,4 @@
-/* $Id: auxio.h,v 1.3 2001/06/05 08:16:34 davem Exp $
+/*
  * auxio.h:  Definitions and code for the Auxiliary I/O registers.
  *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/include/asm-sparc64/bbc.h b/include/asm-sparc64/bbc.h
index 368fce4..423a858 100644
--- a/include/asm-sparc64/bbc.h
+++ b/include/asm-sparc64/bbc.h
@@ -1,4 +1,4 @@
-/* $Id: bbc.h,v 1.2 2001/03/26 23:47:18 davem Exp $
+/*
  * bbc.h: Defines for BootBus Controller found on UltraSPARC-III
  *        systems.
  *
diff --git a/include/asm-sparc64/bitops.h b/include/asm-sparc64/bitops.h
index 11f9d81..bb87b80 100644
--- a/include/asm-sparc64/bitops.h
+++ b/include/asm-sparc64/bitops.h
@@ -1,4 +1,4 @@
-/* $Id: bitops.h,v 1.39 2002/01/30 01:40:00 davem Exp $
+/*
  * bitops.h: Bit string operations on the V9.
  *
  * Copyright 1996, 1997 David S. Miller (davem@caip.rutgers.edu)
diff --git a/include/asm-sparc64/chafsr.h b/include/asm-sparc64/chafsr.h
index fd16883..85c69b3 100644
--- a/include/asm-sparc64/chafsr.h
+++ b/include/asm-sparc64/chafsr.h
@@ -1,4 +1,3 @@
-/* $Id: chafsr.h,v 1.1 2001/03/28 10:56:34 davem Exp $ */
 #ifndef _SPARC64_CHAFSR_H
 #define _SPARC64_CHAFSR_H
 
diff --git a/include/asm-sparc64/checksum.h b/include/asm-sparc64/checksum.h
index 70a006d..b290564 100644
--- a/include/asm-sparc64/checksum.h
+++ b/include/asm-sparc64/checksum.h
@@ -1,4 +1,3 @@
-/* $Id: checksum.h,v 1.19 2002/02/09 19:49:31 davem Exp $ */
 #ifndef __SPARC64_CHECKSUM_H
 #define __SPARC64_CHECKSUM_H
 
diff --git a/include/asm-sparc64/chmctrl.h b/include/asm-sparc64/chmctrl.h
index 53047f9..859b4a4 100644
--- a/include/asm-sparc64/chmctrl.h
+++ b/include/asm-sparc64/chmctrl.h
@@ -1,4 +1,3 @@
-/* $Id: chmctrl.h,v 1.1 2001/03/29 11:43:28 davem Exp $ */
 #ifndef _SPARC64_CHMCTRL_H
 #define _SPARC64_CHMCTRL_H
 
diff --git a/include/asm-sparc64/dcr.h b/include/asm-sparc64/dcr.h
index e9a3f30..620c9ba 100644
--- a/include/asm-sparc64/dcr.h
+++ b/include/asm-sparc64/dcr.h
@@ -1,4 +1,3 @@
-/* $Id: dcr.h,v 1.4 2001/03/09 17:56:37 davem Exp $ */
 #ifndef _SPARC64_DCR_H
 #define _SPARC64_DCR_H
 
diff --git a/include/asm-sparc64/display7seg.h b/include/asm-sparc64/display7seg.h
index 955a350..c066a89 100644
--- a/include/asm-sparc64/display7seg.h
+++ b/include/asm-sparc64/display7seg.h
@@ -1,4 +1,4 @@
-/* $Id: display7seg.h,v 1.2 2000/08/02 06:22:35 davem Exp $
+/*
  *
  * display7seg - Driver interface for the 7-segment display
  * present on Sun Microsystems CP1400 and CP1500
diff --git a/include/asm-sparc64/dma.h b/include/asm-sparc64/dma.h
index a9fd061..9d4c024 100644
--- a/include/asm-sparc64/dma.h
+++ b/include/asm-sparc64/dma.h
@@ -1,4 +1,4 @@
-/* $Id: dma.h,v 1.21 2001/12/13 04:16:52 davem Exp $
+/*
  * include/asm-sparc64/dma.h
  *
  * Copyright 1996 (C) David S. Miller (davem@caip.rutgers.edu)
diff --git a/include/asm-sparc64/ebus.h b/include/asm-sparc64/ebus.h
index 9c1c6db..fcc62b9 100644
--- a/include/asm-sparc64/ebus.h
+++ b/include/asm-sparc64/ebus.h
@@ -1,4 +1,4 @@
-/* $Id: ebus.h,v 1.10 2001/03/14 05:00:55 davem Exp $
+/*
  * ebus.h: PCI to Ebus pseudo driver software state.
  *
  * Copyright (C) 1997 Eddie C. Dost (ecd@skynet.be)
diff --git a/include/asm-sparc64/elf.h b/include/asm-sparc64/elf.h
index 11c8e68..0818a13 100644
--- a/include/asm-sparc64/elf.h
+++ b/include/asm-sparc64/elf.h
@@ -1,4 +1,3 @@
-/* $Id: elf.h,v 1.32 2002/02/09 19:49:31 davem Exp $ */
 #ifndef __ASM_SPARC64_ELF_H
 #define __ASM_SPARC64_ELF_H
 
diff --git a/include/asm-sparc64/envctrl.h b/include/asm-sparc64/envctrl.h
index 53a6653..a5668a0 100644
--- a/include/asm-sparc64/envctrl.h
+++ b/include/asm-sparc64/envctrl.h
@@ -1,4 +1,4 @@
-/* $Id: envctrl.h,v 1.3 2000/11/03 00:37:40 davem Exp $
+/*
  *
  * envctrl.h: Definitions for access to the i2c environment
  *            monitoring on Ultrasparc systems.
diff --git a/include/asm-sparc64/estate.h b/include/asm-sparc64/estate.h
index a719c3d..520c085 100644
--- a/include/asm-sparc64/estate.h
+++ b/include/asm-sparc64/estate.h
@@ -1,4 +1,3 @@
-/* $Id: estate.h,v 1.1 2001/03/28 10:56:34 davem Exp $ */
 #ifndef _SPARC64_ESTATE_H
 #define _SPARC64_ESTATE_H
 
diff --git a/include/asm-sparc64/fcntl.h b/include/asm-sparc64/fcntl.h
index 111f6b3..8a09ca7 100644
--- a/include/asm-sparc64/fcntl.h
+++ b/include/asm-sparc64/fcntl.h
@@ -1,4 +1,3 @@
-/* $Id: fcntl.h,v 1.12 2001/09/20 00:35:34 davem Exp $ */
 #ifndef _SPARC64_FCNTL_H
 #define _SPARC64_FCNTL_H
 
diff --git a/include/asm-sparc64/fhc.h b/include/asm-sparc64/fhc.h
index 9e7f1b0..ddffcdf 100644
--- a/include/asm-sparc64/fhc.h
+++ b/include/asm-sparc64/fhc.h
@@ -1,4 +1,4 @@
-/* $Id: fhc.h,v 1.5 1999/09/21 14:39:29 davem Exp $
+/*
  * fhc.h: Structures for central/fhc pseudo driver on Sunfire/Starfire/Wildfire.
  *
  * Copyright (C) 1997, 1999 David S. Miller (davem@redhat.com)
diff --git a/include/asm-sparc64/head.h b/include/asm-sparc64/head.h
index 67960a7..10e9dab 100644
--- a/include/asm-sparc64/head.h
+++ b/include/asm-sparc64/head.h
@@ -1,4 +1,3 @@
-/* $Id: head.h,v 1.30 1997/08/08 08:34:33 jj Exp $ */
 #ifndef _SPARC64_HEAD_H
 #define _SPARC64_HEAD_H
 
diff --git a/include/asm-sparc64/ide.h b/include/asm-sparc64/ide.h
index c5fdabe..1282676 100644
--- a/include/asm-sparc64/ide.h
+++ b/include/asm-sparc64/ide.h
@@ -1,4 +1,4 @@
-/* $Id: ide.h,v 1.21 2001/09/25 20:21:48 kanoj Exp $
+/*
  * ide.h: Ultra/PCI specific IDE glue.
  *
  * Copyright (C) 1997  David S. Miller (davem@caip.rutgers.edu)
diff --git a/include/asm-sparc64/idprom.h b/include/asm-sparc64/idprom.h
index 77fbf98..a363fa0 100644
--- a/include/asm-sparc64/idprom.h
+++ b/include/asm-sparc64/idprom.h
@@ -1,4 +1,4 @@
-/* $Id: idprom.h,v 1.2 1997/04/04 00:50:16 davem Exp $
+/*
  * idprom.h: Macros and defines for idprom routines
  *
  * Copyright (C) 1996 David S. Miller (davem@caip.rutgers.edu)
diff --git a/include/asm-sparc64/ioctl.h b/include/asm-sparc64/ioctl.h
index 253d0b5..d634c21 100644
--- a/include/asm-sparc64/ioctl.h
+++ b/include/asm-sparc64/ioctl.h
@@ -1,4 +1,3 @@
-/* $Id: ioctl.h,v 1.2 1998/10/15 05:40:38 jj Exp $ */
 #ifndef _SPARC64_IOCTL_H
 #define _SPARC64_IOCTL_H
 
diff --git a/include/asm-sparc64/ioctls.h b/include/asm-sparc64/ioctls.h
index c1be406..94d1b75 100644
--- a/include/asm-sparc64/ioctls.h
+++ b/include/asm-sparc64/ioctls.h
@@ -1,4 +1,3 @@
-/* $Id: ioctls.h,v 1.7 1998/02/23 02:49:41 davem Exp $ */
 #ifndef _ASM_SPARC64_IOCTLS_H
 #define _ASM_SPARC64_IOCTLS_H
 
diff --git a/include/asm-sparc64/lsu.h b/include/asm-sparc64/lsu.h
index 79f1098..7190f8d 100644
--- a/include/asm-sparc64/lsu.h
+++ b/include/asm-sparc64/lsu.h
@@ -1,4 +1,3 @@
-/* $Id: lsu.h,v 1.2 1997/04/04 00:50:22 davem Exp $ */
 #ifndef _SPARC64_LSU_H
 #define _SPARC64_LSU_H
 
diff --git a/include/asm-sparc64/mman.h b/include/asm-sparc64/mman.h
index 625be4d..d2ae67c 100644
--- a/include/asm-sparc64/mman.h
+++ b/include/asm-sparc64/mman.h
@@ -1,4 +1,3 @@
-/* $Id: mman.h,v 1.2 2000/03/15 02:44:26 davem Exp $ */
 #ifndef __SPARC64_MMAN_H__
 #define __SPARC64_MMAN_H__
 
diff --git a/include/asm-sparc64/mmu_context.h b/include/asm-sparc64/mmu_context.h
index 9fc225e..5693ab4 100644
--- a/include/asm-sparc64/mmu_context.h
+++ b/include/asm-sparc64/mmu_context.h
@@ -1,4 +1,3 @@
-/* $Id: mmu_context.h,v 1.54 2002/02/09 19:49:31 davem Exp $ */
 #ifndef __SPARC64_MMU_CONTEXT_H
 #define __SPARC64_MMU_CONTEXT_H
 
diff --git a/include/asm-sparc64/namei.h b/include/asm-sparc64/namei.h
index 275161f..cbc1b4c 100644
--- a/include/asm-sparc64/namei.h
+++ b/include/asm-sparc64/namei.h
@@ -1,4 +1,4 @@
-/* $Id: namei.h,v 1.17 2000/04/13 00:55:54 davem Exp $
+/*
  * linux/include/asm-sparc64/namei.h
  *
  * Routines to handle famous /usr/gnemul/s*.
diff --git a/include/asm-sparc64/openprom.h b/include/asm-sparc64/openprom.h
index 26ec046..b69e4a8 100644
--- a/include/asm-sparc64/openprom.h
+++ b/include/asm-sparc64/openprom.h
@@ -1,4 +1,3 @@
-/* $Id: openprom.h,v 1.9 2001/03/16 10:22:02 davem Exp $ */
 #ifndef __SPARC64_OPENPROM_H
 #define __SPARC64_OPENPROM_H
 
diff --git a/include/asm-sparc64/page.h b/include/asm-sparc64/page.h
index 618117d..93f0881 100644
--- a/include/asm-sparc64/page.h
+++ b/include/asm-sparc64/page.h
@@ -1,5 +1,3 @@
-/* $Id: page.h,v 1.39 2002/02/09 19:49:31 davem Exp $ */
-
 #ifndef _SPARC64_PAGE_H
 #define _SPARC64_PAGE_H
 
diff --git a/include/asm-sparc64/pgalloc.h b/include/asm-sparc64/pgalloc.h
index 3ee2d40..326de10 100644
--- a/include/asm-sparc64/pgalloc.h
+++ b/include/asm-sparc64/pgalloc.h
@@ -1,4 +1,3 @@
-/* $Id: pgalloc.h,v 1.30 2001/12/21 04:56:17 davem Exp $ */
 #ifndef _SPARC64_PGALLOC_H
 #define _SPARC64_PGALLOC_H
 
diff --git a/include/asm-sparc64/pgtable.h b/include/asm-sparc64/pgtable.h
index 0e200e7..b870177 100644
--- a/include/asm-sparc64/pgtable.h
+++ b/include/asm-sparc64/pgtable.h
@@ -1,4 +1,4 @@
-/* $Id: pgtable.h,v 1.156 2002/02/09 19:49:31 davem Exp $
+/*
  * pgtable.h: SpitFire page table operations.
  *
  * Copyright 1996,1997 David S. Miller (davem@caip.rutgers.edu)
diff --git a/include/asm-sparc64/pil.h b/include/asm-sparc64/pil.h
index 2f5d126..eaac842 100644
--- a/include/asm-sparc64/pil.h
+++ b/include/asm-sparc64/pil.h
@@ -1,4 +1,3 @@
-/* $Id: pil.h,v 1.1 2002/01/23 11:27:36 davem Exp $ */
 #ifndef _SPARC64_PIL_H
 #define _SPARC64_PIL_H
 
diff --git a/include/asm-sparc64/processor.h b/include/asm-sparc64/processor.h
index 885b6a1..26b4e52 100644
--- a/include/asm-sparc64/processor.h
+++ b/include/asm-sparc64/processor.h
@@ -1,4 +1,4 @@
-/* $Id: processor.h,v 1.83 2002/02/10 06:04:33 davem Exp $
+/*
  * include/asm-sparc64/processor.h
  *
  * Copyright (C) 1996 David S. Miller (davem@caip.rutgers.edu)
diff --git a/include/asm-sparc64/psrcompat.h b/include/asm-sparc64/psrcompat.h
index 3614ca0..44b6327 100644
--- a/include/asm-sparc64/psrcompat.h
+++ b/include/asm-sparc64/psrcompat.h
@@ -1,4 +1,3 @@
-/* $Id: psrcompat.h,v 1.5 1998/10/06 09:28:39 jj Exp $ */
 #ifndef _SPARC64_PSRCOMPAT_H
 #define _SPARC64_PSRCOMPAT_H
 
diff --git a/include/asm-sparc64/pstate.h b/include/asm-sparc64/pstate.h
index 949aeba..a26a537 100644
--- a/include/asm-sparc64/pstate.h
+++ b/include/asm-sparc64/pstate.h
@@ -1,4 +1,3 @@
-/* $Id: pstate.h,v 1.6 1997/06/25 07:39:45 jj Exp $ */
 #ifndef _SPARC64_PSTATE_H
 #define _SPARC64_PSTATE_H
 
diff --git a/include/asm-sparc64/reg.h b/include/asm-sparc64/reg.h
index fc68f90..77aa480 100644
--- a/include/asm-sparc64/reg.h
+++ b/include/asm-sparc64/reg.h
@@ -1,4 +1,4 @@
-/* $Id: reg.h,v 1.6 1999/09/06 08:22:10 jj Exp $
+/*
  * linux/asm-sparc64/reg.h
  * Layout of the registers as expected by gdb on the Sparc
  * we should replace the user.h definitions with those in
diff --git a/include/asm-sparc64/resource.h b/include/asm-sparc64/resource.h
index aa46979..4f08fb5 100644
--- a/include/asm-sparc64/resource.h
+++ b/include/asm-sparc64/resource.h
@@ -1,4 +1,4 @@
-/* $Id: resource.h,v 1.8 2000/09/23 02:09:21 davem Exp $
+/*
  * resource.h: Resource definitions.
  *
  * Copyright (C) 1996 David S. Miller (davem@caip.rutgers.edu)
diff --git a/include/asm-sparc64/rtc.h b/include/asm-sparc64/rtc.h
index cb17334..f9ecb1f 100644
--- a/include/asm-sparc64/rtc.h
+++ b/include/asm-sparc64/rtc.h
@@ -1,5 +1,4 @@
-/* $Id: rtc.h,v 1.1 1996/12/26 14:22:35 davem Exp $
- *
+/*
  * rtc.h: Definitions for access to the Mostek real time clock
  *
  * Copyright (C) 1996 Thomas K. Dyas (tdyas@eden.rutgers.edu)
diff --git a/include/asm-sparc64/rwsem.h b/include/asm-sparc64/rwsem.h
index 1294b7c..1dc129a 100644
--- a/include/asm-sparc64/rwsem.h
+++ b/include/asm-sparc64/rwsem.h
@@ -1,4 +1,4 @@
-/* $Id: rwsem.h,v 1.5 2001/11/18 00:12:56 davem Exp $
+/*
  * rwsem.h: R/W semaphores implemented using CAS
  *
  * Written by David S. Miller (davem@redhat.com), 2001.
diff --git a/include/asm-sparc64/scatterlist.h b/include/asm-sparc64/scatterlist.h
index 6df23f0..81bd058 100644
--- a/include/asm-sparc64/scatterlist.h
+++ b/include/asm-sparc64/scatterlist.h
@@ -1,4 +1,3 @@
-/* $Id: scatterlist.h,v 1.11 2001/12/17 07:05:15 davem Exp $ */
 #ifndef _SPARC64_SCATTERLIST_H
 #define _SPARC64_SCATTERLIST_H
 
diff --git a/include/asm-sparc64/shmparam.h b/include/asm-sparc64/shmparam.h
index 8c66fde..1ed0d67 100644
--- a/include/asm-sparc64/shmparam.h
+++ b/include/asm-sparc64/shmparam.h
@@ -1,4 +1,3 @@
-/* $Id: shmparam.h,v 1.5 2001/09/24 21:17:57 kanoj Exp $ */
 #ifndef _ASMSPARC64_SHMPARAM_H
 #define _ASMSPARC64_SHMPARAM_H
 
diff --git a/include/asm-sparc64/sigcontext.h b/include/asm-sparc64/sigcontext.h
index d807337..1c868d6 100644
--- a/include/asm-sparc64/sigcontext.h
+++ b/include/asm-sparc64/sigcontext.h
@@ -1,4 +1,3 @@
-/* $Id: sigcontext.h,v 1.12 1999/09/06 08:22:09 jj Exp $ */
 #ifndef __SPARC64_SIGCONTEXT_H
 #define __SPARC64_SIGCONTEXT_H
 
diff --git a/include/asm-sparc64/signal.h b/include/asm-sparc64/signal.h
index c49f32d..2a7c793 100644
--- a/include/asm-sparc64/signal.h
+++ b/include/asm-sparc64/signal.h
@@ -1,4 +1,3 @@
-/* $Id: signal.h,v 1.9 1999/09/06 08:22:11 jj Exp $ */
 #ifndef _ASMSPARC64_SIGNAL_H
 #define _ASMSPARC64_SIGNAL_H
 
diff --git a/include/asm-sparc64/socket.h b/include/asm-sparc64/socket.h
index 8cf071f..5af688f 100644
--- a/include/asm-sparc64/socket.h
+++ b/include/asm-sparc64/socket.h
@@ -1,4 +1,3 @@
-/* $Id: socket.h,v 1.10 2001/06/13 16:25:03 davem Exp $ */
 #ifndef _ASM_SOCKET_H
 #define _ASM_SOCKET_H
 
diff --git a/include/asm-sparc64/starfire.h b/include/asm-sparc64/starfire.h
index 48b50b5..07bafd3 100644
--- a/include/asm-sparc64/starfire.h
+++ b/include/asm-sparc64/starfire.h
@@ -1,4 +1,4 @@
-/* $Id: starfire.h,v 1.2 2001/07/04 00:18:18 davem Exp $
+/*
  * starfire.h: Group all starfire specific code together.
  *
  * Copyright (C) 2000 Anton Blanchard (anton@samba.org)
diff --git a/include/asm-sparc64/stat.h b/include/asm-sparc64/stat.h
index 128c27e..9650fde 100644
--- a/include/asm-sparc64/stat.h
+++ b/include/asm-sparc64/stat.h
@@ -1,4 +1,3 @@
-/* $Id: stat.h,v 1.7 2000/08/04 05:35:55 davem Exp $ */
 #ifndef _SPARC64_STAT_H
 #define _SPARC64_STAT_H
 
diff --git a/include/asm-sparc64/statfs.h b/include/asm-sparc64/statfs.h
index 185b6c4..79b3c89 100644
--- a/include/asm-sparc64/statfs.h
+++ b/include/asm-sparc64/statfs.h
@@ -1,4 +1,3 @@
-/* $Id: statfs.h,v 1.2 1997/04/14 17:05:22 jj Exp $ */
 #ifndef _SPARC64_STATFS_H
 #define _SPARC64_STATFS_H
 
diff --git a/include/asm-sparc64/string.h b/include/asm-sparc64/string.h
index c7d8862..43161f2 100644
--- a/include/asm-sparc64/string.h
+++ b/include/asm-sparc64/string.h
@@ -1,4 +1,4 @@
-/* $Id: string.h,v 1.20 2001/09/27 04:36:24 kanoj Exp $
+/*
  * string.h: External definitions for optimized assembly string
  *           routines for the Linux Kernel.
  *
diff --git a/include/asm-sparc64/sunbpp.h b/include/asm-sparc64/sunbpp.h
index b441cc9..8e171b7 100644
--- a/include/asm-sparc64/sunbpp.h
+++ b/include/asm-sparc64/sunbpp.h
@@ -1,4 +1,4 @@
-/* $Id: sunbpp.h,v 1.1 1999/08/13 06:21:44 shadow Exp $
+/*
  * include/asm-sparc64/sunbpp.h
  */
 
diff --git a/include/asm-sparc64/termios.h b/include/asm-sparc64/termios.h
index cacbea1..1f5dab2 100644
--- a/include/asm-sparc64/termios.h
+++ b/include/asm-sparc64/termios.h
@@ -1,4 +1,3 @@
-/* $Id: termios.h,v 1.11 2001/06/01 08:12:11 davem Exp $ */
 #ifndef _SPARC64_TERMIOS_H
 #define _SPARC64_TERMIOS_H
 
diff --git a/include/asm-sparc64/ttable.h b/include/asm-sparc64/ttable.h
index 52d67d3..0ba1995 100644
--- a/include/asm-sparc64/ttable.h
+++ b/include/asm-sparc64/ttable.h
@@ -1,4 +1,3 @@
-/* $Id: ttable.h,v 1.18 2002/02/09 19:49:32 davem Exp $ */
 #ifndef _SPARC64_TTABLE_H
 #define _SPARC64_TTABLE_H
 
diff --git a/include/asm-sparc64/types.h b/include/asm-sparc64/types.h
index 5dbe04f..b27ccc8 100644
--- a/include/asm-sparc64/types.h
+++ b/include/asm-sparc64/types.h
@@ -1,4 +1,3 @@
-/* $Id: types.h,v 1.4 2001/10/09 02:24:35 davem Exp $ */
 #ifndef _SPARC64_TYPES_H
 #define _SPARC64_TYPES_H
 
diff --git a/include/asm-sparc64/uaccess.h b/include/asm-sparc64/uaccess.h
index d8547b8..5fcbaf6 100644
--- a/include/asm-sparc64/uaccess.h
+++ b/include/asm-sparc64/uaccess.h
@@ -1,4 +1,3 @@
-/* $Id: uaccess.h,v 1.35 2002/02/09 19:49:31 davem Exp $ */
 #ifndef _ASM_UACCESS_H
 #define _ASM_UACCESS_H
 
diff --git a/include/asm-sparc64/uctx.h b/include/asm-sparc64/uctx.h
index 6eaf16e..dc937c7 100644
--- a/include/asm-sparc64/uctx.h
+++ b/include/asm-sparc64/uctx.h
@@ -1,4 +1,4 @@
-/* $Id: uctx.h,v 1.1 1997/06/18 16:51:58 davem Exp $
+/*
  * uctx.h: Sparc64 {set,get}context() register state layouts.
  *
  * Copyright (C) 1997 David S. Miller (davem@caip.rutgers.edu)
diff --git a/include/asm-sparc64/utrap.h b/include/asm-sparc64/utrap.h
index 81b0ebf..e49e5c4 100644
--- a/include/asm-sparc64/utrap.h
+++ b/include/asm-sparc64/utrap.h
@@ -1,4 +1,4 @@
-/* $Id: utrap.h,v 1.1 1997/10/14 16:21:31 jj Exp $
+/*
  * include/asm-sparc64/utrap.h
  *
  * Copyright (C) 1997 Jakub Jelinek (jj@sunsite.mff.cuni.cz)
diff --git a/include/asm-sparc64/watchdog.h b/include/asm-sparc64/watchdog.h
index 4d5b03b..5baf2d3 100644
--- a/include/asm-sparc64/watchdog.h
+++ b/include/asm-sparc64/watchdog.h
@@ -1,4 +1,4 @@
-/* $Id: watchdog.h,v 1.1 2001/01/18 04:47:44 davem Exp $
+/*
  *
  * watchdog - Driver interface for the hardware watchdog timers
  * present on Sun Microsystems boardsets

