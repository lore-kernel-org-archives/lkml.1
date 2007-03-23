Return-Path: <linux-kernel-owner+w=401wt.eu-S1753134AbXCWQon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbXCWQon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 12:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbXCWQon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 12:44:43 -0400
Received: from smtp.nokia.com ([131.228.20.172]:50970 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbXCWQol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 12:44:41 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Frank Haverkamp <haver@vnet.ibm.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>
Date: Fri, 23 Mar 2007 18:44:32 +0200
Message-Id: <20070323164432.8958.88075.sendpatchset@localhost.localdomain>
In-Reply-To: <20070323164256.8958.58377.sendpatchset@localhost.localdomain>
References: <20070323164256.8958.58377.sendpatchset@localhost.localdomain>
Subject: [PATCH 19/20 take 4] UBI: update MAINTAINERS
X-OriginalArrivalTime: 23 Mar 2007 16:44:32.0645 (UTC) FILETIME=[88718350:01C76D6A]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070323184433-202E6BB0-314F5412/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/MAINTAINERS tmp-to/MAINTAINERS
--- tmp-from/MAINTAINERS	2007-03-23 18:20:01.000000000 +0200
+++ tmp-to/MAINTAINERS	2007-03-23 18:20:02.000000000 +0200
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
