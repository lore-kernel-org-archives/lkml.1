Return-Path: <linux-kernel-owner+w=401wt.eu-S1751687AbXJNEPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbXJNEPv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 00:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbXJNEP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 00:15:26 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:40884 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbXJNEPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 00:15:25 -0400
Date: Sat, 13 Oct 2007 22:13:32 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 2/2] XilinxFB: typo bugfix
In-reply-to: <20071014040705.17867.42969.stgit@trillian.cg.shawcable.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>, paulus@ozlabs.org
Message-id: <20071014041332.17867.20597.stgit@trillian.cg.shawcable.net>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <20071014040705.17867.42969.stgit@trillian.cg.shawcable.net>
User-Agent: StGIT/0.12.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 drivers/video/xilinxfb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
index 6ef99b2..e38d3b7 100644
--- a/drivers/video/xilinxfb.c
+++ b/drivers/video/xilinxfb.c
@@ -84,7 +84,7 @@ static struct xilinxfb_platform_data xilinx_fb_default_pdata = {
 	.xres = 640,
 	.yres = 480,
 	.xvirt = 1024,
-	.yvirt = 480;
+	.yvirt = 480,
 };
 
 /*

