Return-Path: <linux-kernel-owner+w=401wt.eu-S1422659AbXCIApc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422659AbXCIApc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 19:45:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422716AbXCIApc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 19:45:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422659AbXCIApb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 19:45:31 -0500
Date: Thu, 8 Mar 2007 19:45:26 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: update 'getting sparse' info.
Message-ID: <20070309004526.GA17459@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

- point to the sparse webpage
- use git:// instead of rsync://

Signed-off-by: Dave Jones <davej@redhat.com>

--- linux-2.6.20.noarch/Documentation/sparse.txt~	2007-03-08 19:40:30.000000000 -0500
+++ linux-2.6.20.noarch/Documentation/sparse.txt	2007-03-08 19:43:01.000000000 -0500
@@ -45,11 +45,15 @@ special.
 Getting sparse
 ~~~~~~~~~~~~~~
 
-With git, you can just get it from
+You can get latest released versions from the Sparse homepage at
+http://www.kernel.org/pub/linux/kernel/people/josh/sparse/
 
-        rsync://rsync.kernel.org/pub/scm/devel/sparse/sparse.git
+Alternatively, you can get snapshots of the latest development version
+of sparse using git to clone..
 
-and DaveJ has tar-balls at
+        git://git.kernel.org/pub/scm/linux/kernel/git/josh/sparse.git
+
+DaveJ has hourly generated tarballs of the git tree available at..
 
         http://www.codemonkey.org.uk/projects/git-snapshots/sparse/
 

-- 
http://www.codemonkey.org.uk
