Return-Path: <linux-kernel-owner+w=401wt.eu-S1946597AbXBIQGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946597AbXBIQGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946566AbXBIQF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:05:56 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53629 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946573AbXBIQFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:05:22 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] missing include in macsonic
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org
Message-Id: <E1HFYFW-0004rK-0m@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 16:05:22 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/macsonic.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/macsonic.c b/drivers/net/macsonic.c
index 24f6050..8ca57a0 100644
--- a/drivers/net/macsonic.c
+++ b/drivers/net/macsonic.c
@@ -49,6 +49,7 @@
 #include <linux/skbuff.h>
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
+#include <linux/bitrev.h>
 
 #include <asm/bootinfo.h>
 #include <asm/system.h>
-- 
1.5.0-rc2.GIT


