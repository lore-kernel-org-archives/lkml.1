Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab0BMNnY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 08:43:24 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:41586 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab0BMNnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 08:43:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ilCECa7yc/Wju4Qy4h8Q9E6xdhZ0YJusWkQknL/4hmav5Rc8K6maaIjaQtxTVeTOk1
         9bSxS2jUDLnoQrT48/tZ7fzSoNovIXjHR1VSbjoJa6OLoSyGmx60e5T/aVZhECduglGS
         pMY9yW2oDfhc9JVjTbvepJJ4IIH3upP3biLSo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
Date: Sat, 13 Feb 2010 14:36:05 +0100
Message-Id: <20100213133605.11564.60246.sendpatchset@localhost>
In-Reply-To: <20100213133538.11564.94218.sendpatchset@localhost>
References: <20100213133538.11564.94218.sendpatchset@localhost>
Subject: [PATCH 3/3] pata_pdc202xx_old: update documentation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_pdc202xx_old: update documentation

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/Kconfig |    1 -
 1 file changed, 1 deletion(-)

Index: b/drivers/ata/Kconfig
===================================================================
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -599,7 +599,6 @@ config PATA_PDC_OLD
 	  20265 and 20267 adapters.
 
 	  Known issues:
-	  - UDMA transfers fail mysteriously on some chipsets
 	  - ATAPI DMA is unsupported currently
 
 	  If unsure, say N.
