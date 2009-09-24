Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638AbZIXBMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbZIXBMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 21:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbZIXBMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 21:12:10 -0400
Received: from hq-exedge.brocade.com ([66.243.153.82]:31185 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbZIXBMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 21:12:09 -0400
Date: Wed, 23 Sep 2009 18:12:12 -0700
From: Jing Huang <huangj@brocade.com>
Message-ID: <200909240112.n8O1CCY5024345@swe58.brocade.com>
To: <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 14/14] bfa: Brocade BFA FC SCSI driver (maint)
CC: <kgudipat@brocade.com>, <linux-kernel@vger.kernel.org>,
       <linux-scsi@vger.kernel.org>, <rvadivel@brocade.com>,
       <vravindr@brocade.com>
MIME-Version: 1.0
Content-Type: text/plain
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
--- orig/MAINTAINERS	2009-09-23 15:59:21.000000000 -0700
+++ patch/MAINTAINERS	2009-09-23 15:59:21.000000000 -0700
@@ -1158,6 +1158,13 @@ L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/tg3.*
 
+BROCADE BFA FC SCSI DRIVER
+P:      Jing Huang
+M:      huangj@brocade.com
+L:      linux-scsi@vger.kernel.org
+S:      Supported
+F:      drivers/scsi/bfa/
+
 BSG (block layer generic sg v4 driver)
 M:	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
 L:	linux-scsi@vger.kernel.org
