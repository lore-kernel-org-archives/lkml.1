Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030240Ab0B0Qw0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:52:26 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968623Ab0B0QwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:52:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=HPG0ROZDlari2iCLNIW+engI0KmSPPV8vSuNXr4a07F1OHmP9pbz/6PEvdg1Vxbcgl
         5F/WaENnzAtDcquIEJwnJ2DOA+tMlBA2kZhZ7uzDu5m7TmV7ieY7bQcA1M77ZBr7JazA
         KIR5n07WXHTMtldp804dlMCBc9mcg5ol3/2yM=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, Jeff Dike <jdike@addtoit.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       WANG Cong <xiyou.wangcong@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       user-mode-linux-user@lists.sourceforge.net
Subject: [PATCH 04/66] arch/um/include/asm/irq_vectors.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:50:45 +0100
Message-Id: <1267289508-31031-5-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/um/include/asm/irq_vectors.h:1: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/um/include/asm/irq_vectors.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/um/include/asm/irq_vectors.h b/arch/um/include/asm/irq_vectors.h
index 272a81e..05cb834 100644
--- a/arch/um/include/asm/irq_vectors.h
+++ b/arch/um/include/asm/irq_vectors.h
@@ -1,4 +1,4 @@
-/* 
+/*
  * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
  * Licensed under the GPL
  */
@@ -7,4 +7,3 @@
 #define __UM_IRQ_VECTORS_H
 
 #endif
-
-- 
1.7.0.90.g251a4

