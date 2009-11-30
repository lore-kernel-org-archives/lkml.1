Return-Path: <linux-kernel-owner+w=401wt.eu-S1753061AbZK3Pr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbZK3Pr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 10:47:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbZK3PrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 10:47:25 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60880 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbZK3PrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 10:47:24 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
       Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH] MAINTAINERS: add tree and file pattern for ARM IMX
Date: Mon, 30 Nov 2009 16:47:14 +0100
Message-Id: <1259596034-18167-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <20091129202721.GA22137@pengutronix.de>
References: <20091129202721.GA22137@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
---
 MAINTAINERS |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c824b4d..f908bd8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -637,6 +637,9 @@ ARM/FREESCALE IMX / MXC ARM ARCHITECTURE
 M:	Sascha Hauer <kernel@pengutronix.de>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
+T:	git://git.pengutronix.de/git/imx/linux-2.6.git
+F:	arch/arm/mach-mx*/
+F:	arch/arm/plat-mxc
 
 ARM/GLOMATION GESBC9312SX MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-- 
1.6.5.2

