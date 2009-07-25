Return-Path: <linux-kernel-owner+w=401wt.eu-S1755112AbZGYG0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbZGYG0N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 02:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755095AbZGYG0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 02:26:12 -0400
Received: from gate08out.mcdata.com ([144.49.195.4]:41796 "EHLO
	mx40.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087AbZGYG0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 02:26:09 -0400
X-IronPort-AV: E=Sophos;i="4.43,268,1246863600"; 
   d="scan'208";a="70891112"
Date: Fri, 24 Jul 2009 23:26:09 -0700
From: Jing Huang <huangj@brocade.com>
Message-Id: <200907250626.n6P6Q98A026194@swe57.brocade.com>
To: James.Bottomley@HansenPartnership.com
Subject: [PATCH 14/14] bfa: Brocade BFA FC SCSI driver (maint)
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       rvadivel@brocade.com, vravindr@brocade.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jing Huang <huangj@brocade.com>

This patch contains updated MAINTAINERS file.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 MAINTAINERS |    7 +++++++
 1 files changed, 7 insertions(+)

diff -urpN orig/MAINTAINERS patch/MAINTAINERS
--- orig/MAINTAINERS	2009-07-21 15:34:07.000000000 -0700
+++ patch/MAINTAINERS	2009-07-21 15:34:07.000000000 -0700
@@ -1254,6 +1254,13 @@ L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/tg3.*
 
+BROCADE BFA FC SCSI DRIVER
+P:	Jing Huang
+M:	huangj@brocade.com
+L:	linux-scsi@vger.kernel.org
+S:	Supported
+F:	drivers/scsi/bfa/
+
 BSG (block layer generic sg v4 driver)
 P:	FUJITA Tomonori
 M:	fujita.tomonori@lab.ntt.co.jp
