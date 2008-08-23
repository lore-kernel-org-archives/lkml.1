Return-Path: <linux-kernel-owner+w=401wt.eu-S1756266AbYHWAyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbYHWAyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 20:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755368AbYHWAyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 20:54:43 -0400
Received: from tau.jukie.net ([216.239.93.128]:50999 "EHLO tau.jukie.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbYHWAym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 20:54:42 -0400
From: Bart Trojanowski <bart@jukie.net>
To: linux-kernel@vger.kernel.org
Cc: Bart Trojanowski <bart@jukie.net>, trivial@kernel.org
Subject: [PATCH] fix X86-84 typo in kernel-parameters.txt
Date: Fri, 22 Aug 2008 20:54:41 -0400
Message-Id: <1219452881-25013-1-git-send-email-bart@jukie.net>
X-Mailer: git-send-email 1.5.6.1.109.ga974cd.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bart Trojanowski <bart@jukie.net>
Cc: trivial@kernel.org
---
 Documentation/kernel-parameters.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e7bea3e..4f10ddc 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -278,7 +278,7 @@ and is between 256 and 4096 characters. It is defined in the file
 	aic79xx=	[HW,SCSI]
 			See Documentation/scsi/aic79xx.txt.
 
-	amd_iommu=	[HW,X86-84]
+	amd_iommu=	[HW,X86-64]
 			Pass parameters to the AMD IOMMU driver in the system.
 			Possible values are:
 			isolate - enable device isolation (each device, as far
-- 
1.6.0.rc0.43.gb0a469

