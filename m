Return-Path: <linux-kernel-owner+w=401wt.eu-S934285AbZIOCNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934285AbZIOCNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 22:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbZIOCNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 22:13:46 -0400
Received: from mail.perches.com ([173.55.12.10]:1180 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860AbZIOCNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 22:13:46 -0400
Subject: [PATCH] MAINTAINERS: Integrate P:/M: lines
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Anil Ravindranath <anil_ravindranath@pmc-sierra.com>,
       Kalle Valo <kalle.valo@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Sep 2009 19:13:48 -0700
Message-Id: <1252980828.3966.7.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of new uses of separate "P: name" "M: address" lines
are converted to single line "M: name <address>"

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 837b598..aa545e2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4010,8 +4010,7 @@ F:	drivers/block/pktcdvd.c
 F:	include/linux/pktcdvd.h
 
 PMC SIERRA MaxRAID DRIVER
-P:	Anil Ravindranath
-M:	anil_ravindranath@pmc-sierra.com
+M:	Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
 L:	linux-scsi@vger.kernel.org
 W:	http://www.pmc-sierra.com/
 S:	Supported
@@ -5628,8 +5627,7 @@ S:	Maintained
 F:	drivers/input/misc/wistron_btns.c
 
 WL1251 WIRELESS DRIVER
-P:	Kalle Valo
-M:	kalle.valo@nokia.com
+M:	Kalle Valo <kalle.valo@nokia.com>
 L:	linux-wireless@vger.kernel.org
 W:	http://wireless.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git


