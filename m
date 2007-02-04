Return-Path: <linux-kernel-owner+w=401wt.eu-S1751932AbXBDCZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbXBDCZR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 21:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbXBDCZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 21:25:16 -0500
Received: from imf23aec.mail.bellsouth.net ([205.152.59.71]:25607 "EHLO
	imf23aec.mail.bellsouth.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751932AbXBDCZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 21:25:15 -0500
Date: Sat, 3 Feb 2007 20:25:10 -0600
From: Jay Cliburn <jacliburn@bellsouth.net>
To: jeff@garzik.org
Cc: csnook@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net
Subject: [PATCH netdev#atl1 2/3] maintainers: add atl1 maintainers
Message-ID: <20070204022510.GC4063@osprey.hogchain.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Cliburn <jacliburn@bellsouth.net>

MAINTAINERS: add atl1 maintainers

Add a maintainers entry for atl1.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
---

 MAINTAINERS |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 465e083..825ea74 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -590,6 +590,16 @@ M:	ecashin@coraid.com
 W:	http://www.coraid.com/support/linux
 S:	Supported
 
+ATL1 ETHERNET DRIVER
+P:	Jay Cliburn
+M:	jcliburn@gmail.com
+P:	Chris Snook
+M:	csnook@redhat.com
+L:	atl1-devel@lists.sourceforge.net
+W:	http://sourceforge.net/projects/atl1
+W:	http://atl1.sourceforge.net
+S:	Maintained
+
 ATM
 P:	Chas Williams
 M:	chas@cmf.nrl.navy.mil
