Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab0BSAXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 19:23:04 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:44202 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab0BSAWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 19:22:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CKSRCgtt8sYtSeFFLwrEWIyANXs1Kp0VFp1sQeE3nyl4DOxHeSHbrf0kKOOKZOBlSB
         zwEZ9lAfa5QWD5XP3ab2BWk36DFh/3N8++Dslf/qoseAURNb2VUWP8WoVmPMBXO8ilmF
         RXQUGOSr9SyJojrQAkQaFcZYFz4gJnVvF/XZ0=
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 10/19] crypto: sha1_generic - Fix checkpatch errors
Date: Fri, 19 Feb 2010 01:22:35 +0100
Message-Id: <1266538957-3410-1-git-send-email-richih.mailinglist@gmail.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/sha1_generic.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
index 0416091..297cb0d 100644
--- a/crypto/sha1_generic.c
+++ b/crypto/sha1_generic.c
@@ -127,11 +127,11 @@ static struct shash_alg alg = {
 	.descsize	=	sizeof(struct sha1_state),
 	.statesize	=	sizeof(struct sha1_state),
 	.base		=	{
-		.cra_name	=	"sha1",
-		.cra_driver_name=	"sha1-generic",
-		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
-		.cra_blocksize	=	SHA1_BLOCK_SIZE,
-		.cra_module	=	THIS_MODULE,
+		.cra_name		=	"sha1",
+		.cra_driver_name	=	"sha1-generic",
+		.cra_flags		=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize		=	SHA1_BLOCK_SIZE,
+		.cra_module		=	THIS_MODULE,
 	}
 };
 
-- 
1.6.6.1

