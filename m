Return-Path: <linux-kernel-owner+w=401wt.eu-S1760734AbXJDJxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760734AbXJDJxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758981AbXJDJxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:53:11 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52697 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752510AbXJDJxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:53:09 -0400
Date: Thu, 4 Oct 2007 11:51:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Subject: sysrq docs: document sequence that actually works
Message-ID: <20071004095127.GA775@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Document sequence of keypresses that actually works. Yes, this changed
year-or-so ago.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/Documentation/sysrq.txt b/Documentation/sysrq.txt
index ef19142..10c8f69 100644
--- a/Documentation/sysrq.txt
+++ b/Documentation/sysrq.txt
@@ -43,7 +43,7 @@ On x86   - You press the key combo 'ALT-
            keyboards may not have a key labeled 'SysRq'. The 'SysRq' key is
            also known as the 'Print Screen' key. Also some keyboards cannot
 	   handle so many keys being pressed at the same time, so you might
-	   have better luck with "press Alt", "press SysRq", "release Alt",
+	   have better luck with "press Alt", "press SysRq", "release SysRq",
 	   "press <command key>", release everything.
 
 On SPARC - You press 'ALT-STOP-<command key>', I believe.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
