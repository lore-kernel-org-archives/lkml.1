Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbZKQPHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbZKQPHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 10:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754459AbZKQPHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 10:07:49 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40521 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754365AbZKQPHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 10:07:47 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 4/5] pata: Update experimental tags
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Date: Tue, 17 Nov 2009 14:51:39 +0000
Message-ID: <20091117145137.15430.11229.stgit@localhost.localdomain>
In-Reply-To: <20091117144450.15430.83450.stgit@localhost.localdomain>
References: <20091117144450.15430.83450.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/ata/Kconfig |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index f2df6e2..36931e0 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -374,7 +374,7 @@ config PATA_HPT366
 	  If unsure, say N.
 
 config PATA_HPT37X
-	tristate "HPT 370/370A/371/372/374/302 PATA support (Experimental)"
+	tristate "HPT 370/370A/371/372/374/302 PATA support"
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the majority of the later HPT
@@ -383,7 +383,7 @@ config PATA_HPT37X
 	  If unsure, say N.
 
 config PATA_HPT3X2N
-	tristate "HPT 372N/302N PATA support (Experimental)"
+	tristate "HPT 372N/302N PATA support"
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the N variant HPT PATA
@@ -401,7 +401,7 @@ config PATA_HPT3X3
 	  If unsure, say N.
 
 config PATA_HPT3X3_DMA
-	bool "HPT 343/363 DMA support (Experimental)"
+	bool "HPT 343/363 DMA support"
 	depends on PATA_HPT3X3
 	help
 	  This option enables DMA support for the HPT343/363
@@ -510,7 +510,7 @@ config PATA_NETCELL
 	  If unsure, say N.
 
 config PATA_NINJA32
-	tristate "Ninja32/Delkin Cardbus ATA support (Experimental)"
+	tristate "Ninja32/Delkin Cardbus ATA support"
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the Ninja32, Delkin and

