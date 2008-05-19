Return-Path: <linux-kernel-owner+w=401wt.eu-S1764519AbYESWC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764519AbYESWC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764593AbYESWBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:01:41 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:42217 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756183AbYESWBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:01:40 -0400
Date: Tue, 20 May 2008 00:59:35 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] sound/oss/: remove CVS keywords
Message-ID: <20080519215935.GW17716@cs181133002.pp.htv.fi>
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

 sound/oss/msnd.c          |    2 --
 sound/oss/msnd.h          |    2 --
 sound/oss/msnd_classic.h  |    2 --
 sound/oss/msnd_pinnacle.c |    5 -----
 sound/oss/msnd_pinnacle.h |    2 --
 5 files changed, 13 deletions(-)

3e09e1037df3edf6fe54ac9ee8ad6be14d2474f4 diff --git a/sound/oss/msnd.c b/sound/oss/msnd.c
index ba38d62..e4282d9 100644
--- a/sound/oss/msnd.c
+++ b/sound/oss/msnd.c
@@ -20,8 +20,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  *
- * $Id: msnd.c,v 1.17 1999/03/21 16:50:09 andrewtv Exp $
- *
  ********************************************************************/
 
 #include <linux/module.h>
diff --git a/sound/oss/msnd.h b/sound/oss/msnd.h
index d0ca582..61b3955 100644
--- a/sound/oss/msnd.h
+++ b/sound/oss/msnd.h
@@ -24,8 +24,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  *
- * $Id: msnd.h,v 1.36 1999/03/21 17:05:42 andrewtv Exp $
- *
  ********************************************************************/
 #ifndef __MSND_H
 #define __MSND_H
diff --git a/sound/oss/msnd_classic.h b/sound/oss/msnd_classic.h
index 7ffea52..1a17dde 100644
--- a/sound/oss/msnd_classic.h
+++ b/sound/oss/msnd_classic.h
@@ -24,8 +24,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  * 
- * $Id: msnd_classic.h,v 1.10 1999/03/21 17:36:09 andrewtv Exp $
- *
  ********************************************************************/
 #ifndef __MSND_CLASSIC_H
 #define __MSND_CLASSIC_H
diff --git a/sound/oss/msnd_pinnacle.c b/sound/oss/msnd_pinnacle.c
index f1f49eb..bf27e00 100644
--- a/sound/oss/msnd_pinnacle.c
+++ b/sound/oss/msnd_pinnacle.c
@@ -29,13 +29,8 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  *
- * $Id: msnd_pinnacle.c,v 1.8 2000/12/30 00:33:21 sycamore Exp $
- *
  * 12-3-2000  Modified IO port validation  Steve Sycamore
  *
- *
- * $$$: msnd_pinnacle.c,v 1.75 1999/03/21 16:50:09 andrewtv $$$ $
- *
  ********************************************************************/
 
 #include <linux/kernel.h>
diff --git a/sound/oss/msnd_pinnacle.h b/sound/oss/msnd_pinnacle.h
index cce9114..c18d66c 100644
--- a/sound/oss/msnd_pinnacle.h
+++ b/sound/oss/msnd_pinnacle.h
@@ -24,8 +24,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  *
- * $Id: msnd_pinnacle.h,v 1.11 1999/03/21 17:36:09 andrewtv Exp $
- *
  ********************************************************************/
 #ifndef __MSND_PINNACLE_H
 #define __MSND_PINNACLE_H

