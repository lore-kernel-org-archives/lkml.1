Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbYIZBIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbYIZBIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 21:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbYIZBIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 21:08:46 -0400
Received: from mx40.brocade.com ([144.49.195.4]:6042 "EHLO mx40.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418AbYIZBIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 21:08:45 -0400
X-IronPort-AV: E=Sophos;i="4.33,310,1220252400"; 
   d="scan'208";a="39839515"
Date: Thu, 25 Sep 2008 18:08:43 -0700
From: Jing Huang <huangj@brocade.com>
Message-Id: <200809260108.m8Q18hMX028743@swe37.brocade.com>
To: James.Bottomley@HansenPartnership.com
Subject: [PATCH 6/6] bfa: Brocade BFA FC SCSI driver submission (2nd try)
Cc: huangj@brocade.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, rvadivel@brocade.com, srayas@brocade.com,
       vravindr@brocade.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jing Huang <huangj@brocade.com>

This patch contains updated MAINTAINERS file. It is created using
2.6.27-rc7 kernel.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+)

diff -urpN orig/MAINTAINERS patch/MAINTAINERS
--- orig/MAINTAINERS	2008-09-24 13:40:12.000000000 -0700
+++ patch/MAINTAINERS	2008-09-24 13:44:25.000000000 -0700
@@ -995,6 +995,12 @@ M:	mchan@broadcom.com
 L:	netdev@vger.kernel.org
 S:	Supported
 
+BROCADE BFA FC SCSI DRIVER
+P:	Jing Huang 
+M:	huangj@brocade.com
+L:	linux-scsi@vger.kernel.org
+S:	Supported
+
 BSG (block layer generic sg v4 driver)
 P:	FUJITA Tomonori
 M:	fujita.tomonori@lab.ntt.co.jp
