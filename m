Return-Path: <linux-kernel-owner+w=401wt.eu-S1751923AbZIXK1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbZIXK1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 06:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbZIXK1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 06:27:45 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50694 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbZIXK1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 06:27:40 -0400
Message-ID: <65505.192.168.10.89.1253788062.squirrel@dbdmail.itg.ti.com>
Date: Thu, 24 Sep 2009 15:57:42 +0530 (IST)
Subject: [PATCHv1 3/3] OMAP UART: Add omap-serial driver support in 
     omap_3430sdp_defconfig
From: "Govindraj.R" <govindraj.raja@ti.com>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Govindraj R <govindraj.raja@ti.com>

This patch adds omap-serial driver support for 3430SDP.

Signed-off-by:	Govindraj R <govindraj.raja@ti.com>
---
 arch/arm/configs/omap_3430sdp_defconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/omap_3430sdp_defconfig b/arch/arm/configs/omap_3430sdp_defconfig
index 8a4a7e2..787d52e 100644
--- a/arch/arm/configs/omap_3430sdp_defconfig
+++ b/arch/arm/configs/omap_3430sdp_defconfig
@@ -880,6 +880,7 @@ CONFIG_SERIAL_8250_RSA=y
 #
 CONFIG_SERIAL_CORE=y
 CONFIG_SERIAL_CORE_CONSOLE=y
+# CONFIG_SERIAL_OMAP is not set
 CONFIG_UNIX98_PTYS=y
 # CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
 # CONFIG_LEGACY_PTYS is not set


