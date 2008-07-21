Return-Path: <linux-kernel-owner+w=401wt.eu-S1758479AbYGUJtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479AbYGUJtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 05:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756162AbYGUJts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 05:49:48 -0400
Received: from bu3sch.de ([62.75.166.246]:58167 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755925AbYGUJtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 05:49:47 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] Add Documentation/ABI/testing/configfs-gpiommc
Date: Mon, 21 Jul 2008 11:47:18 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>,
       Piot Skamruk <piotr.skamruk@gmail.com>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>, openwrt-devel@lists.openwrt.org,
       Randy Dunlap <randy.dunlap@oracle.com>, Greg KH <greg@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807211147.19286.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a Documentation/ABI entry for the gpiommc configfs interface.

Signed-off-by: Michael Buesch <mb@bu3sch.de>


Index: linux-next/Documentation/ABI/testing/configfs-gpiommc
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-next/Documentation/ABI/testing/configfs-gpiommc	2008-07-21 11:43:59.000000000 +0200
@@ -0,0 +1,9 @@
+What:		/config/gpiommc/
+Date:		July 2008
+Contact:	Michael Buesch <mb@bu3sch.de>
+Description:
+		The /config/gpiommc/ directory consists of a group of
+		user-managable subdirectories for the dynamic registration
+		and removal of GPIO based MMC/SD cards.
+		Complete documentation is available in:
+		Documentation/gpiommc.txt

-- 
Greetings Michael.
