Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab0BJAnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 19:43:10 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:21451 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab0BJAnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 19:43:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=JEYf8tVFbLCRFX8vv4COWtfGHUBHiIaPR8ORYuSilMtU5cIRKk8gSt3kGfCjnWWfo7
         jRH2GlbsLVSregfs9VZJximO2BJMdi1LNe036VKigxmq+Ud+FH28AC3t8N26hX7SZQiJ
         sKCSbHI1h5UqSJdxXqGIZOSTZv6RAhgX+6f4c=
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] CRYPTO: Fix checkpatch errors in aead.c
Date: Wed, 10 Feb 2010 01:42:27 +0100
Message-Id: <1265762548-21458-1-git-send-email-richih.mailinglist@gmail.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/aead.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index 0a55da7..6729e8f 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -1,13 +1,13 @@
 /*
  * AEAD: Authenticated Encryption with Associated Data
- * 
+ *
  * This file provides API support for AEAD algorithms.
  *
  * Copyright (c) 2007 Herbert Xu <herbert@gondor.apana.org.au>
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

