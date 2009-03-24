Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbZCXAQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbZCXAQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 20:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbZCXAQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 20:16:09 -0400
Received: from mx40.brocade.com ([144.49.195.4]:46774 "EHLO mx40.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998AbZCXAQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 20:16:07 -0400
X-Greylist: delayed 355 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Mar 2009 20:16:07 EDT
X-IronPort-AV: E=Sophos;i="4.38,410,1233561600"; 
   d="scan'208";a="58367077"
Date: Mon, 23 Mar 2009 17:12:57 -0700
From: Krishna Gudipati <kgudipat@brocade.com>
Message-Id: <200903240012.n2O0CvRX014252@blc-10-2.brocade.com>
To: James.Bottomley@HansenPartnership.com
Subject: [PATCH 5/5] bfa: Brocade BFA FC SCSI driver (maint)
Cc: huangj@brocade.com, kgudipat@brocade.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krishna Chaitanya Gudipati <kgudipat@brocade.com>

This patch contains updated MAINTAINERS file.

Signed-off-by: Krishna Chaitanya Gudipati <kgudipat@brocade.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+)

diff -urpN orig/MAINTAINERS patch/MAINTAINERS
--- orig/MAINTAINERS	2009-03-23 15:33:17.121013000 -0700
+++ patch/MAINTAINERS	2009-03-23 15:33:17.101362000 -0700
@@ -1016,6 +1016,12 @@ M:	mchan@broadcom.com
 L:	netdev@vger.kernel.org
 S:	Supported
 
+BROCADE BFA FC SCSI DRIVER
+P:     Jing Huang
+M:     huangj@brocade.com
+L:     linux-scsi@vger.kernel.org
+S:     Supported
+
 BSG (block layer generic sg v4 driver)
 P:	FUJITA Tomonori
 M:	fujita.tomonori@lab.ntt.co.jp
