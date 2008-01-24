Return-Path: <linux-kernel-owner+w=401wt.eu-S1760972AbYAZQGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760972AbYAZQGy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:06:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757423AbYAZP4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:56:51 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757393AbYAZP4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:56:49 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 47/52] [microblaze] headers simple files
Date: Thu, 24 Jan 2008 16:03:22 +0100
Message-Id: <e445f6b37baf09d6469a0ad4eba189a7ca7ef7c3.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <d4eec3db9f6e6e86994444b8035d5e41db3f085b.1201107832.git.monstr@monstr.eu>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
 <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
 <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu>
 <516d173b1789ea533431e8f5ad05751c6a353c88.1201107832.git.monstr@monstr.eu>
 <068508828aac6298b4cc65b0cd7b2737a61c466c.1201107832.git.monstr@monstr.eu>
 <010fc233f82a8f7a591c9f8315ae03f9951139aa.1201107832.git.monstr@monstr.eu>
 <68faaf69ea03196d4a56a263707355e7e7eb5c6a.1201107832.git.monstr@monstr.eu>
 <4b7d90fc1b9bcb3c0b1b308c6460390f7bdf3824.1201107832.git.monstr@monstr.eu>
 <eb28582e845efb4f2f26054630895f26fa69866e.1201107832.git.monstr@monstr.eu>
 <64e6e541db30cc4f1ee5cd85da4bdea6024f75b8.1201107832.git.monstr@monstr.eu>
 <90badb264d0e4ec49fdaa76842a5e5f259681299.1201107832.git.monstr@monstr.eu>
 <a013a2b7044186c64d55cdafc8c9b29bc73a7fc5.1201107832.git.monstr@monstr.eu>
 <60642f04ebcf9f76da50a1d40191755f258edcc5.1201107832.git.monstr@monstr.eu>
 <240998be1af3774635995fd19248f8b3a9e8a702.1201107832.git.monstr@monstr.eu>
 <3bcb9581bc512fdd0a124ac8322af9e2a8adc975.1201107832.git.monstr@monstr.eu>
 <db7f441df21cfe296a44744747b28f379e75fd49.1201107832.git.monstr@monstr.eu>
 <e6309af7cc6550ef5b399fc0902f1926f9e52e58.1201107832.git.monstr@monstr.eu>
 <2d11eef3abada1f41658a532a483c6121ded8054.1201107832.git.monstr@monstr.eu>
 <48db19662b808ab6f5455dd7f2116e6544c50e95.1201107832.git.monstr@monstr.eu>
 <7b0cfa6ae11749e20c941d0a4f03577141e022f8.1201107832.git.monstr@monstr.eu>
 <2f3db7ba4fe41cb9888adabf0e4e052d4da5c37c.1201107832.git.monstr@monstr.eu>
 <d67010417928d04766e6dd74820b12c249d61814.1201107832.git.monstr@monstr.eu>
 <37627293f081fa40f21234944ddb878d5e711740.1201107832.git.monstr@monstr.eu>
 <105791d33ea12564c70be0dd3fafef386f8e1b55.1201107832.git.monstr@monstr.eu>
 <b501d439bdfabddbdef5935db86b6f64c83d55c4.1201107832.git.monstr@monstr.eu>
 <43f77bd3045d72346eb39d3170de727050c835c1.1201107832.git.monstr@monstr.eu>
 <c09d54c49393bedbe4ca43df0e35cefa5fcc649c.1201107832.git.monstr@monstr.eu>
 <29ee870c02ea5d4c409644d7f0eb09cfbb1ec816.1201107832.git.monstr@monstr.eu>
 <99bfbc3fdb53003c11414681b2c73561d533c3ef.1201107832.git.monstr@monstr.eu>
 <1b21abdff6128297a902060b07a0c7ca6d8db633.1201107832.git.monstr@monstr.eu>
 <e173c10560cdf883ba3c7e639ca930f0627a2260.1201107832.git.monstr@monstr.eu>
 <155ee14d990137f7eb6fa76beee06c880c97e790.1201107832.git.monstr@monstr.eu>
 <34f2199d631406fbdf6b325a164e0d1899a3acb5.1201107832.git.monstr@monstr.eu>
 <14243bf49d44d1dbd6e377813f2635defcb82c4e.1201107832.git.monstr@monstr.eu>
 <01e493efdc1c8cb7ee0d5f8b7c73244e04680e71.1201107832.git.monstr@monstr.eu>
 <739e189a03021d2804f23d0774637a15038098bc.1201107832.git.monstr@monstr.eu>
 <d4eec3db9f6e6e86994444b8035d5e41db3f085b.1201107832.git.monstr@monstr.eu>
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/auxvec.h            |   14 ++++++++++++++
 include/asm-microblaze/cputime.h           |   16 ++++++++++++++++
 include/asm-microblaze/div64.h             |   16 ++++++++++++++++
 include/asm-microblaze/emergency-restart.h |   16 ++++++++++++++++
 include/asm-microblaze/errno.h             |   16 ++++++++++++++++
 include/asm-microblaze/futex.h             |   16 ++++++++++++++++
 include/asm-microblaze/kdebug.h            |   19 +++++++++++++++++++
 include/asm-microblaze/local.h             |   16 ++++++++++++++++
 include/asm-microblaze/mutex.h             |   16 ++++++++++++++++
 include/asm-microblaze/namei.h             |   24 ++++++++++++++++++++++++
 include/asm-microblaze/percpu.h            |   16 ++++++++++++++++
 include/asm-microblaze/resource.h          |   16 ++++++++++++++++
 include/asm-microblaze/user.h              |   18 ++++++++++++++++++
 13 files changed, 219 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/auxvec.h
 create mode 100644 include/asm-microblaze/cputime.h
 create mode 100644 include/asm-microblaze/div64.h
 create mode 100644 include/asm-microblaze/emergency-restart.h
 create mode 100644 include/asm-microblaze/errno.h
 create mode 100644 include/asm-microblaze/futex.h
 create mode 100644 include/asm-microblaze/kdebug.h
 create mode 100644 include/asm-microblaze/local.h
 create mode 100644 include/asm-microblaze/mutex.h
 create mode 100644 include/asm-microblaze/namei.h
 create mode 100644 include/asm-microblaze/percpu.h
 create mode 100644 include/asm-microblaze/resource.h
 create mode 100644 include/asm-microblaze/user.h

