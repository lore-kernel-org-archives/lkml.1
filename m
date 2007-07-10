Return-Path: <linux-kernel-owner+w=401wt.eu-S1764254AbXGJJ3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764254AbXGJJ3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759495AbXGJJ2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:28:46 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:10875 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764055AbXGJJ2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:28:44 -0400
Message-Id: <20070710093100.843981851@de.ibm.com>
References: <20070710092935.896013926@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 10 Jul 2007 11:29:37 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Ralph Wuerthner <rwuerthn@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 02/16] Fixed comment typo.
Content-Disposition: inline; filename=002-crypto-typo.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ralph Wuerthner <rwuerthn@de.ibm.com>

Signed-off-by: Ralph Wuerthner <rwuerthn@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

---

 arch/s390/crypto/crypt_s390.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: quilt-2.6/arch/s390/crypto/crypt_s390.h
===================================================================
--- quilt-2.6.orig/arch/s390/crypto/crypt_s390.h
+++ quilt-2.6/arch/s390/crypto/crypt_s390.h
@@ -24,7 +24,7 @@
 #define CRYPT_S390_PRIORITY 300
 #define CRYPT_S390_COMPOSITE_PRIORITY 400
 
-/* s930 cryptographic operations */
+/* s390 cryptographic operations */
 enum crypt_s390_operations {
 	CRYPT_S390_KM   = 0x0100,
 	CRYPT_S390_KMC  = 0x0200,

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

