Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbYJQMtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbYJQMtp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756784AbYJQMs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:48:27 -0400
Received: from [165.204.77.10] ([165.204.77.10]:58456 "EHLO elemente.amd.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756335AbYJQMs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:48:26 -0400
Message-Id: <20081017133137.594857330@amd.com>
References: <20081017133035.331392689@amd.com>
User-Agent: quilt/0.46-1
Date: Fri, 17 Oct 2008 15:30:37 +0200
From: Peter Oruba <peter.oruba@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Oruba <peter.oruba@amd.com>
Subject: [patch 2/3] x86: Microcode patch loader author update
Content-Disposition: inline; filename=patches2/0002-x86-Microcode-patch-loader-author-update.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed one author's email address from module init message.

Signed-off-by: Peter Oruba <peter.oruba@amd.com>
---
 arch/x86/kernel/microcode_core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 936d8d5..82fb280 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -480,8 +480,8 @@ static int __init microcode_init(void)
 
 	printk(KERN_INFO
 	       "Microcode Update Driver: v" MICROCODE_VERSION
-	       " <tigran@aivazian.fsnet.co.uk>"
-	       " <peter.oruba@amd.com>\n");
+	       " <tigran@aivazian.fsnet.co.uk>,"
+	       " Peter Oruba\n");
 
 	return 0;
 }
-- 
1.5.4.1

-- 

