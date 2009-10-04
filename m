Return-Path: <linux-kernel-owner+w=401wt.eu-S1757391AbZJDPof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbZJDPof (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 11:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757350AbZJDPoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 11:44:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:54488 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596AbZJDPod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 11:44:33 -0400
Date: Sun, 4 Oct 2009 15:43:06 GMT
From: tip-bot for Marin Mitov <mitov@issp.bas.bg>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       joerg.roedel@amd.com, tglx@linutronix.de, jesse.brandeburg@intel.com,
       mitov@issp.bas.bg, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       joerg.roedel@amd.com, tglx@linutronix.de, jesse.brandeburg@intel.com,
       mitov@issp.bas.bg, mingo@elte.hu
In-Reply-To: <200910032045.02523.mitov@issp.bas.bg>
References: <200910032045.02523.mitov@issp.bas.bg>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, pci: Correct spelling in a comment
Message-ID: <tip-e3be785fb59f92c0df685037062d041619653b7a@git.kernel.org>
Git-Commit-ID: e3be785fb59f92c0df685037062d041619653b7a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 04 Oct 2009 15:43:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e3be785fb59f92c0df685037062d041619653b7a
Gitweb:     http://git.kernel.org/tip/e3be785fb59f92c0df685037062d041619653b7a
Author:     Marin Mitov <mitov@issp.bas.bg>
AuthorDate: Sat, 3 Oct 2009 20:45:02 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 3 Oct 2009 20:35:16 +0200

x86, pci: Correct spelling in a comment

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
LKML-Reference: <200910032045.02523.mitov@issp.bas.bg>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
======================================================


---
 arch/x86/kernel/pci-dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 64b838e..d20009b 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -35,7 +35,7 @@ int iommu_detected __read_mostly = 0;
 
 /*
  * This variable becomes 1 if iommu=pt is passed on the kernel command line.
- * If this variable is 1, IOMMU implementations do no DMA ranslation for
+ * If this variable is 1, IOMMU implementations do no DMA translation for
  * devices and allow every device to access to whole physical memory. This is
  * useful if a user want to use an IOMMU only for KVM device assignment to
  * guests and not for driver dma translation.
