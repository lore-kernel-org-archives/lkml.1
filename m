Return-Path: <linux-kernel-owner+w=401wt.eu-S969978AbXHMIgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969978AbXHMIgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966617AbXHMG3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:29:50 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4699 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966837AbXHMG3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:29:47 -0400
Date: Sun, 12 Aug 2007 23:29:28 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, stefanr@s5r6.in-berlin.de,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       ben.collins@ubuntu.com, akpm@linux-foundation.org
Subject: [PATCH] [244/2many] MAINTAINERS - IEEE 1394 SUBSYSTEM
Message-ID: <46bffa48.AcyjF9YPK9VTFwNb%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 2063c0f..26c460a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2312,6 +2312,7 @@ L:	linux1394-devel@lists.sourceforge.net
 W:	http://www.linux1394.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
 S:	Maintained
+F:	drivers/ieee/1394/
 
 IEEE 1394 RAW I/O DRIVER (raw1394)
 P:	Dan Dennedy
