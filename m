Return-Path: <linux-kernel-owner+w=401wt.eu-S932862AbZHDPVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862AbZHDPVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 11:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932832AbZHDPVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 11:21:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54050 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932826AbZHDPVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 11:21:49 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] S3C64XX: Add mapping for IISv4 port
Date: Tue,  4 Aug 2009 16:21:48 +0100
Message-Id: <1249399308-17019-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 arch/arm/mach-s3c6400/include/mach/map.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s3c6400/include/mach/map.h b/arch/arm/mach-s3c6400/include/mach/map.h
index 5057d99..41d01a9 100644
--- a/arch/arm/mach-s3c6400/include/mach/map.h
+++ b/arch/arm/mach-s3c6400/include/mach/map.h
@@ -46,6 +46,7 @@
 #define S3C64XX_PA_IIS1		(0x7F003000)
 #define S3C64XX_PA_TIMER	(0x7F006000)
 #define S3C64XX_PA_IIC0		(0x7F004000)
+#define S3C64XX_PA_IISV4	(0x7F00D000)
 #define S3C64XX_PA_IIC1		(0x7F00F000)
 
 #define S3C64XX_PA_GPIO		(0x7F008000)
-- 
1.6.3.3

