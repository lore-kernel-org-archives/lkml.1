Return-Path: <linux-kernel-owner+w=401wt.eu-S2992639AbXBQRCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992639AbXBQRCt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 12:02:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992617AbXBQRCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 12:02:37 -0500
Received: from smtp.nokia.com ([131.228.20.172]:57332 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992607AbXBQRBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 12:01:33 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Date: Sat, 17 Feb 2007 18:58:06 +0200
Message-Id: <20070217165806.5845.3473.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 44/44 take 2] [UBI] update MAINTAINERS
X-OriginalArrivalTime: 17 Feb 2007 16:57:33.0484 (UTC) FILETIME=[B7D096C0:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185525-03D79BB0-1C11BE25/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/MAINTAINERS tmp-to/MAINTAINERS
--- tmp-from/MAINTAINERS	2007-02-17 18:07:26.000000000 +0200
+++ tmp-to/MAINTAINERS	2007-02-17 18:07:28.000000000 +0200
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
