Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab0BJA0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 19:26:17 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40594 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab0BJA0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 19:26:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=DWqTpThYmCGHAf9BrukDCgsmj84kGqm29U3NlLV8TT+1x/H0O82i4k8UEAhVP1eFuK
         t04ReMKYK12fBvF1r7Fug7V3I16HfWDTUQuxhabqQVLX961W07aEIeJNXS+YQm4mmp5J
         qswobLC03I6ki/5mKsQCHkvAbrY8bSo35VCgA=
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] CRYPTO: Fix checkpatch errors in ablkcipher.c
Date: Wed, 10 Feb 2010 01:25:40 +0100
Message-Id: <1265761540-20767-1-git-send-email-richih.mailinglist@gmail.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/ablkcipher.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index f6f0833..fe980da 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -1,6 +1,6 @@
 /*
  * Asynchronous block chaining cipher operations.
- * 
+ *
  * This is the asynchronous version of blkcipher.c indicating completion
  * via a callback.
  *
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
1.6.5.7

