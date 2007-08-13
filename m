Return-Path: <linux-kernel-owner+w=401wt.eu-S969179AbXHMI6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969179AbXHMI6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966705AbXHMGbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:31:06 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4907 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966900AbXHMGbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:31:04 -0400
Date: Sun, 12 Aug 2007 23:30:45 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, nfs@lists.sourceforge.net, neilb@suse.de,
       linux-kernel@vger.kernel.org, bfields@fieldses.org,
       akpm@linux-foundation.org
Subject: [PATCH] [279/2many] MAINTAINERS - KERNEL NFSD
Message-ID: <46bffa95.aPjsc88tjaey80vh%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 0ac42ee..6e955c9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2675,6 +2675,8 @@ M:	neilb@suse.de
 L:	nfs@lists.sourceforge.net
 W:	http://nfs.sourceforge.net/
 S:	Supported
+F:	fs/nfsd/
+F:	include/linux/nfsd/
 
 KERNEL VIRTUAL MACHINE (KVM)
 P:	Avi Kivity
