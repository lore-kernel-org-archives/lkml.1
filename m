Return-Path: <linux-kernel-owner+w=401wt.eu-S937051AbXHMKio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937051AbXHMKio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967318AbXHMGgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:36:10 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1820 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967294AbXHMGgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:36:01 -0400
Date: Sun, 12 Aug 2007 23:35:48 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, mhoffman@lightlink.com,
       lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [435/2many] MAINTAINERS - SIS 96X I2C/SMBUS DRIVER
Message-ID: <46bffbc4./AOzDIg28g0KVR/0%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index b74e343..761029d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4142,6 +4142,8 @@ P:	Mark M. Hoffman
 M:	mhoffman@lightlink.com
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/i2c/busses/i2c-sis96x
+F:	drivers/i2c/busses/i2c-sis96x.c
 
 SIS FRAMEBUFFER DRIVER
 P:	Thomas Winischhofer
