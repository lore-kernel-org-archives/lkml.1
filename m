Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab0BJBcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 20:32:36 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39478 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab0BJBcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 20:32:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=VYySLKkft1+8wixKFNLG4CQribW/mtnCILoBtWNCnWlztmnFcG9ncbUPcguDa1RcRf
         nPjPIpkrL1Rr4sasjvMRuqN4owPGbHNsuSEBc4vcSgxR+/2Qw0Z8+2ouIo1DwwvOqhfe
         pNk+/XxrtyTKy2M299JyGO8D+oFl4xUflfIqo=
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] CRYPTO: Fix checkpatch errors & warnings in cipher.c
Date: Wed, 10 Feb 2010 02:32:00 +0100
Message-Id: <1265765521-25578-1-git-send-email-richih.mailinglist@gmail.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/cipher.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/crypto/cipher.c b/crypto/cipher.c
index 9a1a731..39541e0 100644
--- a/crypto/cipher.c
+++ b/crypto/cipher.c
@@ -8,7 +8,7 @@
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option) 
+ * Software Foundation; either version 2 of the License, or (at your option)
  * any later version.
  *
  */
-- 
1.6.6.1

