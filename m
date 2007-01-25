Return-Path: <linux-kernel-owner+w=401wt.eu-S1030526AbXAYTqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030526AbXAYTqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 14:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030528AbXAYTqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 14:46:21 -0500
Received: from www.osadl.org ([213.239.205.134]:33896 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030526AbXAYTqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 14:46:20 -0500
Subject: [PATCH 2.6.20-rc6] MIPS: Fix some whitespace damage
From: Jan Altenberg <jan@linutronix.de>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 25 Jan 2007 20:46:14 +0100
Message-Id: <1169754374.6368.4.camel@jan-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some whitespace damage in arch/mips/Kconfig.debug

Signed-off-by: Jan Altenberg <jan@linutronix.de>

---
 arch/mips/Kconfig.debug |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/mips/Kconfig.debug
===================================================================
--- linux-2.6.orig/arch/mips/Kconfig.debug
+++ linux-2.6/arch/mips/Kconfig.debug
@@ -22,10 +22,10 @@ config CMDLINE
 	string "Default kernel command string"
 	default ""
 	help
-          On some platforms, there is currently no way for the boot loader to
-          pass arguments to the kernel. For these platforms, you can supply
-          some command-line options at build time by entering them here.  In
-          other cases you can specify kernel args so that you don't have
+	  On some platforms, there is currently no way for the boot loader to
+	  pass arguments to the kernel. For these platforms, you can supply
+	  some command-line options at build time by entering them here.  In
+	  other cases you can specify kernel args so that you don't have
 	  to set them up in board prom initialization routines.
 
 config DEBUG_STACK_USAGE


