Return-Path: <linux-kernel-owner+w=401wt.eu-S1765012AbYESWEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765012AbYESWEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932104AbYESWD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:03:59 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:42309 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764349AbYESWD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:03:58 -0400
Date: Tue, 20 May 2008 01:01:52 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] parport: remove CVS keywords
Message-ID: <20080519220152.GA17716@cs181133002.pp.htv.fi>
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

