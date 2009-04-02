Return-Path: <linux-kernel-owner+w=401wt.eu-S1763805AbZDBDjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763805AbZDBDjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 23:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755087AbZDBDjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 23:39:00 -0400
Received: from mx10.brocade.com ([208.185.105.18]:29613 "EHLO mx10.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430AbZDBDi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 23:38:59 -0400
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Apr 2009 23:38:59 EDT
X-IronPort-AV: E=Sophos;i="4.39,310,1235980800"; 
   d="scan'208";a="174156688"
Date: Wed, 1 Apr 2009 20:35:47 -0700
From: Krishna Gudipati <kgudipat@brocade.com>
Message-Id: <200904020335.n323Zl7F004493@blc-10-2.brocade.com>
To: James.Bottomley@HansenPartnership.com
Subject: [PATCH 5/5] bfa: Brocade BFA FC SCSI driver (maint)
Cc: huangj@brocade.com, kgudipat@brocade.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, nkattang@brocade.com, rvadivel@brocade.com,
       vravindr@brocade.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krishna Chaitanya Gudipati <kgudipat@brocade.com>

This patch contains updated MAINTAINERS file.

Signed-off-by: Krishna Chaitanya Gudipati <kgudipat@brocade.com>
---
 MAINTAINERS |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff -urpN orig/MAINTAINERS patch/MAINTAINERS
--- orig/MAINTAINERS	2009-04-01 20:08:51.279209000 -0700
+++ patch/MAINTAINERS	2009-04-01 20:08:51.259600000 -0700
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
@@ -3350,8 +3356,10 @@ S:	Maintained
 PARISC ARCHITECTURE
 P:	Kyle McMartin
 M:	kyle@mcmartin.ca
-P:	Helge Deller
-M:	deller@gmx.de
+P:	Matthew Wilcox
+M:	matthew@wil.cx
+P:	Grant Grundler
+M:	grundler@parisc-linux.org
 L:	linux-parisc@vger.kernel.org
 W:	http://www.parisc-linux.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/kyle/parisc-2.6.git
@@ -3876,15 +3884,6 @@ L:	linux-ide@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
 S:	Supported
 
-SERVER ENGINES 10Gbps NIC - BladeEngine 2 DRIVER
-P:	Sathya Perla
-M:	sathyap@serverengines.com
-P:      Subbu Seetharaman
-M:      subbus@serverengines.com
-L:      netdev@vger.kernel.org
-W:      http://www.serverengines.com
-S:      Supported
-
 SFC NETWORK DRIVER
 P:	Steve Hodgson
 P:	Ben Hutchings
