Return-Path: <linux-kernel-owner+w=401wt.eu-S933658AbXLQTkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933658AbXLQTkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:40:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761153AbXLQTbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:31:45 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2970 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760892AbXLQTbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:38 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] arch/sh64/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:20 -0800
Message-Id: <1197919875-5288-21-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918890.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/sh64/kernel/pci_sh5.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sh64/kernel/pci_sh5.c b/arch/sh64/kernel/pci_sh5.c
index b4d9534..dd69d69 100644
--- a/arch/sh64/kernel/pci_sh5.c
+++ b/arch/sh64/kernel/pci_sh5.c
@@ -96,7 +96,7 @@ int __init sh5pci_init(unsigned memStart, unsigned memSize)
 		panic("Unable to remap PCIIO\n");
 	}
 
-	pr_debug("Register base addres is 0x%08lx\n", pcicr_virt);
+	pr_debug("Register base address is 0x%08lx\n", pcicr_virt);
 
 	/* Clear snoop registers */
         SH5PCI_WRITE(CSCR0, 0);
-- 
1.5.3.7.949.g2221a6

