Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab0BJBcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 20:32:12 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39478 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101Ab0BJBcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 20:32:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=uHiQlAsyQztHJ2vWBqKXs4AQRNAaZ/YJj9nsP+ah6UU4fWWNdcrfQiH5UiS4igjswq
         y7LlWQkaD+7EJzPfYebcvVKTc5SBqY03sodwyYq9q2gmi7vGwPD4w5nOF3IaPJ8oaa58
         7yhq04G1SjoirMWDA9u1I2QDAy+hSZtlnLMvI=
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] CRYPTO: Fix checkpatch errors & warnings in crc32.c
Date: Wed, 10 Feb 2010 02:31:34 +0100
Message-Id: <1265765494-25267-1-git-send-email-richih.mailinglist@gmail.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/crc32c.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/crc32c.c b/crypto/crc32c.c
index 973bc2c..de9e55c 100644
--- a/crypto/crc32c.c
+++ b/crypto/crc32c.c
@@ -1,4 +1,4 @@
-/* 
+/*
  * Cryptographic API.
  *
  * CRC32C chksum
@@ -30,7 +30,7 @@
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option) 
+ * Software Foundation; either version 2 of the License, or (at your option)
  * any later version.
  *
  */
@@ -142,7 +142,7 @@ static u32 crc32c(u32 crc, const u8 *data, unsigned int length)
 }
 
 /*
- * Steps through buffer one byte at at time, calculates reflected 
+ * Steps through buffer one byte at at time, calculates reflected
  * crc using table.
  */
 
-- 
1.6.6.1

