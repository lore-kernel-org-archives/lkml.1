Return-Path: <linux-kernel-owner+w=401wt.eu-S1765142AbXGYMKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765142AbXGYMKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763633AbXGYMIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:08:51 -0400
Received: from rex.snapgear.com ([203.143.235.140]:33040 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763594AbXGYMIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:08:50 -0400
Date: Wed, 25 Jul 2007 22:07:20 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707251207.l6PC7KiH032176@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: create hw_irq.h
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Need an include/asm-m68knommu/hw_irq.h for kernel/hrtimer.c

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naur linux-2.6.22/include/asm-m68knommu/hw_irq.h linux-2.6.22-uc0/include/asm-m68knommu/hw_irq.h
--- linux-2.6.22/include/asm-m68knommu/hw_irq.h	1970-01-01 10:00:00.000000000 +1000
+++ linux-2.6.22-uc0/include/asm-m68knommu/hw_irq.h	2007-07-12 15:23:59.000000000 +1000
@@ -0,0 +1,4 @@
+#ifndef __M68KNOMMU_HW_IRQ_H__
+#define __M68KNOMMU_HW_IRQ_H__
+
+#endif /* __M68KNOMMU_HW_IRQ_H__ */
