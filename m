Return-Path: <linux-kernel-owner+w=401wt.eu-S932124AbZIVRE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbZIVRE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 13:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932110AbZIVREx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 13:04:53 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40095 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106AbZIVREv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 13:04:51 -0400
Message-ID: <51337.192.168.10.88.1253639094.squirrel@dbdmail.itg.ti.com>
Date: Tue, 22 Sep 2009 22:34:54 +0530 (IST)
Subject: [PATCH 3/3] OMAP UART: Adding support for omap-serial driver.
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

This patch adds omap-serial driver support 3430SDP.

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

