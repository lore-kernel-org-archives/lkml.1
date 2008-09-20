Return-Path: <linux-kernel-owner+w=401wt.eu-S1753817AbYITKeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbYITKeu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 06:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbYITKel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 06:34:41 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:21982 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbYITKek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 06:34:40 -0400
Date: Sat, 20 Sep 2008 12:34:33 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] MAINTAINERS: Various fixes
Message-ID: <20080920123433.2955f2ad@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Normalize some S: entries to match the enumeration at the beginning
  of the file.
* Change one mailing list entry from S: to L:.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 MAINTAINERS |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- linux-2.6.27-rc6.orig/MAINTAINERS
+++ linux-2.6.27-rc6/MAINTAINERS
@@ -1359,7 +1359,7 @@ P:	Digi International, Inc
 M:	Eng.Linux@digi.com
 L:	Eng.Linux@digi.com
 W:	http://www.digi.com
-S:	Orphaned
+S:	Orphan
 
 DIRECTORY NOTIFICATION
 P:	Stephen Rothwell
@@ -1797,7 +1797,7 @@ FUTURE DOMAIN TMC-16x0 SCSI DRIVER (16-b
 P:	Rik Faith
 M:	faith@cs.unc.edu
 L:	linux-scsi@vger.kernel.org
-S:	Odd fixes (e.g., new signatures)
+S:	Odd Fixes (e.g., new signatures)
 
 GDT SCSI DISK ARRAY CONTROLLER DRIVER
 P:	Achim Leubner
@@ -1838,10 +1838,10 @@ S:	Maintained
 HARDWARE MONITORING
 L:	lm-sensors@lm-sensors.org
 W:	http://www.lm-sensors.org/
-S:	Orphaned
+S:	Orphan
 
 HARDWARE RANDOM NUMBER GENERATOR CORE
-S:	Orphaned
+S:	Orphan
 
 HARD DRIVE ACTIVE PROTECTION SYSTEM (HDAPS) DRIVER
 P:	Robert Love
@@ -2735,7 +2735,7 @@ S:	Maintained
 MEGARAID SCSI DRIVERS
 P:	Neela Syam Kolli
 M:	megaraidlinux@lsi.com
-S:	linux-scsi@vger.kernel.org
+L:	linux-scsi@vger.kernel.org
 W:	http://megaraid.lsilogic.com
 S:	Maintained
 
@@ -2853,7 +2853,7 @@ MULTIMEDIA CARD (MMC) ETC. OVER SPI
 P:	David Brownell
 M:	dbrownell@users.sourceforge.net
 L:	linux-kernel@vger.kernel.org
-S:	Odd fixes
+S:	Odd Fixes
 
 MULTISOUND SOUND DRIVER
 P:	Andrew Veliath
@@ -3925,7 +3925,7 @@ S:	Maintained
 
 STARMODE RADIO IP (STRIP) PROTOCOL DRIVER
 W:	http://mosquitonet.Stanford.EDU/strip.html
-S:	Unsupported ?
+S:	Orphan
 
 STRADIS MPEG-2 DECODER DRIVER
 P:	Nathan Laredo


-- 
Jean Delvare
