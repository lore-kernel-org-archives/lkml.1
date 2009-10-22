Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbZJVTfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbZJVTfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 15:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756215AbZJVTfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 15:35:04 -0400
Received: from 139.254.232.72.static.reverse.ltdomains.com ([72.232.254.139]:56897
	"EHLO liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755951AbZJVTfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 15:35:03 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: trivial@kernel.org
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] trivial: fix double "of of" in comment in spidev code
Date: Thu, 22 Oct 2009 17:34:29 -0200
Message-Id: <1256240069-25223-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/spi/spidev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 5d23983..d9b4100 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -42,7 +42,7 @@
  * This supports acccess to SPI devices using normal userspace I/O calls.
  * Note that while traditional UNIX/POSIX I/O semantics are half duplex,
  * and often mask message boundaries, full SPI support requires full duplex
- * transfers.  There are several kinds of of internal message boundaries to
+ * transfers.  There are several kinds of internal message boundaries to
  * handle chipselect management and other protocol options.
  *
  * SPI has a character major number assigned.  We allocate minor numbers
-- 
1.6.3.3

