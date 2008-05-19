Return-Path: <linux-kernel-owner+w=401wt.eu-S1765541AbYESWOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765541AbYESWOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762741AbYESWJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:09:01 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:42954 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765442AbYESWJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:09:00 -0400
Date: Tue, 20 May 2008 01:06:55 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Takashi Iwai <tiwai@suse.de>, perex@perex.cz
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] ALSA: remove CVS keywords
Message-ID: <20080519220655.GN17716@cs181133002.pp.htv.fi>
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

 include/sound/uda1341.h        |    2 --
 sound/arm/sa11xx-uda1341.c     |    2 --
 sound/i2c/l3/uda1341.c         |    2 --
 sound/pci/au88x0/au88x0_game.c |    2 --
 4 files changed, 8 deletions(-)

4c5df80d0f7646d6b9acc9f64ebc44910105e72a diff --git a/include/sound/uda1341.h b/include/sound/uda1341.h
index 2e564bf..110d5dc 100644
--- a/include/sound/uda1341.h
+++ b/include/sound/uda1341.h
@@ -15,8 +15,6 @@
  *                           features support
  */
 
-/* $Id: uda1341.h,v 1.8 2005/11/17 14:17:21 tiwai Exp $ */
-
 #define UDA1341_ALSA_NAME "snd-uda1341"
 
 /*
diff --git a/sound/arm/sa11xx-uda1341.c b/sound/arm/sa11xx-uda1341.c
index 0eff33c..faeddf3 100644
--- a/sound/arm/sa11xx-uda1341.c
+++ b/sound/arm/sa11xx-uda1341.c
@@ -21,8 +21,6 @@
  *                              merged HAL layer (patches from Brian)
  */
 
-/* $Id: sa11xx-uda1341.c,v 1.27 2005/12/07 09:13:42 cladisch Exp $ */
-
 /***************************************************************************************************
 *
 * To understand what Alsa Drivers should be doing look at "Writing an Alsa Driver" by Takashi Iwai
diff --git a/sound/i2c/l3/uda1341.c b/sound/i2c/l3/uda1341.c
index bfa5d2c..1f4942e 100644
--- a/sound/i2c/l3/uda1341.c
+++ b/sound/i2c/l3/uda1341.c
@@ -17,8 +17,6 @@
  * 2002-05-12   Tomas Kasparek  another code cleanup
  */
 
-/* $Id: uda1341.c,v 1.18 2005/11/17 14:17:21 tiwai Exp $ */
-
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/types.h>
diff --git a/sound/pci/au88x0/au88x0_game.c b/sound/pci/au88x0/au88x0_game.c
index bc212f4..e291aa5 100644
--- a/sound/pci/au88x0/au88x0_game.c
+++ b/sound/pci/au88x0/au88x0_game.c
@@ -1,6 +1,4 @@
 /*
- * $Id: au88x0_game.c,v 1.9 2003/09/22 03:51:28 mjander Exp $
- *
  *  Manuel Jander.
  *
  *  Based on the work of:
