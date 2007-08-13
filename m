Return-Path: <linux-kernel-owner+w=401wt.eu-S932754AbXHMKOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754AbXHMKOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932216AbXHMGel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:34:41 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1570 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937286AbXHMGeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:34:36 -0400
Date: Sun, 12 Aug 2007 23:34:18 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, rml@tech9.net, linux-kernel@vger.kernel.org,
       kpreempt-tech@lists.sourceforge.net, akpm@linux-foundation.org
Subject: [PATCH] [388/2many] MAINTAINERS - PREEMPTIBLE KERNEL
Message-ID: <46bffb6a.50yPvha9bJinN3mC%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 8d754e2..049c63b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3708,6 +3708,8 @@ L:	linux-kernel@vger.kernel.org
 L:	kpreempt-tech@lists.sourceforge.net
 W:	ftp://ftp.kernel.org/pub/linux/kernel/people/rml/preempt-kernel
 S:	Supported
+F:	Documentation/preempt-locking.txt
+F:	include/linux/preempt.h
 
 PRISM54 WIRELESS DRIVER
 P:	Luis R. Rodriguez
