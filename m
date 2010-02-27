Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030254Ab0B0Qwi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:52:38 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030242Ab0B0Qwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:52:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=MeJBv0RAbR1Vwc5ZHIC8WtiB09FpONTNPJRsKH9MY/IS2jQqBEY2fZdldcOz8RY4ZK
         7qD+zi5CXtRNrU8k+ErIuUNIewC8j1P52fxreZbUeEvqn9dD+QwqMMPrjYo+Ls8G/d43
         HdWZU4Bc4Cb7x4OxjSznQbmeFmv50eTJZqPGU=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: [PATCH 05/66] arch/cris/include/asm/irq.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:50:46 +0100
Message-Id: <1267289508-31031-6-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/cris/include/asm/irq.h:7: ERROR: trailing whitespace
arch/cris/include/asm/irq.h:8: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/cris/include/asm/irq.h |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/cris/include/asm/irq.h b/arch/cris/include/asm/irq.h
index ce0fcf5..9e9f231 100644
--- a/arch/cris/include/asm/irq.h
+++ b/arch/cris/include/asm/irq.h
@@ -4,10 +4,8 @@
 #include <arch/irq.h>
 
 static inline int irq_canonicalize(int irq)
-{  
-  return irq; 
+{
+  return irq;
 }
 
 #endif  /* _ASM_IRQ_H */
-
-
-- 
1.7.0.90.g251a4

