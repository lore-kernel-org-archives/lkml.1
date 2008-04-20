Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbYDTJFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbYDTJFz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 05:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYDTJFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 05:05:45 -0400
Received: from dns.hk.18mail.cn ([210.245.210.181]:55314 "EHLO
	hkm1.server.hk.18mail.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbYDTJFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 05:05:45 -0400
X-Greylist: delayed 3991 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Apr 2008 05:05:45 EDT
From: Zhang Wei <zw@zh-kernel.org>
To: dan.j.williams@intel.com
Cc: leoli@freescale.com, linux-kernel@vger.kernel.org,
       Zhang Wei <zw@zh-kernel.org>
Subject: fsldma:[PATCH] update the fsldma driver MAINTAINERS info.
Date: Sun, 20 Apr 2008 15:59:05 +0800
Message-Id: <1208678345-6722-1-git-send-email-zw@zh-kernel.org>
X-Mailer: git-send-email 1.5.3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Li Yang as the new maintainer for fsldma driver and update
my email address. 

Signed-off-by: Zhang Wei <zw@zh-kernel.org>
---
 MAINTAINERS |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e467758..812f0bf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1611,8 +1611,10 @@ W:	http://linux-fbdev.sourceforge.net/
 S:	Maintained
 
 FREESCALE DMA DRIVER
-P;	Zhang Wei
-M:	wei.zhang@freescale.com
+P:	Li Yang
+M:	leoli@freescale.com
+P:	Zhang Wei
+M:	zw@zh-kernel.org
 L:	linuxppc-embedded@ozlabs.org
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
-- 
1.5.3.8

