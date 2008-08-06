Return-Path: <linux-kernel-owner+w=401wt.eu-S1758040AbYHFVNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040AbYHFVNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 17:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756975AbYHFVME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 17:12:04 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:50251 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422812AbYHFVMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 17:12:00 -0400
Date: Thu, 7 Aug 2008 00:10:31 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] parport: remove CVS keywords
Message-ID: <20080806211031.GG1702@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes CVS keywords that weren't updated for a long time
from comments.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 20 May 2008

 drivers/parport/ieee1284.c |    2 +-
 drivers/parport/probe.c    |    2 +-
 drivers/parport/share.c    |    2 +-
 include/linux/parport.h    |    2 --
 4 files changed, 3 insertions(+), 5 deletions(-)

e6a73a87211cdfd9ffc9dbb55ba7b5d0ef4f37c2 diff --git a/drivers/parport/ieee1284.c b/drivers/parport/ieee1284.c
index 0338b09..c42d345 100644
--- a/drivers/parport/ieee1284.c
+++ b/drivers/parport/ieee1284.c
@@ -1,4 +1,4 @@
-/* $Id: parport_ieee1284.c,v 1.4 1997/10/19 21:37:21 philip Exp $
+/*
  * IEEE-1284 implementation for parport.
  *
  * Authors: Phil Blundell <philb@gnu.org>
diff --git a/drivers/parport/probe.c b/drivers/parport/probe.c
index cd565bb..0f65507 100644
--- a/drivers/parport/probe.c
+++ b/drivers/parport/probe.c
@@ -1,4 +1,4 @@
-/* $Id: parport_probe.c,v 1.1 1999/07/03 08:56:17 davem Exp $
+/*
  * Parallel port device probing code
  *
  * Authors:    Carsten Gross, carsten@sol.wohnheim.uni-ulm.de
diff --git a/drivers/parport/share.c b/drivers/parport/share.c
index a8a62bb..0ebca45 100644
--- a/drivers/parport/share.c
+++ b/drivers/parport/share.c
@@ -1,4 +1,4 @@
-/* $Id: parport_share.c,v 1.15 1998/01/11 12:06:17 philip Exp $
+/*
  * Parallel-port resource manager code.
  * 
  * Authors: David Campbell <campbell@tirian.che.curtin.edu.au>
diff --git a/include/linux/parport.h b/include/linux/parport.h
index dcb9e01..15538c6 100644
--- a/include/linux/parport.h
+++ b/include/linux/parport.h
@@ -1,5 +1,3 @@
-/* $Id: parport.h,v 1.1 1998/05/17 10:57:52 andrea Exp andrea $ */
-
 /*
  * Any part of this program may be used in documents licensed under
  * the GNU Free Documentation License, Version 1.1 or any later version

