Return-Path: <linux-kernel-owner+w=401wt.eu-S1753615AbYDXIml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbYDXIml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 04:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbYDXImd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 04:42:33 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:56975 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750748AbYDXImc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 04:42:32 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-4.tower-29.messagelabs.com!1209026551!12050812!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
To: <linux-kernel@vger.kernel.org>
CC: <trivial@kernel.org>
Subject: [PATCH] fix typo "kernal" -> "kernel"
Date: Thu, 24 Apr 2008 10:42:17 +0200
Message-ID: <1209026537-30611-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
X-Mailer: git-send-email 1.5.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 24 Apr 2008 08:42:17.0670 (UTC) FILETIME=[1A433660:01C8A5E7]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.500.1026-15866.007
X-TM-AS-Result: No--10.329000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
Cc: trivial@kernel.org
---
 fs/proc/nommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/nommu.c b/fs/proc/nommu.c
index 941e951..618a732 100644
--- a/fs/proc/nommu.c
+++ b/fs/proc/nommu.c
@@ -76,7 +76,7 @@ int nommu_vma_show(struct seq_file *m, struct vm_area_struct *vma)
 
 /*
  * display a list of all the VMAs the kernel knows about
- * - nommu kernals have a single flat list
+ * - nommu kernels have a single flat list
  */
 static int nommu_vma_list_show(struct seq_file *m, void *v)
 {
-- 
1.5.5.1

