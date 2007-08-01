Return-Path: <linux-kernel-owner+w=401wt.eu-S1765388AbXHASdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765388AbXHASdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 14:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758272AbXHASdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 14:33:41 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:27634 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756763AbXHASdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 14:33:40 -0400
Message-ID: <46B0D1F7.9090805@interia.pl>
Date: Wed, 01 Aug 2007 20:33:27 +0200
From: =?UTF-8?B?UmFmYcWCIEJpbHNraQ==?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 2.0.0.5 (X11/20070720)
MIME-Version: 1.0
To: trivial@kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] mtdsuper: licensce = GPL
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-EMID: 9c076acc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


block2mtd: version $Revision: 1.30 $
block2mtd: mtd0: [d: /dev/sdc2] erase_size = 64KiB [65536]
mtdsuper: module license 'unspecified' taints kernel.
mtdsuper: Unknown symbol get_mtd_device
mtdsuper: Unknown symbol put_mtd_device
jffs2: Unknown symbol get_sb_mtd
jffs2: Unknown symbol kill_mtd_super

Signed-off-by: Rafał Bilski <rafalbilski@interia.pl>
---
 drivers/mtd/mtdsuper.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/mtdsuper.c b/drivers/mtd/mtdsuper.c
index aca3319..3510ed0 100644
--- a/drivers/mtd/mtdsuper.c
+++ b/drivers/mtd/mtdsuper.c
@@ -230,3 +230,5 @@ void kill_mtd_super(struct super_block *sb)
 }
 
 EXPORT_SYMBOL_GPL(kill_mtd_super);
+MODULE_LICENSE("GPL");
+
-- 


----------------------------------------------------------------------
Zmien konto na takie o nieograniczonej pojemnosci.
Za darmo w INTERIA.PL

>>>http://link.interia.pl/f1b0a

