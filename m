Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbZBPWve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbZBPWve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 17:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbZBPWvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 17:51:12 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43823 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbZBPWvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 17:51:10 -0500
Date: Mon, 16 Feb 2009 23:50:59 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Cc: Trivial patch monkey <trivial@kernel.org>
Subject: Update my contacts in maintainers
Message-ID: <20090216225058.GF1370@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


My @suse.cz address will stop working some day, so put working
one into MAINTAINERS/CREDITS. It would be cool to get this to
2.6.29... it should not really break anything.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

--- linux/MAINTAINERS~	2009-01-28 13:08:04.000000000 +0100
+++ linux/MAINTAINERS	2009-02-09 00:28:44.000000000 +0100
@@ -1965,7 +1965,7 @@
 
 HIBERNATION (aka Software Suspend, aka swsusp)
 P:	Pavel Machek
-M:	pavel@suse.cz
+M:	pavel@ucw.cz
 P:	Rafael J. Wysocki
 M:	rjw@sisk.pl
 L:	linux-pm@lists.linux-foundation.org
@@ -4075,7 +4075,7 @@
 P:	Len Brown
 M:	len.brown@intel.com
 P:	Pavel Machek
-M:	pavel@suse.cz
+M:	pavel@ucw.cz
 P:	Rafael J. Wysocki
 M:	rjw@sisk.pl
 L:	linux-pm@lists.linux-foundation.org
--- linux/CREDITS~	2009-01-28 13:07:55.000000000 +0100
+++ linux/CREDITS	2009-02-09 00:27:58.000000000 +0100
@@ -2156,7 +2156,6 @@
 
 N: Pavel Machek
 E: pavel@ucw.cz
-E: pavel@suse.cz
 D: Softcursor for vga, hypertech cdrom support, vcsa bugfix, nbd
 D: sun4/330 port, capabilities for elf, speedup for rm on ext2, USB,
 D: work on suspend-to-ram/disk, killing duplicates from ioctl32

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
