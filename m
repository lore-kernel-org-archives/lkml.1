Return-Path: <linux-kernel-owner+w=401wt.eu-S1763921AbXHVRu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763921AbXHVRu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 13:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761713AbXHVRuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 13:50:18 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1079 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759745AbXHVRuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 13:50:17 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm] move-a-few-definitions-to-au1000_xxs1500c.patch fix
Date: Wed, 22 Aug 2007 19:50:12 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, yoichi_yuasa@tripeaks.co.jp,
       linux@dominikbrodowski.net, ralf@linux-mips.org
References: <200708172027.l7HKRg8T028011@imap1.linux-foundation.org>
In-Reply-To: <200708172027.l7HKRg8T028011@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708221950.13223.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	This patch fixes unbalanced parenthesis introduced by:

move-a-few-definitions-to-au1000_xxs1500c.patch

Regards,

	Mariusz

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/pcmcia/au1000_xxs1500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.23-rc3-mm1-a/drivers/pcmcia/au1000_xxs1500.c	2007-08-22 17:18:28.000000000 +0200
+++ linux-2.6.23-rc3-mm1-b/drivers/pcmcia/au1000_xxs1500.c	2007-08-22 17:20:34.000000000 +0200
@@ -52,7 +52,7 @@
 #include <asm/au1000_pcmcia.h>

 #define PCMCIA_MAX_SOCK		0
-#define PCMCIA_NUM_SOCKS	PCMCIA_MAX_SOCK + 1)
+#define PCMCIA_NUM_SOCKS	(PCMCIA_MAX_SOCK + 1)
 #define PCMCIA_IRQ		AU1000_GPIO_4

 #if 0
