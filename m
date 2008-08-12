Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbYHLP1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbYHLP1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 11:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754187AbYHLPZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 11:25:30 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:58507 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158AbYHLPZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 11:25:29 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K5HUTG-04-OI0-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       muli@il.ibm.com, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 7/7] x86, AMD IOMMU: remove obsolete FIXME comment
Date: Tue, 12 Aug 2008 17:24:17 +0200
Message-ID: <1218554657-16070-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1218554657-16070-1-git-send-email-joerg.roedel@amd.com>
References: <1218554657-16070-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 12 Aug 2008 15:24:18.0243 (UTC) FILETIME=[7CAF1130:01C8FC8F]
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
index 22d7d05..61d2d59 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1035,8 +1035,6 @@ out:
 
 /*
  * The exported free_coherent function for dma_ops.
- * FIXME: fix the generic x86 DMA layer so that it actually calls that
- *        function.
  */
 static void free_coherent(struct device *dev, size_t size,
 			  void *virt_addr, dma_addr_t dma_addr)
-- 
1.5.3.7


