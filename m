Return-Path: <linux-kernel-owner+w=401wt.eu-S1759971AbYFKPGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759971AbYFKPGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 11:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758130AbYFKPGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 11:06:12 -0400
Received: from mx1.suse.de ([195.135.220.2]:60444 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758099AbYFKPGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 11:06:11 -0400
From: Stefan Assmann <sassmann@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>, Olaf Dabrunz <od@suse.de>,
       Stefan Assmann <sassmann@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Ihno Krumreich <ihno@suse.de>, Sven Dietrich <sdietrich@suse.de>,
       Daniel Gollub <dgollub@suse.de>, Felix Foerster <ffoerster@suse.de>
Subject: [PATCH 1/5] Add PCI IDs for devices that need boot irq quirks
Date: Wed, 11 Jun 2008 16:35:13 +0200
Message-Id: <12131949171523-git-send-email-sassmann@suse.de>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12131949173532-git-send-email-sassmann@suse.de>
References: <12131949173532-git-send-email-sassmann@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olaf Dabrunz <od@suse.de>

Signed-off-by: Stefan Assmann <sassmann@suse.de>
Signed-off-by: Olaf Dabrunz <od@suse.de>
---
 include/linux/pci_ids.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 9b940e6..b89616d 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2233,6 +2233,10 @@
 #define PCI_DEVICE_ID_INTEL_PXH_0	0x0329
 #define PCI_DEVICE_ID_INTEL_PXH_1	0x032A
 #define PCI_DEVICE_ID_INTEL_PXHV	0x032C
+#define PCI_DEVICE_ID_INTEL_80332_0	0x0330
+#define PCI_DEVICE_ID_INTEL_80332_1	0x0332
+#define PCI_DEVICE_ID_INTEL_80333_0	0x0370
+#define PCI_DEVICE_ID_INTEL_80333_1	0x0372
 #define PCI_DEVICE_ID_INTEL_82375	0x0482
 #define PCI_DEVICE_ID_INTEL_82424	0x0483
 #define PCI_DEVICE_ID_INTEL_82378	0x0484
@@ -2305,6 +2309,7 @@
 #define PCI_DEVICE_ID_INTEL_ESB_4	0x25a4
 #define PCI_DEVICE_ID_INTEL_ESB_5	0x25a6
 #define PCI_DEVICE_ID_INTEL_ESB_9	0x25ab
+#define PCI_DEVICE_ID_INTEL_ESB_10	0x25ac
 #define PCI_DEVICE_ID_INTEL_82820_HB	0x2500
 #define PCI_DEVICE_ID_INTEL_82820_UP_HB	0x2501
 #define PCI_DEVICE_ID_INTEL_82850_HB	0x2530
-- 
1.5.2.4

