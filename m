Return-Path: <linux-kernel-owner+w=401wt.eu-S1755813AbZGUUK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbZGUUK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 16:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755079AbZGUUK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 16:10:56 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2154 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548AbZGUUK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 16:10:56 -0400
Subject: [PATCH] MAINTAINERS: Update rtl8180 patterns
From: Joe Perches <joe@perches.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Tue, 21 Jul 2009 13:09:56 -0700
Message-Id: <1248206996.31365.300.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtl8180 files were moved into a subdirectory
by commit 1c740ed2210a0d124674a477ea538468aba47810

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 5befb1c..6e45e52 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4960,7 +4963,7 @@ L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
 S:	Maintained
-F:	drivers/net/wireless/rtl818*
+F:	drivers/net/wireless/rtl818x/rtl8180*
 
 RTL8187 WIRELESS DRIVER
 P:	Herton Ronaldo Krzesinski


