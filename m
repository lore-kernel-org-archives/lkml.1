Return-Path: <linux-kernel-owner+w=401wt.eu-S966749AbXHMMRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966749AbXHMMRs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966921AbXHMGmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:42:43 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2537 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967777AbXHMGml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:42:41 -0400
Date: Sun, 12 Aug 2007 23:29:04 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, till@harbaum.org,
       linux-kernel@vger.kernel.org, i2c@lm-sensors.org,
       akpm@linux-foundation.org
Subject: [PATCH] [232/2many] MAINTAINERS - I2C-TINY-USB DRIVER
Message-ID: <46bffa30.GWmcp+60bI7IUrAi%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 2c78350..5f90c75 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2209,6 +2209,7 @@ M:	till@harbaum.org
 L:	i2c@lm-sensors.org
 T:	http://www.harbaum.org/till/i2c_tiny_usb
 S:	Maintained
+F:	drivers/i2c/busses/i2c-tiny-usb.c
 
 i386 BOOT CODE
 P:	H. Peter Anvin
