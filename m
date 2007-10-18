Return-Path: <linux-kernel-owner+w=401wt.eu-S1762730AbXJRJ7C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762730AbXJRJ7C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 05:59:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757924AbXJRJ6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 05:58:52 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:47073 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755641AbXJRJ6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 05:58:51 -0400
Date: Thu, 18 Oct 2007 12:00:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Kbuild <linux-kbuild@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       LKML <linux-kernel@vger.kernel.org>,
       kbuild devel <kbuild-devel@lists.sourceforge.net>
Subject: kbuild mailing list has moved
Message-ID: <20071018100019.GA18671@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The vger postmasters has created linux-kbuild on my request.

The old list at sourceforge had a few issues:
- it was subscriber-only
- it were relying on moderation

And I could see several mails did not get to the list lately
so I decided this was a good time for a new list.

I already requested marc.info to archieve the new list -
and I dunno where else the old list was archieved but we
ought to update.

I have no access to the list of subscribers on the old list
so people will have to subscribe manually.

How to subscribe:

send a mail to: majordomo@vger.kernel.org
containing following text:
subscribe linux-kbuild

See also http://vger.kernel.org/vger-lists.html

Below is a patch to update MAINTAINERS in the kernel.
Note that I expect the list to cover both pure kbuild
but also kconfig stuff.

	Sam

diff --git a/MAINTAINERS b/MAINTAINERS
index 10deabe..f978c60 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2178,7 +2178,7 @@ S:	Maintained
 KCONFIG
 P:	Roman Zippel
 M:	zippel@linux-m68k.org
-L:	kbuild-devel@lists.sourceforge.net
+L:	linux-kbuild@vger.kernel.org
 S:	Maintained
 
 KDUMP
@@ -2207,6 +2207,7 @@ KERNEL BUILD (kbuild: Makefile, scripts/Makefile.*)
 P:	Sam Ravnborg
 M:	sam@ravnborg.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/sam/kbuild.git
+L:	linux-kbuild@vger.kernel.org
 S:	Maintained
 
 KERNEL JANITORS
