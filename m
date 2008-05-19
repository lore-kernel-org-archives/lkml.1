Return-Path: <linux-kernel-owner+w=401wt.eu-S1758547AbYESWGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547AbYESWGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbYESWEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:04:47 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:45020 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761210AbYESWEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:04:45 -0400
Date: Tue, 20 May 2008 01:02:40 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-pcmcia@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] pcmcia: remove CVS keywords
Message-ID: <20080519220240.GD17716@cs181133002.pp.htv.fi>
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

 drivers/pcmcia/hd64465_ss.c |    2 --
 drivers/pcmcia/i82092.c     |    2 --
 drivers/pcmcia/i82092aa.h   |    2 --
 3 files changed, 6 deletions(-)

c13f3943a1ca0edb90019a5e003e56664043fcb8 diff --git a/drivers/pcmcia/hd64465_ss.c b/drivers/pcmcia/hd64465_ss.c
index f2e810f..6045e4b 100644
--- a/drivers/pcmcia/hd64465_ss.c
+++ b/drivers/pcmcia/hd64465_ss.c
@@ -1,6 +1,4 @@
 /*
- * $Id: hd64465_ss.c,v 1.7 2003/07/06 14:42:50 lethal Exp $
- *
  * Device driver for the PCMCIA controller module of the
  * Hitachi HD64465 handheld companion chip.
  *
diff --git a/drivers/pcmcia/i82092.c b/drivers/pcmcia/i82092.c
index e136186..46561fa 100644
--- a/drivers/pcmcia/i82092.c
+++ b/drivers/pcmcia/i82092.c
@@ -5,8 +5,6 @@
  *
  * Author: Arjan Van De Ven <arjanv@redhat.com>
  * Loosly based on i82365.c from the pcmcia-cs package
- *
- * $Id: i82092aa.c,v 1.2 2001/10/23 14:43:34 arjanv Exp $
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/pcmcia/i82092aa.h b/drivers/pcmcia/i82092aa.h
index b0d4533..8836d39 100644
--- a/drivers/pcmcia/i82092aa.h
+++ b/drivers/pcmcia/i82092aa.h
@@ -3,8 +3,6 @@
 
 #include <linux/interrupt.h>
 
-/* $Id: i82092aa.h,v 1.1.1.1 2001/09/19 14:53:15 dwmw2 Exp $ */
-
 /* Debuging defines */
 #ifdef NOTRACE
 #define enter(x)   printk("Enter: %s, %s line %i\n",x,__FILE__,__LINE__)


