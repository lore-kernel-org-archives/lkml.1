Return-Path: <linux-kernel-owner+w=401wt.eu-S935706AbXLQTz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935706AbXLQTz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933017AbXLQTlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:41:12 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3185 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933862AbXLQTlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:41:03 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       spi-devel-general@lists.sourceforge.net
Subject: [PATCH] drivers/spi/: Spelling fixes
Date: Mon, 17 Dec 2007 11:40:16 -0800
Message-Id: <1197920439-5455-10-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918893.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/spi/spi_imx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi_imx.c b/drivers/spi/spi_imx.c
index 2cd8573..639963e 100644
--- a/drivers/spi/spi_imx.c
+++ b/drivers/spi/spi_imx.c
@@ -157,7 +157,7 @@
 #define SPI_FIFO_BYTE_WIDTH		(2)
 #define SPI_FIFO_OVERFLOW_MARGIN	(2)
 
-/* DMA burst lenght for half full/empty request trigger */
+/* DMA burst length for half full/empty request trigger */
 #define SPI_DMA_BLR			(SPI_FIFO_DEPTH * SPI_FIFO_BYTE_WIDTH / 2)
 
 /* Dummy char output to achieve reads.
-- 
1.5.3.7.949.g2221a6

