Return-Path: <linux-kernel-owner+w=401wt.eu-S1764246AbYESV7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764246AbYESV7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 17:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764447AbYESV7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 17:59:06 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:39874 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757489AbYESV7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 17:59:04 -0400
Date: Tue, 20 May 2008 00:56:58 +0300
From: Adrian Bunk <bunk@kernel.org>
To: chas@cmf.nrl.navy.mil, jgarzik@pobox.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/atm/: remove CVS keywords
Message-ID: <20080519215658.GO17716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes CVS keywords that weren't updated for a long time.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/atm/fore200e.h           |    1 -
 drivers/atm/fore200e_mkfirm.c    |    2 --
 drivers/atm/he.h                 |    2 --
 drivers/atm/idt77252.c           |    7 -------
 drivers/atm/idt77252.h           |    4 ----
 drivers/atm/nicstarmac.copyright |    2 +-
 6 files changed, 1 insertion(+), 17 deletions(-)

01e09763a7c570f81f7fbae1f534c9c145fb1a7b diff --git a/drivers/atm/fore200e.h b/drivers/atm/fore200e.h
index 183841c..8dd4aa7 100644
--- a/drivers/atm/fore200e.h
+++ b/drivers/atm/fore200e.h
@@ -1,4 +1,3 @@
-/* $Id: fore200e.h,v 1.4 2000/04/14 10:10:34 davem Exp $ */
 #ifndef _FORE200E_H
 #define _FORE200E_H
 
diff --git a/drivers/atm/fore200e_mkfirm.c b/drivers/atm/fore200e_mkfirm.c
index 2ebe1a1..520e14b 100644
--- a/drivers/atm/fore200e_mkfirm.c
+++ b/drivers/atm/fore200e_mkfirm.c
@@ -1,6 +1,4 @@
 /*
-  $Id: fore200e_mkfirm.c,v 1.1 2000/02/21 16:04:32 davem Exp $
-
   mkfirm.c: generates a C readable file from a binary firmware image
 
   Christophe Lizzi (lizzi@{csti.fr, cnam.fr}), June 1999.
diff --git a/drivers/atm/he.h b/drivers/atm/he.h
index 1dc2775..fe6cd15 100644
--- a/drivers/atm/he.h
+++ b/drivers/atm/he.h
@@ -1,5 +1,3 @@
-/* $Id: he.h,v 1.4 2003/05/06 22:48:00 chas Exp $ */
-
 /*
 
   he.h
diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index 28d77b5..3a504e9 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -1,8 +1,4 @@
 /******************************************************************* 
- * ident "$Id: idt77252.c,v 1.2 2001/11/11 08:13:54 ecd Exp $"
- *
- * $Author: ecd $
- * $Date: 2001/11/11 08:13:54 $
  *
  * Copyright (c) 2000 ATecoM GmbH 
  *
@@ -29,9 +25,6 @@
  * 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  *******************************************************************/
-static char const rcsid[] =
-"$Id: idt77252.c,v 1.2 2001/11/11 08:13:54 ecd Exp $";
-
 
 #include <linux/module.h>
 #include <linux/pci.h>
diff --git a/drivers/atm/idt77252.h b/drivers/atm/idt77252.h
index 6f2b4a5..e83eaf1 100644
--- a/drivers/atm/idt77252.h
+++ b/drivers/atm/idt77252.h
@@ -1,8 +1,4 @@
 /******************************************************************* 
- * ident "$Id: idt77252.h,v 1.2 2001/11/11 08:13:54 ecd Exp $"
- *
- * $Author: ecd $
- * $Date: 2001/11/11 08:13:54 $
  *
  * Copyright (c) 2000 ATecoM GmbH 
  *
diff --git a/drivers/atm/nicstarmac.copyright b/drivers/atm/nicstarmac.copyright
index 2e15b39..180531a 100644
--- a/drivers/atm/nicstarmac.copyright
+++ b/drivers/atm/nicstarmac.copyright
@@ -13,7 +13,7 @@
  *
  *   Modified to work with the IDT7721 nicstar -- AAL5 (tested) only.
  *
- * R. D. Rechenmacher <ron@fnal.gov>, Aug. 6, 1997 $Revision: 1.1 $ $Date: 1999/08/20 11:00:11 $
+ * R. D. Rechenmacher <ron@fnal.gov>, Aug. 6, 1997
  *
  * Linux driver for the IDT77201 NICStAR PCI ATM controller.
  * PHY component is expected to be 155 Mbps S/UNI-Lite or IDT 77155;

