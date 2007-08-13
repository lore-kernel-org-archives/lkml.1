Return-Path: <linux-kernel-owner+w=401wt.eu-S968084AbXHMHte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968084AbXHMHte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966413AbXHMG0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:26:53 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4230 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966411AbXHMG0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:26:52 -0400
Date: Sun, 12 Aug 2007 23:26:31 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jrv@vanzandt.mv.com, blinux-list@redhat.com, akpm@linux-foundation.org
Subject: [PATCH] [161/2many] MAINTAINERS - DOUBLETALK DRIVER
Message-ID: <46bff997.psi71ogXahmBnAhm%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index b8ff492..0939e34 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1572,6 +1572,8 @@ P:	James R. Van Zandt
 M:	jrv@vanzandt.mv.com
 L:	blinux-list@redhat.com
 S:	Maintained
+F:	drivers/char/dtlk.c
+F:	include/linux/dtlk.h
 
 DRIVER CORE, KOBJECTS, AND SYSFS
 P:	Greg Kroah-Hartman
