Return-Path: <linux-kernel-owner+w=401wt.eu-S933859AbYBTRMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933859AbYBTRMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758868AbYBTRJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:09:30 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35656 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752864AbYBTRJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:09:29 -0500
Subject: [PATCH 6/6] regulator: add maintainers.
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 17:09:26 +0000
Message-Id: <1203527366.4071.94.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added Liam Girdwood and Mark Brown as maintainers.

Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
---
 MAINTAINERS |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 082d1ee..1f7d3ce 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4254,6 +4254,15 @@ M:	kaber@trash.net
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
1.5.4.2



