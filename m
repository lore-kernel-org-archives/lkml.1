Return-Path: <linux-kernel-owner+w=401wt.eu-S943914AbXHMM3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943914AbXHMM3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939545AbXHMGxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:53:08 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2591 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939549AbXHMGxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:53:07 -0400
Date: Sun, 12 Aug 2007 23:39:19 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       khali@linux-fr.org, i2c@lm-sensors.org, akpm@linux-foundation.org
Subject: [PATCH] [529/2many] MAINTAINERS - VIAPRO SMBUS DRIVER
Message-ID: <46bffc97.nu3I60umAY56uv2e%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 23efbbc..392d697 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4994,6 +4994,8 @@ P:	Jean Delvare
 M:	khali@linux-fr.org
 L:	i2c@lm-sensors.org
 S:	Maintained
+F:	Documentation/i2c/busses/i2c-viapro
+F:	drivers/i2c/busses/i2c-viapro.c
 
 VIA VELOCITY NETWORK DRIVER
 P:	Francois Romieu
