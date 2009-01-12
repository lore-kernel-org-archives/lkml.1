Return-Path: <linux-kernel-owner+w=401wt.eu-S1758856AbZALWwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856AbZALWwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758421AbZALWgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:36:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44960 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777AbZALWgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:36:12 -0500
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@strlen.de>,
       trivial@kernel.org
Date: Mon, 12 Jan 2009 23:35:49 +0100
Message-Id: <1231799750-21060-4-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <alpine.LNX.1.10.0901122314361.5377@jikos.suse.cz>
References: <alpine.LNX.1.10.0901122314361.5377@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ukl@pengutronix.de
Subject: [PATCH] fix typo "virual" -> "virtual"
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <ukleinek@strlen.de>

Signed-off-by: Uwe Kleine-König <ukleinek@strlen.de>
Cc: trivial@kernel.org
---
 arch/arm/mach-netx/include/mach/netx-regs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-netx/include/mach/netx-regs.h b/arch/arm/mach-netx/include/mach/netx-regs.h
index 08c60ff..5a03e7c 100644
--- a/arch/arm/mach-netx/include/mach/netx-regs.h
+++ b/arch/arm/mach-netx/include/mach/netx-regs.h
@@ -80,7 +80,7 @@
 #define NETX_PA_XPEC(no) (NETX_IO_PHYS + NETX_OFS_XPEC(no))
 #define NETX_PA_VIC      (NETX_IO_PHYS + NETX_OFS_VIC)
 
-/* virual addresses */
+/* virtual addresses */
 #define NETX_VA_SYSTEM   (NETX_IO_VIRT + NETX_OFS_SYSTEM)
 #define NETX_VA_MEMCR    (NETX_IO_VIRT + NETX_OFS_MEMCR)
 #define NETX_VA_DPMAS    (NETX_IO_VIRT + NETX_OFS_DPMAS)
-- 
1.5.6.5

