Return-Path: <linux-kernel-owner+w=401wt.eu-S1756658AbZCUWTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbZCUWTV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 18:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbZCUWTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 18:19:13 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:10378 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396AbZCUWTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 18:19:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=xX+7fW/0UKZK3wvm6HkUCEyBF75n+C7cjQi8LbPK6P6493xKZOZu38vVFyWvwwYgy3
         W+4buhELuRkBDbWriC7+VY0s4pUWMP5tl+3TPg9CNqOSPg3bAftrEjvshVz7owBp11uV
         MjHRdWxh6eoaf+AmQ3ILX3qSXkaqXliQvmO7A=
Message-ID: <49C567D1.1060006@gmail.com>
Date: Sat, 21 Mar 2009 23:18:57 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090304 Lightning/1.0pre Shredder/3.0b2
MIME-Version: 1.0
To: torvalds@linux-foundation.org, akpm <akpm@linux-foundation.org>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] update my email address.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update all previous incarnations of my email address to the correct one.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
diff --git a/CREDITS b/CREDITS
index 5e07367..e8b7d36 100644
--- a/CREDITS
+++ b/CREDITS
@@ -3738,7 +3738,7 @@ S: 93149 Nittenau
 S: Germany

 N: Gertjan van Wingerde
-E: gwingerde@home.nl
+E: gwingerde@gmail.com
 D: Ralink rt2x00 WLAN driver
 D: Minix V2 file-system
 D: Misc fixes
diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index d1d1eb8..618865b 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -3,7 +3,7 @@
  *
  *  Copyright (C) 1991, 1992  Linus Torvalds
  *
- *  Copyright (C) 1996  Gertjan van Wingerde    (gertjan@cs.vu.nl)
+ *  Copyright (C) 1996  Gertjan van Wingerde
  *     Minix V2 fs support.
  *
  *  Modified for 680x0 by Andreas Schwab
diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index e65212d..261a1c2 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -41,7 +41,7 @@
  * Stefan Reinauer <stepan@home.culture.mipt.ru>
  *
  * Module usage counts added on 96/04/29 by
- * Gertjan van Wingerde <gertjan@cs.vu.nl>
+ * Gertjan van Wingerde <gwingerde@gmail.com>
  *
  * Clean swab support on 19970406 by
  * Francois-Rene Rideau <fare@tunes.org>
