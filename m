Return-Path: <linux-kernel-owner+w=401wt.eu-S2992917AbXCCCjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992917AbXCCCjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 21:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992914AbXCCCjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 21:39:14 -0500
Received: from [63.64.152.142] ([63.64.152.142]:1459 "EHLO gitlost.site"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992905AbXCCCjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 21:39:10 -0500
From: Chris Leech <christopher.leech@intel.com>
Subject: [PATCH 6/9] I/OAT: Add entries to MAINTAINERS for the DMA memcpy subsystem and ioatdma
Date: Fri, 02 Mar 2007 18:24:28 -0800
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Message-Id: <20070303022428.31033.35708.stgit@gitlost.site>
In-Reply-To: <20070303022238.31033.84558.stgit@gitlost.site>
References: <20070303022238.31033.84558.stgit@gitlost.site>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Leech <christopher.leech@intel.com>
---

 MAINTAINERS |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1dfba85..2dd5d23 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1156,6 +1156,12 @@ M:	tori@unhappy.mine.nu
 L:	netdev@vger.kernel.org
 S:	Maintained
 
+DMA GENERIC MEMCPY SUBSYSTEM
+P:	Chris Leech
+M:	christopher.leech@intel.com
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+
 DOCBOOK FOR DOCUMENTATION
 P:	Randy Dunlap
 M:	rdunlap@xenotime.net
@@ -1777,6 +1783,12 @@ P:	Tigran Aivazian
 M:	tigran@aivazian.fsnet.co.uk
 S:	Maintained
 
+INTEL I/OAT DMA DRIVER
+P:	Chris Leech
+M:	christopher.leech@intel.com
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+
 INTEL IXP4XX RANDOM NUMBER GENERATOR SUPPORT
 P:	Deepak Saxena
 M:	dsaxena@plexity.net

