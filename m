Return-Path: <linux-kernel-owner+w=401wt.eu-S1752381AbXHMKa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbXHMKa0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966559AbXHMGfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:35:41 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1742 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967287AbXHMGfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:35:36 -0400
Date: Sun, 12 Aug 2007 23:35:23 -0700
From: joe@perches.com
To: vladislav.yasevich@hp.com, torvalds@linux-foundation.org, sri@us.ibm.com,
       lksctp-developers@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [422/2many] MAINTAINERS - SCTP PROTOCOL
Message-ID: <46bffbab.Fcf5Bo8xP+9Fu1NV%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 2e15975..a1e3a1a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4016,6 +4016,10 @@ M:	sri@us.ibm.com
 L:	lksctp-developers@lists.sourceforge.net
 W:	http://lksctp.sourceforge.net
 S:	Supported
+F:	Documentation/networking/sctp.txt
+F:	include/linux/sctp.h
+F:	include/net/sctp/
+F:	net/sctp/
 
 SCx200 CPU SUPPORT
 P:	Jim Cromie
