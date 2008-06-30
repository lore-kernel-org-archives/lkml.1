Return-Path: <linux-kernel-owner+w=401wt.eu-S933678AbYF3Vt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933678AbYF3Vt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933478AbYF3VlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:41:24 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:50446 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933468AbYF3VlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:41:12 -0400
Message-Id: <20080630214111.827217555@fluff.org.uk>
References: <20080630214023.140288591@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 30 Jun 2008 22:40:38 +0100
From: ben@fluff.org.uk
To: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
Cc: laforge@openmoko.org, tk@maintech.de, Ben Dooks <ben-linux@fluff.org>
Subject: [patch v5 15/16] MMC: S3C24XX: Add maintainer entry
Content-Disposition: inline; filename=simtec/s3c24xx-sdmmc-maintainer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Ben Dooks as S3C24XX SD/MMC driver maintainer.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc8-next20080627/MAINTAINERS
===================================================================
--- linux-2.6.26-rc8-next20080627.orig/MAINTAINERS	2008-06-30 12:14:40.000000000 +0100
+++ linux-2.6.26-rc8-next20080627/MAINTAINERS	2008-06-30 12:37:25.000000000 +0100
@@ -3544,6 +3544,13 @@ L:	linux-s390@vger.kernel.org
 W:	http://www.ibm.com/developerworks/linux/linux390/
 S:	Supported
 
+S3C24XX SD/MMC Driver
+P:	Ben Dooks
+M:	ben-linux@fluff.org
+L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+
 SAA7146 VIDEO4LINUX-2 DRIVER
 P:	Michael Hunold
 M:	michael@mihu.de

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
