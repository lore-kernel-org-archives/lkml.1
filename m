Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030498Ab0B0RCv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 12:02:51 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:57916 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030411Ab0B0RCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 12:02:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=M/J0t9Bqrgv/R4pUkAqVSKPoKEVZfWHs6a+NomqFFisqQIQBLKBy9EKWeSzcgsbivj
         HFUPGNa0MI5c7UmYagmRplaGpndFIdOPXwEuv0PVYkNVsG+pF+aji+pDdYaSwb7PM21k
         paBxat7536NrMibjqHVWYJBgETir7v0eAjEZk=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: [PATCH 28/66] arch/cris/include/asm/unaligned.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:09 +0100
Message-Id: <1267289508-31031-29-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/cris/include/asm/unaligned.h:5: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/cris/include/asm/unaligned.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/cris/include/asm/unaligned.h b/arch/cris/include/asm/unaligned.h
index 7b3f3fe..b0fc89d 100644
--- a/arch/cris/include/asm/unaligned.h
+++ b/arch/cris/include/asm/unaligned.h
@@ -2,7 +2,7 @@
 #define _ASM_CRIS_UNALIGNED_H
 
 /*
- * CRIS can do unaligned accesses itself. 
+ * CRIS can do unaligned accesses itself.
  */
 #include <linux/unaligned/access_ok.h>
 #include <linux/unaligned/generic.h>
-- 
1.7.0.90.g251a4

