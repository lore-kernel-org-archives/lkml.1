Return-Path: <linux-kernel-owner+w=401wt.eu-S1763662AbXGJVR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763662AbXGJVR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 17:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758640AbXGJVRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 17:17:52 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:46041 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755944AbXGJVRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 17:17:51 -0400
Date: Tue, 10 Jul 2007 23:17:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Suspend MAINTAINERS update
Message-ID: <20070710211755.GA8493@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I guess it is time to clarify that suspend and hibernation are
separate things, and add Rafael as a maintainer. Plus, people blame us
for suspend problems, anyway, I guess it is fair to mark us as suspend
maintainers, too.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Acked-by: Rafael J. Wysocki" <rjw@sisk.pl>

diff --git a/MAINTAINERS b/MAINTAINERS
index df40a4e..7cbe8e9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3269,9 +3269,19 @@ M:	neilb@suse.de
 L:	linux-raid@vger.kernel.org
 S:	Supported
 
-SOFTWARE SUSPEND:
+HIBERNATION (aka Software Suspend, aka swsusp):
 P:	Pavel Machek
 M:	pavel@suse.cz
+P:	Rafael J. Wysocki
+M:	rjw@sisk.pl
+L:	linux-pm@lists.linux-foundation.org
+S:	Supported
+
+SUSPEND TO RAM:
+P:	Pavel Machek
+M:	pavel@suse.cz
+P:	Rafael J. Wysocki
+M:	rjw@sisk.pl
 L:	linux-pm@lists.linux-foundation.org
 S:	Maintained
 


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
