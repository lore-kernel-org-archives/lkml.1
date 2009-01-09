Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbZAIJhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbZAIJhh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 04:37:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbZAIJh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 04:37:28 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34918 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbZAIJh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 04:37:27 -0500
Date: Fri, 9 Jan 2009 10:39:34 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: list freezer as supported
Message-ID: <20090109093934.GA2857@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Now that people are using freezer for non-suspend/hibernation stuff,
perhaps it should have separate maintainers entry so that it is easier
to find?

What about something like this?

								Pavel

diff --git a/MAINTAINERS b/MAINTAINERS
index ce6e9a4..65b494f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1809,6 +1809,14 @@ M:	hch@infradead.org
 W:	ftp://ftp.openlinux.org/pub/people/hch/vxfs
 S:	Maintained
 
+FREEZER
+P:	Pavel Machek
+M:	pavel@suse.cz
+P:	Rafael J. Wysocki
+M:	rjw@sisk.pl
+L:	linux-pm@lists.linux-foundation.org
+S:	Supported
+
 FTRACE
 P:	Steven Rostedt
 M:	rostedt@goodmis.org

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
