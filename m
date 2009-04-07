Return-Path: <linux-kernel-owner+w=401wt.eu-S1758111AbZDGOne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbZDGOne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 10:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757895AbZDGOmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 10:42:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43325 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757875AbZDGOmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 10:42:39 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 08/11] Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 07 Apr 2009 16:41:37 +0100
Message-ID: <20090407154135.17182.39026.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090407153824.17182.81672.stgit@t61.ukuu.org.uk>
References: <20090407153824.17182.81672.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/serial/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index f2e5736..1e2dd6f 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -707,7 +707,7 @@ choice
 
 config SERIAL_BFIN_DMA
 	bool "DMA mode"
-	depends on !DMA_UNCACHED_NONE && !KGDB_UART
+	depends on !DMA_UNCACHED_NONE && !KGDB_SERIAL_CONSOLE
 	help
 	  This driver works under DMA mode. If this option is selected, the
 	  blackfin simple dma driver is also enabled.

