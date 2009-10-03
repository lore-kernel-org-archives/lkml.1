Return-Path: <linux-kernel-owner+w=401wt.eu-S1756751AbZJCSHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbZJCSHB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 14:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756710AbZJCSHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 14:07:01 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:40328 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756709AbZJCSHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 14:07:00 -0400
X-Greylist: delayed 1164 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Oct 2009 14:07:00 EDT
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: linux-kernel@vger.kernel.org
Subject: [PATCH] spelling correction in a comment
Date: Sat, 3 Oct 2009 20:45:02 +0300
User-Agent: KMail/1.11.4 (Linux/2.6.32-rc2; KDE/4.2.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910032045.02523.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Correcting spelling in a comment

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>

======================================================
--- a/arch/x86/kernel/pci-dma.c	2009-10-03 19:49:51.000000000 +0300
+++ b/arch/x86/kernel/pci-dma.c	2009-10-03 19:50:26.000000000 +0300
@@ -35,7 +35,7 @@
 
 /*
  * This variable becomes 1 if iommu=pt is passed on the kernel command line.
- * If this variable is 1, IOMMU implementations do no DMA ranslation for
+ * If this variable is 1, IOMMU implementations do no DMA translation for
  * devices and allow every device to access to whole physical memory. This is
  * useful if a user want to use an IOMMU only for KVM device assignment to
  * guests and not for driver dma translation.
