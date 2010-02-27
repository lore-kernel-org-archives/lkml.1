Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030365Ab0B0RDp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 12:03:45 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968614Ab0B0QyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:54:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=bUr8OFd11TbUZxYFDvMvmwEvwrmPFOT8LRAweuk+fl29MYaaQtuGBI1tg5KkIp9TtR
         UMZCc4jHMoqa774jiuiHvoeGqzzIipRaFjpWejnx7YTwjQnFVLYRe90LooFjxOqqLZ5H
         aUa4s3vaBnqOIhgToNfYnKfhgAGMmJKuObNBo=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: [PATCH 25/66] arch/h8300/include/asm/target_time.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:06 +0100
Message-Id: <1267289508-31031-26-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/h8300/include/asm/target_time.h:3: ERROR: trailing whitespace
arch/h8300/include/asm/target_time.h:4: ERROR: code indent should use tabs where possible

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/h8300/include/asm/target_time.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/h8300/include/asm/target_time.h b/arch/h8300/include/asm/target_time.h
index 9f2a9aa..043d9a0 100644
--- a/arch/h8300/include/asm/target_time.h
+++ b/arch/h8300/include/asm/target_time.h
@@ -1,4 +1,4 @@
 extern int platform_timer_setup(void (*timer_int)(int, void *, struct pt_regs *));
 extern void platform_timer_eoi(void);
-extern void platform_gettod(unsigned int *year, unsigned int *mon, unsigned int *day, 
-                            unsigned int *hour, unsigned int *min, unsigned int *sec);
+extern void platform_gettod(unsigned int *year, unsigned int *mon, unsigned int *day,
+				unsigned int *hour, unsigned int *min, unsigned int *sec);
-- 
1.7.0.90.g251a4

