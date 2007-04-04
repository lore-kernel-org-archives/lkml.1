Return-Path: <linux-kernel-owner+w=401wt.eu-S932097AbXDDSJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbXDDSJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbXDDSJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:09:21 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:37233 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbXDDSI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:08:59 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Komal Shah <komal_shah802003@yahoo.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 36/90] ARM: OMAP: Fix typo in board-h4.h
Date: Wed,  4 Apr 2007 14:05:15 -0400
Message-Id: <11757100661228-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757100641006-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!
 57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <117571004562-git-send-email-tony@atomide.com> <11757100491583-git-send-email-tony@atomide.com> <11757100511172-git-send-email-tony@atomide.com> <1175710059333-git-send-email-tony@atomide.com> <11757100623383-git-send-email-tony@atomide.com> <11757100641006-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Komal Shah <komal_shah802003@yahoo.com>

Replace OMAP1610 to OMAP2420.

Signed-off-by: Komal Shah <komal_shah802003@yahoo.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 include/asm-arm/arch-omap/board-h4.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-arm/arch-omap/board-h4.h b/include/asm-arm/arch-omap/board-h4.h
index 7ef664b..6cfc8e3 100644
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

