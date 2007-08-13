Return-Path: <linux-kernel-owner+w=401wt.eu-S968785AbXHMMEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968785AbXHMMEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967521AbXHMGkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:40:14 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2469 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965969AbXHMGkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:40:04 -0400
Date: Sun, 12 Aug 2007 23:39:49 -0700
From: joe@perches.com
To: xen-devel@lists.xensource.com, virtualization@lists.osdl.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jeremy@xensource.com, chrisw@sous-sol.org, akpm@linux-foundation.org
Subject: [PATCH] [545/2many] MAINTAINERS - XEN HYPERVISOR INTERFACE
Message-ID: <46bffcb5.o/KKCq3EZH4S47k3%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index e4e1cc3..8395aba 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5153,6 +5153,11 @@ M:	chrisw@sous-sol.org
 L:	virtualization@lists.osdl.org
 L:	xen-devel@lists.xensource.com
 S:	Supported
+F:	arch/i386/xen/
+F:	drivers/*/xen-*front.c
+F:	drivers/xen/
+F:	include/asm-i386/xen/
+F:	include/xen/
 
 XFS FILESYSTEM
 P:	Silicon Graphics Inc
