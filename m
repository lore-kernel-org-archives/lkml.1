Return-Path: <linux-kernel-owner+w=401wt.eu-S1753551AbYJBIgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbYJBIgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 04:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbYJBIgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 04:36:09 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58666 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbYJBIgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 04:36:08 -0400
Date: Thu, 2 Oct 2008 10:14:28 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       randy.dunlap@oracle.com
Subject: make MAINTAINERS slightly easier to search
Message-ID: <20081002081428.GA2022@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...shall we add rule that subsystems will have "subsystem" in the name
so that search does not list all the drivers, first?

Signed-off-by: Pavel Machek <pavel@suse.cz>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


diff --git a/MAINTAINERS b/MAINTAINERS
index 3596d17..7345707 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3825,7 +3825,7 @@ L:	linux-kernel@vger.kernel.org
 W:	http://tifmxx.berlios.de/
 S:	Maintained
 
-SOUND
+SOUND SUBSYSTEM (ADVANCED LINUX SOUND SYSTEM, ALSA)
 P:	Jaroslav Kysela
 M:	perex@perex.cz
 L:	alsa-devel@alsa-project.org (subscribers-only)
@@ -3855,7 +3855,7 @@ L:	cbe-oss-dev@ozlabs.org
 W:	http://www.ibm.com/developerworks/power/cell/
 S:	Supported
 
-STABLE BRANCH:
+STABLE BRANCH
 P:	Greg Kroah-Hartman
 M:	greg@kroah.com
 P:	Chris Wright

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
