Return-Path: <linux-kernel-owner+w=401wt.eu-S1751200AbXCNPYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200AbXCNPYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750796AbXCNPYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:24:14 -0400
Received: from smtp.nokia.com ([131.228.20.172]:23718 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932926AbXCNPVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:21:35 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>
Date: Wed, 14 Mar 2007 17:21:20 +0200
Message-Id: <20070314152120.1112.32487.sendpatchset@localhost.localdomain>
In-Reply-To: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
Subject: [PATCH 21/22 take 3] UBI: update MAINTAINERS
X-OriginalArrivalTime: 14 Mar 2007 15:21:20.0117 (UTC) FILETIME=[6AF27250:01C7664C]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070314172121-537EBBB0-1235763E/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/MAINTAINERS tmp-to/MAINTAINERS
--- tmp-from/MAINTAINERS	2007-03-14 17:15:49.000000000 +0200
+++ tmp-to/MAINTAINERS	2007-03-14 17:15:50.000000000 +0200
@@ -2176,6 +2176,14 @@ L:	linux-mtd@lists.infradead.org
 T:	git git://git.infradead.org/mtd-2.6.git
 S:	Maintained
 
+UNSORTED BLOCK IMAGES (UBI)
+P:	Artem Bityutskiy
+M:	dedekind@infradead.org
+W:	http://www.linux-mtd.infradead.org/
+L:	linux-mtd@lists.infradead.org
+T:	git git://git.infradead.org/ubi-2.6.git
+S:	Maintained
+
 MICROTEK X6 SCANNER
 P:	Oliver Neukum
 M:	oliver@neukum.name
