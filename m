Return-Path: <linux-kernel-owner+w=401wt.eu-S934325AbYCWJEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934325AbYCWJEM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758935AbYCWIMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:12:18 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2365 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760226AbYCWIL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:59 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 088/148] include/asm-x86/pci-direct.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:03 -0700
Message-Id: <1206259443-13210-89-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/pci-direct.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/pci-direct.h b/include/asm-x86/pci-direct.h
index 6823fa4..5b21485 100644
--- a/include/asm-x86/pci-direct.h
+++ b/include/asm-x86/pci-direct.h
@@ -4,7 +4,7 @@
 #include <linux/types.h>
 
 /* Direct PCI access. This is used for PCI accesses in early boot before
-   the PCI subsystem works. */ 
+   the PCI subsystem works. */
 
 extern u32 read_pci_config(u8 bus, u8 slot, u8 func, u8 offset);
 extern u8 read_pci_config_byte(u8 bus, u8 slot, u8 func, u8 offset);
-- 
1.5.4.rc2

