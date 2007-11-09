Return-Path: <linux-kernel-owner+w=401wt.eu-S1751625AbXKIGCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625AbXKIGCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 01:02:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbXKIGCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 01:02:18 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:52837 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751076AbXKIGCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 01:02:16 -0500
Date: Fri, 9 Nov 2007 07:01:53 +0100
From: Adrian Bunk <bunk@kernel.org>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] BLK_DEV_IDECD help: remove outdated note
Message-ID: <20071109060153.GN26163@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

LILO version 16 was released on 26-02-1995 (sic), so telling people to 
not use older versions no longer has any value.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
b79ad8a00e9bc0008b42eafd5863d758109d0594 
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index d1e8df1..e445fe6 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -203,10 +203,6 @@ config BLK_DEV_IDECD
 	  CD-ROM drive, you can say N to all other CD-ROM options, but be sure
 	  to say Y or M to "ISO 9660 CD-ROM file system support".
 
-	  Note that older versions of LILO (LInux LOader) cannot properly deal
-	  with IDE/ATAPI CD-ROMs, so install LILO 16 or higher, available from
-	  <http://lilo.go.dyndns.org/>.
-
 	  To compile this driver as a module, choose M here: the
 	  module will be called ide-cd.
 

