Return-Path: <linux-kernel-owner+w=401wt.eu-S1754424AbZK0OCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424AbZK0OCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 09:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbZK0OCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 09:02:17 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:17999 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbZK0Nzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:55:53 -0500
X-SpamScore: -1
X-BigFish: VPS-1(z5edIz655Nzz1202hzz92fbmz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KTRTD0-02-34J-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 02/34] x86/amd-iommu: Update copyright headers
Date: Fri, 27 Nov 2009 14:55:13 +0100
Message-ID: <1259330145-14865-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
References: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2009 13:55:47.0795 (UTC) FILETIME=[52630230:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the copyright headers in the relevant AMD
IOMMU driver files to match the date of the latest changes.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu.h       |    2 +-
 arch/x86/include/asm/amd_iommu_types.h |    2 +-
 arch/x86/kernel/amd_iommu.c            |    2 +-
 arch/x86/kernel/amd_iommu_init.c       |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu.h b/arch/x86/include/asm/amd_iommu.h
index 0891338..5af2982 100644
--- a/arch/x86/include/asm/amd_iommu.h
+++ b/arch/x86/include/asm/amd_iommu.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2007-2008 Advanced Micro Devices, Inc.
+ * Copyright (C) 2007-2009 Advanced Micro Devices, Inc.
  * Author: Joerg Roedel <joerg.roedel@amd.com>
  *         Leo Duran <leo.duran@amd.com>
  *
diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 27db7f9..df5e9c8 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2007-2008 Advanced Micro Devices, Inc.
+ * Copyright (C) 2007-2009 Advanced Micro Devices, Inc.
  * Author: Joerg Roedel <joerg.roedel@amd.com>
  *         Leo Duran <leo.duran@amd.com>
  *
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 50d2b05..7fe28be 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2007-2008 Advanced Micro Devices, Inc.
+ * Copyright (C) 2007-2009 Advanced Micro Devices, Inc.
  * Author: Joerg Roedel <joerg.roedel@amd.com>
  *         Leo Duran <leo.duran@amd.com>
  *
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index db30cfe..cee1142 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2007-2008 Advanced Micro Devices, Inc.
+ * Copyright (C) 2007-2009 Advanced Micro Devices, Inc.
  * Author: Joerg Roedel <joerg.roedel@amd.com>
  *         Leo Duran <leo.duran@amd.com>
  *
-- 
1.6.5.3


