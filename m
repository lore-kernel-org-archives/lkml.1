Return-Path: <linux-kernel-owner+w=401wt.eu-S1764290AbYEOR6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764290AbYEOR6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763572AbYEOR6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:58:33 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:41362 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764184AbYEOR6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:58:32 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Re: 2.6.26-rc2-mm1 - fix parenthesis in include/asm-arm/arch-omap/control.h
Date: Thu, 15 May 2008 19:58:26 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <20080514010129.4f672378.akpm@linux-foundation.org>
In-Reply-To: <20080514010129.4f672378.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805151958.26764.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parenthesis fix in include/asm-arm/arch-omap/control.h

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

diff -upr linux-2.6.26-rc2-mm1-a/include/asm-arm/arch-omap/control.h linux-2.6.26-rc2-mm1-b/include/asm-arm/arch-omap/control.h
--- linux-2.6.26-rc2-mm1-a/include/asm-arm/arch-omap/control.h	2008-05-15 19:44:38.000000000 +0200
+++ linux-2.6.26-rc2-mm1-b/include/asm-arm/arch-omap/control.h	2008-05-15 19:51:30.000000000 +0200
@@ -80,7 +80,7 @@
 #define OMAP24XX_CONTROL_SEC_TAP	(OMAP2_CONTROL_GENERAL + 0x0064)
 #define OMAP24XX_CONTROL_OCM_PUB_RAM_ADD	(OMAP2_CONTROL_GENERAL + 0x006c)
 #define OMAP24XX_CONTROL_EXT_SEC_RAM_START_ADD	(OMAP2_CONTROL_GENERAL + 0x0070)
-#define OMAP24XX_CONTROL_EXT_SEC_RAM_STOP_ADD	(OMAP2_CONTROL_GENERAL + 0x0074
+#define OMAP24XX_CONTROL_EXT_SEC_RAM_STOP_ADD	(OMAP2_CONTROL_GENERAL + 0x0074)
 #define OMAP24XX_CONTROL_SEC_STATUS		(OMAP2_CONTROL_GENERAL + 0x0080)
 #define OMAP24XX_CONTROL_SEC_ERR_STATUS		(OMAP2_CONTROL_GENERAL + 0x0084)
 #define OMAP24XX_CONTROL_STATUS			(OMAP2_CONTROL_GENERAL + 0x0088)
	
