Return-Path: <linux-kernel-owner+w=401wt.eu-S1763514AbYESWAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763514AbYESWAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764312AbYESWAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:00:18 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:39941 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764504AbYESWAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:00:16 -0400
Date: Tue, 20 May 2008 00:58:10 +0300
From: Adrian Bunk <bunk@kernel.org>
To: adaplas@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/video/: remove CVS keywords
Message-ID: <20080519215810.GR17716@cs181133002.pp.htv.fi>
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

 Documentation/fb/pvr2fb.txt     |    2 --
 Documentation/fb/sstfb.txt      |    1 -
 Documentation/fb/tgafb.txt      |    2 --
 drivers/video/aty/aty128fb.c    |    2 +-
 drivers/video/console/promcon.c |    2 +-
 drivers/video/g364fb.c          |    3 +--
 include/video/aty128.h          |    2 +-
 include/video/cvisionppc.h      |    2 --
 include/video/iga.h             |    2 +-
 include/video/newport.h         |    3 +--
 include/video/permedia2.h       |    2 --
 include/video/tgafb.h           |    2 --
 12 files changed, 6 insertions(+), 19 deletions(-)

7cb6ba00c2e5bea14d61650d12e16b8c931c224a diff --git a/Documentation/fb/pvr2fb.txt b/Documentation/fb/pvr2fb.txt
index 36bdeff..f983079 100644
--- a/Documentation/fb/pvr2fb.txt
+++ b/Documentation/fb/pvr2fb.txt
@@ -1,5 +1,3 @@
-$Id: pvr2fb.txt,v 1.1 2001/05/24 05:09:16 mrbrown Exp $
-
 What is pvr2fb?
 ===============
 
diff --git a/Documentation/fb/sstfb.txt b/Documentation/fb/sstfb.txt
index 550ca77..1e33864 100644
--- a/Documentation/fb/sstfb.txt
+++ b/Documentation/fb/sstfb.txt
@@ -170,5 +170,4 @@ ghoz.
 Ghozlane Toumi <gtoumi@laposte.net>
 
 
-$Date: 2002/05/09 20:11:45 $
 http://sstfb.sourceforge.net/README
diff --git a/Documentation/fb/tgafb.txt b/Documentation/fb/tgafb.txt
index 250083a..cdd435a 100644
--- a/Documentation/fb/tgafb.txt
+++ b/Documentation/fb/tgafb.txt
@@ -1,5 +1,3 @@
-$Id: tgafb.txt,v 1.1.2.2 2000/04/04 06:50:18 mato Exp $
-
 What is tgafb?
 ===============
 
diff --git a/drivers/video/aty/aty128fb.c b/drivers/video/aty/aty128fb.c
index 24ee96c..e21c92d 100644
--- a/drivers/video/aty/aty128fb.c
+++ b/drivers/video/aty/aty128fb.c
@@ -1,4 +1,4 @@
-/* $Id: aty128fb.c,v 1.1.1.1.36.1 1999/12/11 09:03:05 Exp $
+/*
  *  linux/drivers/video/aty128fb.c -- Frame buffer device for ATI Rage128
  *
  *  Copyright (C) 1999-2003, Brad Douglas <brad@neruo.com>
diff --git a/drivers/video/console/promcon.c b/drivers/video/console/promcon.c
index ae02e4e..597c0bc 100644
--- a/drivers/video/console/promcon.c
+++ b/drivers/video/console/promcon.c
@@ -1,4 +1,4 @@
-/* $Id: promcon.c,v 1.17 2000/07/26 23:02:52 davem Exp $
+/*
  * Console driver utilizing PROM sun terminal emulation
  *
  * Copyright (C) 1998  Eddie C. Dost  (ecd@skynet.be)
diff --git a/drivers/video/g364fb.c b/drivers/video/g364fb.c
index b7655c0..cb16361 100644
--- a/drivers/video/g364fb.c
+++ b/drivers/video/g364fb.c
@@ -1,5 +1,4 @@
-/* $Id: g364fb.c,v 1.3 1998/08/28 22:43:00 tsbogend Exp $
- *
+/*
  * linux/drivers/video/g364fb.c -- Mips Magnum frame buffer device
  *
  * (C) 1998 Thomas Bogendoerfer
diff --git a/include/video/aty128.h b/include/video/aty128.h
index 7079beb..122d121 100644
--- a/include/video/aty128.h
+++ b/include/video/aty128.h
@@ -1,4 +1,4 @@
-/*  $Id: aty128.h,v 1.1 1999/10/12 11:00:40 geert Exp $
+/*
  *  linux/drivers/video/aty128.h
  *  Register definitions for ATI Rage128 boards
  *
diff --git a/include/video/cvisionppc.h b/include/video/cvisionppc.h
index 11250ee..84c6cc9 100644
--- a/include/video/cvisionppc.h
+++ b/include/video/cvisionppc.h
@@ -4,8 +4,6 @@
  *
  * Copyright (c) 1998-1999 Ilario Nardinocchi (nardinoc@CS.UniBO.IT)
  * --------------------------------------------------------------------------
- * $Id: cvisionppc.h,v 1.8 1999/01/28 13:18:07 illo Exp $
- * --------------------------------------------------------------------------
  * This file is subject to the terms and conditions of the GNU General Public
  * License.  See the file COPYING in the main directory of this archive
  * for more details.
diff --git a/include/video/iga.h b/include/video/iga.h
index 5a48f16..12c7e27 100644
--- a/include/video/iga.h
+++ b/include/video/iga.h
@@ -1,4 +1,4 @@
-/* $Id: iga.h,v 1.2 1999/09/11 22:56:31 zaitcev Exp $
+/*
  * iga1682.h: Sparc/PCI iga1682 driver constants etc.
  *
  * Copyleft 1998 V. Roganov and G. Raiko
diff --git a/include/video/newport.h b/include/video/newport.h
index 1f5ebea..457cc09 100644
--- a/include/video/newport.h
+++ b/include/video/newport.h
@@ -1,5 +1,4 @@
-/* $Id: newport.h,v 1.5 1999/08/04 06:01:51 ulfc Exp $
- *
+/*
  * newport.h: Defines and register layout for NEWPORT graphics
  *            hardware.
  *
diff --git a/include/video/permedia2.h b/include/video/permedia2.h
index 9ce9adb..6bce040 100644
--- a/include/video/permedia2.h
+++ b/include/video/permedia2.h
@@ -2,8 +2,6 @@
  * Permedia2 framebuffer driver definitions.
  * Copyright (c) 1998-2000 Ilario Nardinocchi (nardinoc@CS.UniBO.IT)
  * --------------------------------------------------------------------------
- * $Id: pm2fb.h,v 1.26 2000/09/19 00:11:53 illo Exp $
- * --------------------------------------------------------------------------
  * This file is subject to the terms and conditions of the GNU General Public
  * License.  See the file COPYING in the main directory of this archive
  * for more details.
diff --git a/include/video/tgafb.h b/include/video/tgafb.h
index 7bc5e2c..d530a96 100644
--- a/include/video/tgafb.h
+++ b/include/video/tgafb.h
@@ -3,8 +3,6 @@
  *
  *  	Copyright (C) 1999,2000 Martin Lucina, Tom Zerucha
  *  
- *  $Id: tgafb.h,v 1.4.2.3 2000/04/04 06:44:56 mato Exp $
- *
  *  This file is subject to the terms and conditions of the GNU General Public
  *  License. See the file COPYING in the main directory of this archive for
  *  more details.

