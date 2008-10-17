Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbYJQMsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbYJQMsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755892AbYJQMsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:48:21 -0400
Received: from [165.204.77.10] ([165.204.77.10]:58446 "EHLO elemente.amd.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755592AbYJQMsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:48:20 -0400
Message-Id: <20081017133137.733236242@amd.com>
References: <20081017133035.331392689@amd.com>
User-Agent: quilt/0.46-1
Date: Fri, 17 Oct 2008 15:30:38 +0200
From: Peter Oruba <peter.oruba@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Oruba <peter.oruba@amd.com>
Subject: [patch 3/3] x86: AMD microcode patch loader author update
Content-Disposition: inline; filename=patches2/0003-x86-AMD-microcode-patch-loader-author-update.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed author's email address from MODULE_AUTHOR.

Signed-off-by: Peter Oruba <peter.oruba@amd.com>
---
 arch/x86/kernel/microcode_amd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 7a1f8ee..5f8e5d7 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -39,7 +39,7 @@
 #include <asm/microcode.h>
 
 MODULE_DESCRIPTION("AMD Microcode Update Driver");
-MODULE_AUTHOR("Peter Oruba <peter.oruba@amd.com>");
+MODULE_AUTHOR("Peter Oruba");
 MODULE_LICENSE("GPL v2");
 
 #define UCODE_MAGIC                0x00414d44
-- 
1.5.4.1

-- 