diff --git a/include/asm-microblaze/auxvec.h b/include/asm-microblaze/auxvec.h
new file mode 100644
index 0000000..4d55bac
--- /dev/null
+++ b/include/asm-microblaze/auxvec.h
@@ -0,0 +1,14 @@
+/*
+ * include/asm-microblaze/auxvec.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_AUXVEC_H
+#define _ASM_AUXVEC_H
+
+#endif /* _ASM_AUXVEC_H */
diff --git a/include/asm-microblaze/cputime.h b/include/asm-microblaze/cputime.h
new file mode 100644
index 0000000..e4f104d
--- /dev/null
+++ b/include/asm-microblaze/cputime.h
@@ -0,0 +1,16 @@
+/*
+ * include/asm-microblaze/cputime.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_CPUTIME_H
+#define _ASM_CPUTIME_H
+
+#include <asm-generic/cputime.h>
+
+#endif /* _ASM_CPUTIME_H */
diff --git a/include/asm-microblaze/div64.h b/include/asm-microblaze/div64.h
new file mode 100644
index 0000000..4de2a4a
--- /dev/null
+++ b/include/asm-microblaze/div64.h
@@ -0,0 +1,16 @@
+/*
+ * include/asm-microblaze/div64.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_DIV64_H
+#define _ASM_DIV64_H
+
+#include <asm-generic/div64.h>
+
+#endif /* _ASM_DIV64_H */
diff --git a/include/asm-microblaze/emergency-restart.h b/include/asm-microblaze/emergency-restart.h
new file mode 100644
index 0000000..fb8aae4
--- /dev/null
+++ b/include/asm-microblaze/emergency-restart.h
@@ -0,0 +1,16 @@
+/*
+ * include/asm-microblaze/emergency-restart.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_EMERGENCY_RESTART_H
+#define _ASM_EMERGENCY_RESTART_H
+
+#include <asm-generic/emergency-restart.h>
+
+#endif /* _ASM_EMERGENCY_RESTART_H */
diff --git a/include/asm-microblaze/errno.h b/include/asm-microblaze/errno.h
new file mode 100644
index 0000000..42831c2
--- /dev/null
+++ b/include/asm-microblaze/errno.h
@@ -0,0 +1,16 @@
+/*
+ * include/asm-microblaze/errno.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_ERRNO_H
+#define _ASM_ERRNO_H
+
+#include <asm-generic/errno.h>
+
+#endif /* _ASM_ERRNO_H */
diff --git a/include/asm-microblaze/futex.h b/include/asm-microblaze/futex.h
new file mode 100644
index 0000000..4f47480
--- /dev/null
+++ b/include/asm-microblaze/futex.h
@@ -0,0 +1,16 @@
+/*
+ * include/asm-microblaze/futex.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_FUTEX_H
+#define _ASM_FUTEX_H
+
+#include <asm-generic/futex.h>
+
+#endif /* _ASM_FUTEX_H */
diff --git a/include/asm-microblaze/kdebug.h b/include/asm-microblaze/kdebug.h
new file mode 100644
index 0000000..2b809ae
--- /dev/null
+++ b/include/asm-microblaze/kdebug.h
@@ -0,0 +1,19 @@
+/*
+ * include/asm-microblaze/kdebug.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2007 Michal Simek <monstr@monstr.eu>
+ */
+
+#ifndef _ASM_KDEBUG_H
+#define _ASM_KDEBUG_H
+
+#include <asm-generic/kdebug.h>
+
+#endif /* _ASM_KDEBUG_H */
+
+
+
diff --git a/include/asm-microblaze/local.h b/include/asm-microblaze/local.h
new file mode 100644
index 0000000..f74d600
--- /dev/null
+++ b/include/asm-microblaze/local.h
@@ -0,0 +1,16 @@
+/*
+ * include/asm-microblaze/local.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_LOCAL_H
+#define _ASM_LOCAL_H
+
+#include <asm-generic/local.h>
+
+#endif /* _ASM_LOCAL_H */
diff --git a/include/asm-microblaze/mutex.h b/include/asm-microblaze/mutex.h
new file mode 100644
index 0000000..cf51475
--- /dev/null
+++ b/include/asm-microblaze/mutex.h
@@ -0,0 +1,16 @@
+/*
+ * include/asm-microblaze/mutex.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MUTEX_H
+#define _ASM_MUTEX_H
+
+#include <asm-generic/mutex-dec.h>
+
+#endif /* _ASM_MUTEX_H */
diff --git a/include/asm-microblaze/namei.h b/include/asm-microblaze/namei.h
new file mode 100644
index 0000000..9012c00
--- /dev/null
+++ b/include/asm-microblaze/namei.h
@@ -0,0 +1,24 @@
+/*
+ * include/asm-microblaze/namei.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_NAMEI_H
+#define _ASM_NAMEI_H
+
+#ifdef __KERNEL__
+
+/* This dummy routine maybe changed to something useful
+ * for /usr/gnemul/ emulation stuff.
+ * Look at asm-sparc/namei.h for details.
+ */
+#define __emul_prefix() NULL
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_NAMEI_H */
diff --git a/include/asm-microblaze/percpu.h b/include/asm-microblaze/percpu.h
new file mode 100644
index 0000000..7f7a170
--- /dev/null
+++ b/include/asm-microblaze/percpu.h
@@ -0,0 +1,16 @@
+/*
+ * include/asm-microblaze/percpu.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_PERCPU_H
+#define _ASM_PERCPU_H
+
+#include <asm-generic/percpu.h>
+
+#endif /* _ASM_PERCPU_H */
diff --git a/include/asm-microblaze/resource.h b/include/asm-microblaze/resource.h
new file mode 100644
index 0000000..066a4ce
--- /dev/null
+++ b/include/asm-microblaze/resource.h
@@ -0,0 +1,16 @@
+/*
+ * include/asm-microblaze/resource.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_RESOURCE_H
+#define _ASM_RESOURCE_H
+
+#include <asm-generic/resource.h>
+
+#endif /* _ASM_RESOURCE_H */
diff --git a/include/asm-microblaze/user.h b/include/asm-microblaze/user.h
new file mode 100644
index 0000000..bed2e1b
--- /dev/null
+++ b/include/asm-microblaze/user.h
@@ -0,0 +1,18 @@
+/*
+ * include/asm-microblaze/user.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * Authors:
+ * Yasushi SHOJI <yashi@atmark-techno.com>
+ * Tetsuya OHKAWA <tetsuya@atmark-techno.com>
+ */
+
+#ifndef _ASM_USER_H
+#define _ASM_USER_H
+
+#endif /* _ASM_USER_H */
-- 
1.5.4.rc4.14.g6fc74

