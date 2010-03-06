Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab0CFTJZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 14:09:25 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:53225 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab0CFTJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 14:09:24 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [mtd, nand] Remove stray endchoice from help text
Date: Sat, 06 Mar 2010 20:09:23 +0100
Message-ID: <8763591d3w.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ferenc Wagner <wferi@niif.hu>
---
 drivers/mtd/nand/Kconfig |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 677cd53..d68bd6e 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -358,8 +358,6 @@ config MTD_NAND_ATMEL_ECC_NONE
 
 	  If unsure, say N
 
-	  endchoice
-
 endchoice
 
 config MTD_NAND_PXA3xx
-- 
1.5.6.5

