Return-Path: <linux-kernel-owner+w=401wt.eu-S966046AbXDIVfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966046AbXDIVfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbXDIVet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:34:49 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:35163 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbXDIVeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:34:25 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Komal Shah <komal_shah802003@yahoo.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 2/7] ARM: OMAP: Fix typo in board-h4.h
Date: Mon,  9 Apr 2007 17:33:57 -0400
Message-Id: <11761544492069-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761544452798-git-send-email-tony@atomide.com>
References: <11761544421667-git-send-email-tony@atomide.com> <11761544452798-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Komal Shah <komal_shah802003@yahoo.com>

Replace OMAP1610 with OMAP2420.

Signed-off-by: Komal Shah <komal_shah802003@yahoo.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 include/asm-arm/arch-omap/board-h4.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

--- a/include/asm-arm/arch-omap/board-h4.h
+++ b/include/asm-arm/arch-omap/board-h4.h
@@ -1,7 +1,7 @@
 /*
  * linux/include/asm-arm/arch-omap/board-h4.h
  *
- * Hardware definitions for TI OMAP1610 H4 board.
+ * Hardware definitions for TI OMAP2420 H4 board.
  *
  * Initial creation by Dirk Behme <dirk.behme@de.bosch.com>
  *
-- 
1.4.4.2

