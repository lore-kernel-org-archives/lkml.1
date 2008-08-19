Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbYHSOd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbYHSOd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 10:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbYHSOdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 10:33:05 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:62215 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbYHSOdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 10:33:01 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K5UR2M-04-SOY-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       muli@il.ibm.com, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 8/8] x86, AMD IOMMU: remove obsolete FIXME comment
Date: Tue, 19 Aug 2008 16:32:46 +0200
Message-ID: <1219156366-32498-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1219156366-32498-1-git-send-email-joerg.roedel@amd.com>
References: <1219156366-32498-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Aug 2008 14:32:46.0734 (UTC) FILETIME=[72E47AE0:01C90208]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 69b4d06..01c68c3 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1038,8 +1038,6 @@ out:
 
 /*
  * The exported free_coherent function for dma_ops.
- * FIXME: fix the generic x86 DMA layer so that it actually calls that
- *        function.
  */
 static void free_coherent(struct device *dev, size_t size,
 			  void *virt_addr, dma_addr_t dma_addr)
-- 
1.5.3.7


