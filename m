Return-Path: <linux-kernel-owner+w=401wt.eu-S1752353AbZIZOBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353AbZIZOBc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 10:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbZIZOBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 10:01:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:59058 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbZIZOBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 10:01:30 -0400
Subject: [PATCH] ARM: Remove unused CONFIG reference DEBUG_S3C_PORT
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Byungho Min <bhmin@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 26 Sep 2009 19:30:58 +0530
Message-Id: <1253973658.4568.10.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove unused CONFIG reference DEBUG_S3C_PORT from defconfig

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Byungho Min <bhmin@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>
---
 arch/arm/configs/s5pc100_defconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/configs/s5pc100_defconfig b/arch/arm/configs/s5pc100_defconfig
index b0d7d3d..94edde5 100644
--- a/arch/arm/configs/s5pc100_defconfig
+++ b/arch/arm/configs/s5pc100_defconfig
@@ -859,7 +859,6 @@ CONFIG_DEBUG_ERRORS=y
 # CONFIG_DEBUG_STACK_USAGE is not set
 CONFIG_DEBUG_LL=y
 # CONFIG_DEBUG_ICEDCC is not set
-CONFIG_DEBUG_S3C_PORT=y
 CONFIG_DEBUG_S3C_UART=0
 
 #
-- 
1.6.0.6


