Return-Path: <linux-kernel-owner+w=401wt.eu-S934152AbXLQTi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934152AbXLQTi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:38:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761221AbXLQTbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:31:47 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2974 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760916AbXLQTbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:39 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH] arch/sparc64/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:22 -0800
Message-Id: <1197919875-5288-23-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918890.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/sparc64/kernel/pci_schizo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sparc64/kernel/pci_schizo.c b/arch/sparc64/kernel/pci_schizo.c
index 9546ba9..e752e75 100644
--- a/arch/sparc64/kernel/pci_schizo.c
+++ b/arch/sparc64/kernel/pci_schizo.c
@@ -850,7 +850,7 @@ static int pbm_routes_this_ino(struct pci_pbm_info *pbm, u32 ino)
 /* How the Tomatillo IRQs are routed around is pure guesswork here.
  *
  * All the Tomatillo devices I see in prtconf dumps seem to have only
- * a single PCI bus unit attached to it.  It would seem they are seperate
+ * a single PCI bus unit attached to it.  It would seem they are separate
  * devices because their PortID (ie. JBUS ID) values are all different
  * and thus the registers are mapped to totally different locations.
  *
-- 
1.5.3.7.949.g2221a6

