Return-Path: <linux-kernel-owner+w=401wt.eu-S966420AbXHaV0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966420AbXHaV0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 17:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966403AbXHaVYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 17:24:50 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:25389 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966396AbXHaVYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 17:24:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=eNk++UQrNTyWYl4SVrnqVPmR1eakrtBEZR2blKnPFTooM6bJoVqOTchAxTFwwENrFC4On7opOeopzh2UTJ1cE4GEWluCjUdA5FkgsC7vfZjk8cSSaKaaopgh62L1z+bRqJ1lcwLLs1WKKORIK+qqv87KTVgFoaUpYAxU/JGDXRA=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: linux-doc@vger.kernel.org
Subject: [PATCH 5/5] Update Documentation/fb/00-INDEX - add new files, remove entries for deleted ones
Date: Fri, 31 Aug 2007 23:21:41 +0200
User-Agent: KMail/1.9.7
Cc: Rob Landley <rob@landley.net>, Randy Dunlap <rdunlap@xenotime.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200708312321.41347.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


An update to Documentation/fb/00-INDEX is long overdue.
This patch adds entries for new files in the directory 
and removes entries for files that no longer exist. The
files are now also sorted alphabetically.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 Documentation/fb/00-INDEX |   46 ++++++++++++++++++++++++++++++++++++--------
 1 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/Documentation/fb/00-INDEX b/Documentation/fb/00-INDEX
index 92e89ae..caabbd3 100644
--- a/Documentation/fb/00-INDEX
+++ b/Documentation/fb/00-INDEX
@@ -5,21 +5,49 @@ please mail me.
 
 00-INDEX
 	- this file
+arkfb.txt
+	- info on the fbdev driver for ARK Logic chips.
+aty128fb.txt
+	- info on the ATI Rage128 frame buffer driver.
+cirrusfb.txt
+	- info on the driver for Cirrus Logic chipsets.
+cyblafb/
+	- directory with documentation files related to the cyblafb driver.
+deferred_io.txt
+	- an introduction to deferred IO.
+fbcon.txt
+	- intro to and usage guide for the framebuffer console (fbcon).
 framebuffer.txt
-	- introduction to frame buffer devices
+	- introduction to frame buffer devices.
+imacfb.txt
+	- info on the generic EFI platform driver for Intel based Macs.
+intel810.txt
+	- documentation for the Intel 810/815 framebuffer driver.
+intelfb.txt
+	- docs for Intel 830M/845G/852GM/855GM/865G/915G/945G fb driver.
 internals.txt
-	- quick overview of frame buffer device internals
+	- quick overview of frame buffer device internals.
+matroxfb.txt
+	- info on the Matrox framebuffer driver for Alpha, Intel and PPC.
 modedb.txt
-	- info on the video mode database
-aty128fb.txt
-	- info on the ATI Rage128 frame buffer driver
-clgenfb.txt
-	- info on the Cirrus Logic frame buffer driver
+	- info on the video mode database.
 matroxfb.txt
-	- info on the Matrox frame buffer driver
+	- info on the Matrox frame buffer driver.
 pvr2fb.txt
-	- info on the PowerVR 2 frame buffer driver
+	- info on the PowerVR 2 frame buffer driver.
+pxafb.txt
+	- info on the driver for the PXA25x LCD controller.
+s3fb.txt
+	- info on the fbdev driver for S3 Trio/Virge chips.
+sa1100fb.txt
+	- information about the driver for the SA-1100 LCD controller.
+sisfb.txt
+	- info on the framebuffer device driver for various SiS chips.
+sstfb.txt
+	- info on the frame buffer driver for 3dfx' Voodoo Graphics boards.
 tgafb.txt
 	- info on the TGA (DECChip 21030) frame buffer driver
 vesafb.txt
 	- info on the VESA frame buffer device
+vt8623fb.txt
+	- info on the fb driver for the graphics core in VIA VT8623 chipsets.



