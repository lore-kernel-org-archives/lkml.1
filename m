Return-Path: <linux-kernel-owner+w=401wt.eu-S1756374AbZGUXSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374AbZGUXSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 19:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755356AbZGUXSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 19:18:23 -0400
Received: from mx10.brocade.com ([208.185.105.18]:27036 "EHLO mx10.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564AbZGUXSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 19:18:23 -0400
X-IronPort-AV: E=Sophos;i="4.43,242,1246863600"; 
   d="scan'208";a="205070876"
Date: Tue, 21 Jul 2009 16:18:23 -0700
From: Jing Huang <huangj@brocade.com>
Message-Id: <200907212318.n6LNIN1Q008029@swe57.brocade.com>
To: James.Bottomley@HansenPartnership.com
Subject: [PATCH 6/6] bfa: Brocade BFA FC SCSI driver (maint)
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
