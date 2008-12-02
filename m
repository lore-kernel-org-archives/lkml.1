Return-Path: <linux-kernel-owner+w=401wt.eu-S1755600AbYLBPmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbYLBPmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 10:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbYLBPkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 10:40:55 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:34946 "EHLO
	teyla.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751487AbYLBPkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 10:40:51 -0500
Message-Id: <20081202154113.108407626@fluff.org.uk>
References: <20081202154018.906091477@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Tue, 02 Dec 2008 15:40:26 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org,
       drzeus-sdhci@drzeus.cx
Cc: Ben Dooks <ben-linux@fluff.org>
Subject: [patch 8/8] SDHCI: Add maintainers entry for Samsung SoC
Content-Disposition: inline; filename=simtec/s3c64xx/sdhci-maintainers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a maintainers entry for myself as the mainatiner
of the Samsung SoC SDHCI glue layer

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux.git/MAINTAINERS
===================================================================
--- linux.git.orig/MAINTAINERS	2008-12-01 23:39:25.000000000 +0000
+++ linux.git/MAINTAINERS	2008-12-02 14:13:39.000000000 +0000
@@ -3720,6 +3720,13 @@ L:	sdhci-devel@list.drzeus.cx
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
 
+SDHCI SAMSUNG SoC DRIVER
+P:	Ben Dooks
+M:	ben-linux@fluff.org
+L:	sdhci-devel@list.drzeus.cx
+L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+S:	Maintained
+
 SECURITY CONTACT
 P:	Security Officers
 M:	security@kernel.org

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
