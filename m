Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbXGaKJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbXGaKJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 06:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbXGaKJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 06:09:04 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58899 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753911AbXGaKJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 06:09:02 -0400
Date: Tue, 31 Jul 2007 12:09:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: vgoyal@in.ibm.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       kernel list <linux-kernel@vger.kernel.org>, ebiederm@xmission.com
Subject: kexec/kdump: docs fix, stale urls?
Message-ID: <20070731100908.GD3462@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

This fixes few typos in kdump.txt. (Please check, I'm not native
speaker). 

Also, the urls pointed out in kdump.txt seem a bit old, are there
better pointers these days?

								Pavel

--- 

This fixes few typos in kdump.txt.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/Documentation/kdump/kdump.txt b/Documentation/kdump/kdump.txt
index eb60087..faf0e27 100644
--- a/Documentation/kdump/kdump.txt
+++ b/Documentation/kdump/kdump.txt
@@ -69,7 +69,7 @@ http://www.kernel.org/pub/linux/kernel/p
 
 This is a symlink to the latest version, which at the time of writing is
 20061214, the only release of kexec-tools-testing so far. As other versions
-are made released, the older onese will remain available at
+are released, the older ones will remain available at
 http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/
 
 Note: Latest kexec-tools-testing git tree is available at

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
