Return-Path: <linux-kernel-owner+w=401wt.eu-S1754939Ab0AQVZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab0AQVZr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 16:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862Ab0AQVZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 16:25:46 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:39732 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab0AQVZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 16:25:46 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: trivial@kernel.org
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] trivial: fix typo s/leve/level/ in powerpc arch
Date: Sun, 17 Jan 2010 19:23:14 -0200
Message-Id: <1263763394-9572-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 arch/powerpc/mm/tlb_low_64e.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/mm/tlb_low_64e.S b/arch/powerpc/mm/tlb_low_64e.S
index f288279..8b04c54 100644
--- a/arch/powerpc/mm/tlb_low_64e.S
+++ b/arch/powerpc/mm/tlb_low_64e.S
@@ -1,5 +1,5 @@
 /*
- *  Low leve TLB miss handlers for Book3E
+ *  Low level TLB miss handlers for Book3E
  *
  *  Copyright (C) 2008-2009
  *      Ben. Herrenschmidt (benh@kernel.crashing.org), IBM Corp.
-- 
1.6.6

