Return-Path: <linux-kernel-owner+w=401wt.eu-S936564AbXLTPgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936564AbXLTPgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 10:36:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934143AbXLTPWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 10:22:25 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:62515 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933419AbXLTPVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 10:21:12 -0500
Message-Id: <20071220152109.824576241@de.ibm.com>
References: <20071220151925.405881218@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 20 Dec 2007 16:19:56 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 31/47] arch/s390: Add missing "space"
Content-Disposition: inline; filename=130-arch-whitespace.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/crypto/aes_s390.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: quilt-2.6/arch/s390/crypto/aes_s390.c
===================================================================
--- quilt-2.6.orig/arch/s390/crypto/aes_s390.c
+++ quilt-2.6/arch/s390/crypto/aes_s390.c
@@ -341,7 +341,7 @@ static int __init aes_init(void)
 		ecb_aes_alg.cra_u.blkcipher.max_keysize = AES_MIN_KEY_SIZE;
 		cbc_aes_alg.cra_u.blkcipher.max_keysize = AES_MIN_KEY_SIZE;
 		printk(KERN_INFO
-		       "aes_s390: hardware acceleration only available for"
+		       "aes_s390: hardware acceleration only available for "
 		       "128 bit keys\n");
 	}
 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

