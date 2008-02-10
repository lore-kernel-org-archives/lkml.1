Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798AbYBJXRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbYBJXRp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 18:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756494AbYBJXRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 18:17:16 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:22234 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756288AbYBJXRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 18:17:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=QjOy8KjEbzfB33DK/3aeLXX4LmEti/K8nZR8BTFaPFbxq7CCNMnlb4DV3IHbeEhLYoCTwwGkGkpLv9ccxMx8b/c6S+EGxr+OAX142UOrRjldkGhe7olkaVYdgFfYGyntui76KJ8DoOBJ0lbbRZaNNXy++CYD3EBCcnx8eTuKLX0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] ide: remove stale comment from ide-lib.c
Date: Mon, 11 Feb 2008 00:24:26 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802110024.27229.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-lib.c |    9 ---------
 1 file changed, 9 deletions(-)

Index: b/drivers/ide/ide-lib.c
===================================================================
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -21,15 +21,6 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
-/*
- *	IDE library routines. These are plug in code that most 
- *	drivers can use but occasionally may be weird enough
- *	to want to do their own thing with
- *
- *	Add common non I/O op stuff here. Make sure it has proper
- *	kernel-doc function headers or your patch will be rejected
- */
-
 static const char *udma_str[] =
 	 { "UDMA/16", "UDMA/25",  "UDMA/33",  "UDMA/44",
 	   "UDMA/66", "UDMA/100", "UDMA/133", "UDMA7" };
