Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbZHTH0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbZHTH0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 03:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbZHTH0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 03:26:15 -0400
Received: from mx30.brocade.com ([144.49.194.4]:36077 "EHLO mx30.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918AbZHTH0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 03:26:14 -0400
X-IronPort-AV: E=Sophos;i="4.43,413,1246863600"; 
   d="scan'208";a="89435455"
Date: Thu, 20 Aug 2009 00:26:15 -0700
From: Jing Huang <huangj@brocade.com>
Message-Id: <200908200726.n7K7QFrY008613@swe57.brocade.com>
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
--- orig/MAINTAINERS	2009-08-19 17:48:00.000000000 -0700
+++ patch/MAINTAINERS	2009-08-19 17:48:00.000000000 -0700
@@ -1158,6 +1158,13 @@ L:	netdev@vger.kernel.org
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
 M:	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
 L:	linux-scsi@vger.kernel.org
