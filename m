Return-Path: <linux-kernel-owner+w=401wt.eu-S1753035AbYGJPaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbYGJPaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 11:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759383AbYGJP1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 11:27:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45171 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759376AbYGJP1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 11:27:52 -0400
Subject: [PATCH 15/15] regulator: maintainers - add maintainers for
	regulator framework (new for V5)
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       arm kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Thu, 10 Jul 2008 16:27:51 +0100
Message-Id: <1215703671.13431.71.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Adds Liam Girdwood and Mark Brown as regulator framework maintainers.

Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
---
 MAINTAINERS |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6476125..551d231 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4424,6 +4424,15 @@ M:	kaber@trash.net
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



