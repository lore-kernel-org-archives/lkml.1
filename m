Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab0BJBbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 20:31:24 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:45966 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961Ab0BJBbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 20:31:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OKJJfpp3pypUfI3XDX21kVxfDAwHkyYjuS5qruC8wRUM2pHO3yZ+j6nWNOKAV9TCdc
         ewSULuTSllmU4mb0SPIAHRtqWzP7AWpH3Lpwqv1fxbaTECTmdI7wXoDfVKqF8DHwabTE
         9NMxJGhdoti72gyH5nIkGT206+9OQnYz20Pcg=
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] CRYPTO: Fix checkpatch errors & warnings in cipher.c
Date: Wed, 10 Feb 2010 02:30:46 +0100
Message-Id: <1265765446-24958-1-git-send-email-richih.mailinglist@gmail.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/compress.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/compress.c b/crypto/compress.c
index 1ee3570..c33f076 100644
--- a/crypto/compress.c
+++ b/crypto/compress.c
@@ -7,7 +7,7 @@
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option) 
+ * Software Foundation; either version 2 of the License, or (at your option)
  * any later version.
  *
  */
@@ -39,7 +39,7 @@ int crypto_init_compress_ops(struct crypto_tfm *tfm)
 
 	ops->cot_compress = crypto_compress;
 	ops->cot_decompress = crypto_decompress;
-	
+
 	return 0;
 }
 
-- 
1.6.6.1

