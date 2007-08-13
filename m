Return-Path: <linux-kernel-owner+w=401wt.eu-S1763817AbXHMKcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763817AbXHMKcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967217AbXHMGfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:35:52 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1774 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967291AbXHMGfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:35:45 -0400
Date: Sun, 12 Aug 2007 23:35:30 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, sds@tycho.nsa.gov,
       linux-kernel@vger.kernel.org, jmorris@namei.org, eparis@parisplace.org,
       akpm@linux-foundation.org
Subject: [PATCH] [426/2many] MAINTAINERS - SELINUX SECURITY MODULE
Message-ID: <46bffbb2.DuT+iothoJWb9xhc%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 9c3f1df..127502e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4057,10 +4057,12 @@ P:	James Morris
 M:	jmorris@namei.org
 P:	Eric Paris
 M:	eparis@parisplace.org
-L:	linux-kernel@vger.kernel.org (kernel issues)
-L: 	selinux@tycho.nsa.gov (subscribers-only, general discussion)
+L:	linux-kernel@vger.kernel.org
+L:	selinux@tycho.nsa.gov (subscribers-only)
 W:	http://www.nsa.gov/selinux
 S:	Supported
+F:	include/linux/selinux*
+F:	security/selinux/
 
 SENSABLE PHANTOM
 P:	Jiri Slaby
