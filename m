Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbZAZCIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbZAZCIx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 21:08:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbZAZCI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 21:08:27 -0500
Received: from vps1.tull.net ([66.180.172.116]:36472 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752127AbZAZCI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 21:08:27 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [TRIVIAL PATCH 17/20] Fix misspelling of firmware in head_64.S
To: Trivial Kernel Patches <trivial@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 26 Jan 2009 13:08:19 +1100
Message-ID: <20090126020819.15168.60526.stgit@marcab.local.tull.net>
In-Reply-To: <20090126015921.15168.97302.stgit@marcab.local.tull.net>
References: <20090126015921.15168.97302.stgit@marcab.local.tull.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix misspelling of firmware in head_64.S

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 arch/sparc/kernel/head_64.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/arch/sparc/kernel/head_64.S b/arch/sparc/kernel/head_64.S
index 8ffee71..fcd0810 100644
--- a/arch/sparc/kernel/head_64.S
+++ b/arch/sparc/kernel/head_64.S
@@ -686,7 +686,7 @@ tlb_fixup_done:
 	 * point.
 	 *
 	 * There used to be enormous complexity wrt. transferring
-	 * over from the firwmare's trap table to the Linux kernel's.
+	 * over from the firmware's trap table to the Linux kernel's.
 	 * For example, there was a chicken & egg problem wrt. building
 	 * the OBP page tables, yet needing to be on the Linux kernel
 	 * trap table (to translate PAGE_OFFSET addresses) in order to

