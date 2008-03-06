Return-Path: <linux-kernel-owner+w=401wt.eu-S936107AbYCFSO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936107AbYCFSO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 13:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935478AbYCFSM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 13:12:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37223 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935782AbYCFSM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 13:12:26 -0500
Subject: [UPDATED v3][PATCH 7/7] regulator: maintainers
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Thu, 06 Mar 2008 18:12:23 +0000
Message-Id: <1204827143.15360.153.camel@a10323.wolfsonmicro.main>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds Liam Girdwood and Mark Brown as regulator maintainers.

Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
---
 MAINTAINERS |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 558636e..d54212a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4286,6 +4286,15 @@ M:	kaber@trash.net
 L:	netdev@vger.kernel.org
 S:	Maintained
 
+VOLTAGE AND CURRENT REGULATOR FRAMEWORK
+P:	Liam Girdwood
+M:	lg@opensource.wolfsonmicro.com
+P:	Mark Brown
+M:	broonie@opensource.wolfsonmicro.com
+W:	http://opensource.wolfsonmicro.com/node/15
+T:	git opensource.wolfsonmicro.com:/linux-2.6-audioplus.git
+S:	Supported
+
 VT1211 HARDWARE MONITOR DRIVER
 P:	Juerg Haefliger
 M:	juergh@gmail.com
-- 
1.5.4.3



