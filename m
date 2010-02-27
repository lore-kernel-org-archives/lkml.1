Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030587Ab0B0Q7u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:59:50 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46242 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030513Ab0B0Q5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:57:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=EMjekn9SYqF01iIu5BK5p+iol6hfMfY+QQRUHHRs/HFegWK8Ho8QlAHQ6qKOV8JKBw
         VmEdAfdQN0IqZ8uj4GjmlNjUqppFSoGl2gldw36W8O+kN4YmYtRN7VWqGT0wFxpQU/If
         Rr0EmhqUy/nb72TMJZzwDStC/RKiRF5wP4gTY=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
       linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 57/66] arch/arm/plat-omap/include/plat/blizzard.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:38 +0100
Message-Id: <1267289508-31031-58-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/arm/plat-omap/include/plat/blizzard.h:9: ERROR: spaces prohibited around that ':' (ctx:WxW)

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/arm/plat-omap/include/plat/blizzard.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-omap/include/plat/blizzard.h b/arch/arm/plat-omap/include/plat/blizzard.h
index 8d160f1..56e7f2e 100644
--- a/arch/arm/plat-omap/include/plat/blizzard.h
+++ b/arch/arm/plat-omap/include/plat/blizzard.h
@@ -6,7 +6,7 @@ struct blizzard_platform_data {
 	void		(*power_down)(struct device *dev);
 	unsigned long	(*get_clock_rate)(struct device *dev);
 
-	unsigned	te_connected : 1;
+	unsigned	te_connected:1;
 };
 
 #endif
-- 
1.7.0.90.g251a4

