Return-Path: <linux-kernel-owner+w=401wt.eu-S1751906AbXDOKe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbXDOKe3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 06:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbXDOKe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 06:34:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:15607 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbXDOKeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 06:34:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=hjBT0CdUw5O1P7/y+Jha8cwvspsPxh0mLRzmxDa2JUBL9sIYHzE4T0eqkpDKWVT4JdC2h3SnETBNJIkOUlYH6fZnakvGBtQD+NAYF8s4w8oGOAZ91PvZbtWeTKp4bxK93nZSNw8p/io5mvqI05GD4RUy5zIfBrqETY+jH421CrM=
Message-ID: <653402b90704150334o4e81df48n5bf5dc221da07d2a@mail.gmail.com>
Date: Sun, 15 Apr 2007 12:34:23 +0200
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: akpm@osdl.org
Subject: [PATCH] [Trivial] Spelling at drivers/video/Kconfig
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial patch, against -rc6. I don't know if anyone has fixed this by now.
---

 drivers/video/Kconfig:
    - Spelling: "Frambuffer hardware support"

 drivers/video/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Signed-off-by: Miguel Ojeda Sandonis <maxextreme@gmail.com>
---
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index e4f0dd0..8372ace 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -139,7 +139,7 @@ config FB_TILEBLITTING
         This is particularly important to one driver, matroxfb.  If
         unsure, say N.

-comment "Frambuffer hardware drivers"
+comment "Frame buffer hardware drivers"
        depends on FB

 config FB_CIRRUS

-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm
