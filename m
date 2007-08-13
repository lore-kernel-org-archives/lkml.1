Return-Path: <linux-kernel-owner+w=401wt.eu-S1030253AbXHMMSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030253AbXHMMSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967524AbXHMGm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:42:56 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2540 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967704AbXHMGmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:42:55 -0400
Date: Sun, 12 Aug 2007 23:29:02 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       khali@linux-fr.org, i2c@lm-sensors.org, akpm@linux-foundation.org
Subject: [PATCH] [231/2many] MAINTAINERS - I2C SUBSYSTEM
Message-ID: <46bffa2e.Gcwew3sHyZdFHycV%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 491a5a6..2c78350 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2199,6 +2199,9 @@ M:	khali@linux-fr.org
 L:	i2c@lm-sensors.org
 T:	quilt http://khali.linux-fr.org/devel/linux-2.6/jdelvare-i2c/
 S:	Maintained
+F:	Documentation/i2c/
+F:	drivers/i2c/
+F:	include/linux/i2c*
 
 I2C-TINY-USB DRIVER
 P:	Till Harbaum
