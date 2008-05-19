Return-Path: <linux-kernel-owner+w=401wt.eu-S1761376AbYESNVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761376AbYESNVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759862AbYESNRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:17:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45818 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759819AbYESNRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:17:35 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 11/57] hpwdt: couple of include cleanups
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:05:46 +0100
Message-ID: <20080519130546.31722.18225.stgit@core>
In-Reply-To: <20080519124659.31722.51847.stgit@core>
References: <20080519124659.31722.51847.stgit@core>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>


---

 drivers/watchdog/hpwdt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 6483d10..ca1dc99 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -39,9 +39,9 @@
 #include <linux/string.h>
 #include <linux/bootmem.h>
 #include <linux/slab.h>
-#include <asm/dmi.h>
+#include <linux/dmi.h>
 #include <asm/desc.h>
-#include <asm/kdebug.h>
+#include <linux/kdebug.h>
 
 #define PCI_BIOS32_SD_VALUE		0x5F32335F	/* "_32_" */
 #define CRU_BIOS_SIGNATURE_VALUE	0x55524324

