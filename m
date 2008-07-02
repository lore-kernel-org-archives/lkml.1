Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546AbYGBVTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbYGBVTB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 17:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755122AbYGBVSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 17:18:15 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:45407 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652AbYGBVSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 17:18:13 -0400
X-BigFish: VPS24(zzzz10d3izzz32i87il43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3EDTT-02-CTW-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 03/11] x86/pci: Makefile merge: Whitespace changes only
Date: Wed, 2 Jul 2008 22:50:21 +0200
Message-ID: <1215031829-29124-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1215031829-29124-1-git-send-email-robert.richter@amd.com>
References: <1215031829-29124-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 02 Jul 2008 21:17:55.0943 (UTC) FILETIME=[187B6770:01C8DC89]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/pci/Makefile |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index d33c57d..8491894 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -32,14 +32,14 @@ else
 # Makefile for X86_64 specific PCI routines
 #
 
-obj-y		:= i386.o
-obj-$(CONFIG_PCI_DIRECT)+= direct.o
-obj-y		+= fixup.o init.o
-obj-$(CONFIG_ACPI)	+= acpi.o
-obj-y			+= legacy.o irq.o common.o early.o
+obj-y				:= i386.o
+obj-$(CONFIG_PCI_DIRECT)	+= direct.o
+obj-y				+= fixup.o init.o
+obj-$(CONFIG_ACPI)		+= acpi.o
+obj-y				+= legacy.o irq.o common.o early.o
 # mmconfig has a 64bit special
-obj-$(CONFIG_PCI_MMCONFIG) += mmconfig_64.o direct.o mmconfig-shared.o
+obj-$(CONFIG_PCI_MMCONFIG)	+= mmconfig_64.o direct.o mmconfig-shared.o
 
-obj-y		+= amd_bus.o
+obj-y				+= amd_bus.o
 
 endif
-- 
1.5.5.4


