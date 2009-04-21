Return-Path: <linux-kernel-owner+w=401wt.eu-S1757515AbZDUVJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515AbZDUVJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 17:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756062AbZDUVJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 17:09:08 -0400
Received: from c60.cesmail.net ([216.154.195.49]:33524 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756030AbZDUVJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 17:09:07 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH] mach-l7200: fix spelling of SYS_CLOCK_OFF
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Date: Tue, 21 Apr 2009 17:09:05 -0400
Message-ID: <20090421210905.11040.24685.stgit@mj.roinet.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 arch/arm/mach-l7200/include/mach/sys-clock.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-l7200/include/mach/sys-clock.h b/arch/arm/mach-l7200/include/mach/sys-clock.h
index 2d7722b..e9729a3 100644
--- a/arch/arm/mach-l7200/include/mach/sys-clock.h
+++ b/arch/arm/mach-l7200/include/mach/sys-clock.h
@@ -18,7 +18,7 @@
 
 /* IO_START and IO_BASE are defined in hardware.h */
 
-#define SYS_CLOCK_START (IO_START + SYS_CLCOK_OFF)  /* Physical address */
+#define SYS_CLOCK_START (IO_START + SYS_CLOCK_OFF)  /* Physical address */
 #define SYS_CLOCK_BASE  (IO_BASE  + SYS_CLOCK_OFF)  /* Virtual address  */
 
 /* Define the interface to the SYS_CLOCK */
