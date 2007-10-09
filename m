Return-Path: <linux-kernel-owner+w=401wt.eu-S1756477AbXJIPhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477AbXJIPhZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 11:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbXJIPhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 11:37:12 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:23240 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbXJIPhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 11:37:10 -0400
Date: Tue, 9 Oct 2007 08:36:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: zippel@linux-m68k.org, sam@ravnborg.org, akpm <akpm@linux-foundation.org>
Subject: [PATCH] maintainers: kbuild is subscribers-only
Message-Id: <20071009083600.b6c77078.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Mark the kbuild m-l as subscribers-only:

Your mail to 'kbuild-devel' with the subject
    Re: [RFC/RFT] kbuild: save ARCH & CROSS_COMPILE
Is being held until the list moderator can review it for approval.
The reason it is being held:
    Post by non-member to a members-only list

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.23-rc9-git6.orig/MAINTAINERS
+++ linux-2.6.23-rc9-git6/MAINTAINERS
@@ -2154,7 +2154,7 @@ S:	Maintained
 KCONFIG
 P:	Roman Zippel
 M:	zippel@linux-m68k.org
-L:	kbuild-devel@lists.sourceforge.net
+L:	kbuild-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
 
 KDUMP
