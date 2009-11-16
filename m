Return-Path: <linux-kernel-owner+w=401wt.eu-S1753673AbZKPOSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbZKPOSP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbZKPOQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:16:30 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:15522 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbZKPOQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:16:24 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz1417J936eMzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KT7GZ7-01-9KR-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <x86@kernel.org>, <norsk5@yahoo.com>
Subject: [PATCH 21/21] amd64_edac: bump driver version
Date: Mon, 16 Nov 2009 15:16:48 +0100
Message-ID: <1258381008-18783-22-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
References: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 16 Nov 2009 14:16:13.0328 (UTC) FILETIME=[5A514100:01CA66C7]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was long overdue ...

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index e84f164..41bc561 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -129,7 +129,7 @@
  *         sections 3.5.4 and 3.5.5 for more information.
  */
 
-#define EDAC_AMD64_VERSION		" Ver: 3.2.0 " __DATE__
+#define EDAC_AMD64_VERSION		" Ver: 3.3.0 " __DATE__
 #define EDAC_MOD_STR			"amd64_edac"
 
 #define EDAC_MAX_NUMNODES		8
-- 
1.6.4.3


