Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030212Ab0B0QwJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:52:09 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968594Ab0B0QwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:52:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=PK5AiJ0Vrt68POkl+ja7+N2H8RtiP3H+7uxzzQm3d9LbXdtqWGbP6H7/ZT/hNBO+y0
         1Iq7obWKg32ZSZpswSUgPBC9KcnYrk5wx5kkTmGXF9OSa/FdkLjUeWO8TjPcUlDCXqlX
         p4/d0UYvdMAhlSqOh1UjsN96gix0oPLND6Aks=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
       "James E.J. Bottomley" <jejb@parisc-linux.org>,
       linux-parisc@vger.kernel.org
Subject: [PATCH 01/66] arch/parisc/include/asm/percpu.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:50:42 +0100
Message-Id: <1267289508-31031-2-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/parisc/include/asm/percpu.h:6: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/parisc/include/asm/percpu.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/include/asm/percpu.h b/arch/parisc/include/asm/percpu.h
index a0dcd19..fb92561 100644
--- a/arch/parisc/include/asm/percpu.h
+++ b/arch/parisc/include/asm/percpu.h
@@ -3,5 +3,4 @@
 
 #include <asm-generic/percpu.h>
 
-#endif 
-
+#endif
-- 
1.7.0.90.g251a4

