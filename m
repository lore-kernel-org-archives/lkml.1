Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030369Ab0B0Qyv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:54:51 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46242 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030349Ab0B0Qyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:54:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=qI3Yh/va7jmUNU0dUiJ3SQiCtcDppIHRbqLII2sLQEsbzf3dUKzZeaC5BgH099S35d
         2bREmLkw6yY4JfasXgQky3451NUFo+N/f+N67zLm2DoHO7r3eUsdwul7YFZu24lF/oCP
         lJDwGuoK6/2ZzRx9mpbPOlPzpkZQu2G+ngKIY=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
       linux-s390@vger.kernel.org
Subject: [PATCH 29/66] arch/s390/include/asm/unaligned.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:10 +0100
Message-Id: <1267289508-31031-30-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/s390/include/asm/unaligned.h:5: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/s390/include/asm/unaligned.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/s390/include/asm/unaligned.h b/arch/s390/include/asm/unaligned.h
index da9627a..1ce42c3 100644
--- a/arch/s390/include/asm/unaligned.h
+++ b/arch/s390/include/asm/unaligned.h
@@ -2,7 +2,7 @@
 #define _ASM_S390_UNALIGNED_H
 
 /*
- * The S390 can do unaligned accesses itself. 
+ * The S390 can do unaligned accesses itself.
  */
 #include <linux/unaligned/access_ok.h>
 #include <linux/unaligned/generic.h>
-- 
1.7.0.90.g251a4

