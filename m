Return-Path: <linux-kernel-owner+w=401wt.eu-S1752447AbZH1IZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbZH1IZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 04:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbZH1IZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 04:25:51 -0400
Received: from hq-exedge.brocade.com ([66.243.153.82]:38781 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbZH1IZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 04:25:50 -0400
Date: Fri, 28 Aug 2009 01:25:52 -0700
From: Jing Huang <huangj@brocade.com>
Message-ID: <200908280825.n7S8PqkC005890@blc-10-6.brocade.com>
To: <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 14/14] bfa: Brocade BFA FC SCSI driver (maint)
CC: <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
       <rvadivel@brocade.com>, <vravindr@brocade.com>
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
--- orig/MAINTAINERS	2009-08-27 19:42:01.000000000 -0700
+++ patch/MAINTAINERS	2009-08-27 19:42:01.000000000 -0700
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
