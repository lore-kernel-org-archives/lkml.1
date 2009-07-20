Return-Path: <linux-kernel-owner+w=401wt.eu-S1752260AbZGTGaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbZGTGaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 02:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbZGTGav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 02:30:51 -0400
Received: from mx40.brocade.com ([144.49.195.4]:26619 "EHLO mx40.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbZGTGau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 02:30:50 -0400
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jul 2009 02:30:50 EDT
X-IronPort-AV: E=Sophos;i="4.43,233,1246863600"; 
   d="scan'208";a="70237133"
Date: Sun, 19 Jul 2009 23:27:43 -0700
From: Jing Huang <huangj@brocade.com>
Message-Id: <200907200627.n6K6RhpX011701@swe57.brocade.com>
To: James.Bottomley@HansenPartnership.com
Subject: [PATCH 5/5] bfa: Brocade BFA FC SCSI driver (maint)
Cc: kgudipat@brocade.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com,
       xmzhang@brocade.com
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
--- orig/MAINTAINERS	2009-07-19 17:48:16.000000000 -0700
+++ patch/MAINTAINERS	2009-07-19 17:48:16.000000000 -0700
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
