Return-Path: <linux-kernel-owner+w=401wt.eu-S1757380AbZA0S7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbZA0S7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 13:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756074AbZA0S7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 13:59:19 -0500
Received: from mx30.brocade.com ([144.49.194.4]:60661 "EHLO mx30.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757194AbZA0S7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 13:59:16 -0500
X-IronPort-AV: E=Sophos;i="4.37,333,1231142400"; 
   d="scan'208";a="63610118"
Date: Tue, 27 Jan 2009 10:55:58 -0800
From: Jing Huang <huangj@brocade.com>
Message-Id: <200901271855.n0RItwOP026944@swe37.brocade.com>
To: James.Bottomley@HansenPartnership.com
Subject: [PATCH 5/5] bfa: Brocade BFA FC SCSI driver submission
Cc: kgudipat@brocade.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jing Huang <huangj@brocade.com>

This patch contains updated MAINTAINERS file. It is created using
2.6.29-rc2 kernel.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+)

diff -urpN orig/MAINTAINERS patch/MAINTAINERS
--- orig/MAINTAINERS	2009-01-26 17:28:27.000000000 -0800
+++ patch/MAINTAINERS	2009-01-26 17:28:27.000000000 -0800
@@ -1009,6 +1009,12 @@ M:	mchan@broadcom.com
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
