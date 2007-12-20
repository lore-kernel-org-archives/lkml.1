Return-Path: <linux-kernel-owner+w=401wt.eu-S1765033AbXLTWVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765033AbXLTWVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:21:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765308AbXLTWUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:20:12 -0500
Received: from baron.miniblade.com ([65.14.39.133]:28922 "EHLO coraid.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765400AbXLTWUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:20:09 -0500
From: "Ed L. Cashin" <ecashin@coraid.com>
To: linux-kernel@vger.kernel.org
Cc: "Ed L. Cashin" <ecashin@coraid.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 13/13] update copyright date
Date: Thu, 20 Dec 2007 17:16:01 -0500
Message-Id: <1198188961-25147-13-git-send-email-ecashin@coraid.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1198188961-25147-1-git-send-email-ecashin@coraid.com>
References: <1198188961-25147-1-git-send-email-ecashin@coraid.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the year in the copyright notices.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoe.h     |    2 +-
 drivers/block/aoe/aoeblk.c  |    2 +-
 drivers/block/aoe/aoechr.c  |    2 +-
 drivers/block/aoe/aoecmd.c  |    2 +-
 drivers/block/aoe/aoedev.c  |    2 +-
 drivers/block/aoe/aoemain.c |    2 +-
 drivers/block/aoe/aoenet.c  |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index 67ef4d7..280e71e 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -1,4 +1,4 @@
-/* Copyright (c) 2006 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2007 Coraid, Inc.  See COPYING for GPL terms. */
 #define VERSION "47"
 #define AOE_MAJOR 152
 #define DEVICE_NAME "aoe"
diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index 25c6760..0c39782 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2006 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2007 Coraid, Inc.  See COPYING for GPL terms. */
 /*
  * aoeblk.c
  * block device routines
diff --git a/drivers/block/aoe/aoechr.c b/drivers/block/aoe/aoechr.c
index 670bba6..ef49e4b 100644
--- a/drivers/block/aoe/aoechr.c
+++ b/drivers/block/aoe/aoechr.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2006 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2007 Coraid, Inc.  See COPYING for GPL terms. */
 /*
  * aoechr.c
  * AoE character device driver
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 1e37cf6..44beb17 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2006 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2007 Coraid, Inc.  See COPYING for GPL terms. */
 /*
  * aoecmd.c
  * Filesystem request handling methods
diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index 839a964..d146c4e 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2006 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2007 Coraid, Inc.  See COPYING for GPL terms. */
 /*
  * aoedev.c
  * AoE device utility functions; maintains device list.
diff --git a/drivers/block/aoe/aoemain.c b/drivers/block/aoe/aoemain.c
index a04b7d6..7b15a5e 100644
--- a/drivers/block/aoe/aoemain.c
+++ b/drivers/block/aoe/aoemain.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2006 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2007 Coraid, Inc.  See COPYING for GPL terms. */
 /*
  * aoemain.c
  * Module initialization routines, discover timer
diff --git a/drivers/block/aoe/aoenet.c b/drivers/block/aoe/aoenet.c
index ada4a06..8460ef7 100644
--- a/drivers/block/aoe/aoenet.c
+++ b/drivers/block/aoe/aoenet.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2006 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2007 Coraid, Inc.  See COPYING for GPL terms. */
 /*
  * aoenet.c
  * Ethernet portion of AoE driver
-- 
1.5.3.4

