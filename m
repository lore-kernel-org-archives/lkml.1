Return-Path: <linux-kernel-owner+w=401wt.eu-S1760767AbYCUTCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760767AbYCUTCA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 15:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755977AbYCUTBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 15:01:52 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:60006 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbYCUTBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 15:01:51 -0400
Date: Fri, 21 Mar 2008 11:59:50 -0700
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com, joel.becker@oracle.com,
       kurt.hackel@oracle.com, mfasheh@suse.com
Subject: [git patches] ocfs2 MAINTAINERS update
Message-ID: <20080321185950.GR23981@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Oracle Corporation
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

	I've taken a new job at SUSE labs, so my e-mail address needs an
update. Going forward, I'll co-maintain Ocfs2 with Joel Becker so we need to
put his information in there as well. Kurt deserves a very large amount of
credit for his work on Ocfs2, but he has since moved on to other projects,
so we'll just put Joel in his spot.

	So, it should more or less be business as usual with respect to
Ocfs2, other than that Joel and I will share some of the maintainership
load.
	--Mark

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 MAINTAINERS |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

Mark Fasheh (1):
      ocfs2: MAINTAINERS update

diff --git a/MAINTAINERS b/MAINTAINERS
index 03e4602..73883b8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2935,9 +2935,9 @@ S:	Maintained
 
 ORACLE CLUSTER FILESYSTEM 2 (OCFS2)
 P:	Mark Fasheh
-M:	mark.fasheh@oracle.com
-P:	Kurt Hackel
-M:	kurt.hackel@oracle.com
+M:	mfasheh@suse.com
+P:	Joel Becker
+M:	joel.becker@oracle.com
 L:	ocfs2-devel@oss.oracle.com
 W:	http://oss.oracle.com/projects/ocfs2/
 S:	Supported
