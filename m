Return-Path: <linux-kernel-owner+w=401wt.eu-S1751891AbZAZCCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbZAZCCB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 21:02:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbZAZCBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 21:01:52 -0500
Received: from vps1.tull.net ([66.180.172.116]:50670 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751004AbZAZCBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 21:01:52 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [TRIVIAL PATCH 03/20] Fix misspelling of "firmware" in ip27-smp.c
To: Trivial Kernel Patches <trivial@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 26 Jan 2009 13:00:59 +1100
Message-ID: <20090126020059.15168.26453.stgit@marcab.local.tull.net>
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

Fix misspelling of "firmware" in ip27-smp.c

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 arch/mips/sgi-ip27/ip27-smp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/arch/mips/sgi-ip27/ip27-smp.c b/arch/mips/sgi-ip27/ip27-smp.c
index 5b47d6b..cbcd7eb 100644
--- a/arch/mips/sgi-ip27/ip27-smp.c
+++ b/arch/mips/sgi-ip27/ip27-smp.c
@@ -221,7 +221,7 @@ static void __init ip27_smp_setup(void)
 	 * Assumption to be fixed: we're always booted on logical / physical
 	 * processor 0.  While we're always running on logical processor 0
 	 * this still means this is physical processor zero; it might for
-	 * example be disabled in the firwware.
+	 * example be disabled in the firmware.
 	 */
 	alloc_cpupda(0, 0);
 }

