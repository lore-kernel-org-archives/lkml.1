Return-Path: <linux-kernel-owner+w=401wt.eu-S1759375AbYJWXMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375AbYJWXMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 19:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758718AbYJWXKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 19:10:20 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4771 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757229AbYJWXJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 19:09:49 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Pavel Machek <pavel@suse.cz>,
       =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@strlen.de>
Subject: [PATCH 8/8] MAINTAINERS - Add FTRACE git
Date: Thu, 23 Oct 2008 16:09:26 -0700
Message-Id: <66391b81e34252acf0541e83d6dad3d6c4f787ae.1224802312.git.joe@perches.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <fbea7757e53ac2eb8fe950ce703f2168c6c68d36.1224802312.git.joe@perches.com>
References: <1224803366-6478-1-git-send-email-joe@perches.com>
 <ab48bcafb1ceab1c0d53e93781605603cfabf6dc.1224802312.git.joe@perches.com>
 <f3c9f31c59a20acbc8b7535878ab6c86ba6630de.1224802312.git.joe@perches.com>
 <f1526bde1c026c2b5f439a97f96ec587705229e5.1224802312.git.joe@perches.com>
 <61cf615d8a20ad2608cb1c2fbad67ff4253a8457.1224802312.git.joe@perches.com>
 <92e881c3c6b7068ee07f8415be9071cfcea2175c.1224802312.git.joe@perches.com>
 <1a29dd9705091501c849a7c96678aa1a4796a836.1224802312.git.joe@perches.com>
 <fbea7757e53ac2eb8fe950ce703f2168c6c68d36.1224802312.git.joe@perches.com>
In-Reply-To: <ab48bcafb1ceab1c0d53e93781605603cfabf6dc.1224802312.git.joe@perches.com>
References: <ab48bcafb1ceab1c0d53e93781605603cfabf6dc.1224802312.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 99c5080..b68c5a4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2140,40 +2140,41 @@ F:	drivers/serial/ucc_uart.c
 
 FREESCALE SOC SOUND DRIVERS
 P:	Timur Tabi
 M:	timur@freescale.com
 L:	alsa-devel@alsa-project.org
 L:	linuxppc-dev@ozlabs.org
 S:	Supported
 F:	sound/soc/fsl/
 
 FREEVXFS FILESYSTEM
 P:	Christoph Hellwig
 M:	hch@infradead.org
 W:	ftp://ftp.openlinux.org/pub/people/hch/vxfs
 S:	Maintained
 F:	fs/freevxfs/
 
 FTRACE
 P:	Steven Rostedt
 M:	srostedt@redhat.com
 S:	Maintained
+T:	git git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip.git
 F:	Documentation/ftrace.txt
 F:	arch/*/*/*/ftrace.h
 F:	arch/*/kernel/ftrace.c
 F:	include/*/ftrace.h
 F:	kernel/trace/
 
 FUJITSU FR-V (FRV) PORT
 P:	David Howells
 M:	dhowells@redhat.com
 S:	Maintained
 F:	arch/frv/
 F:	include/asm-frv/
 
 FUJITSU LAPTOP EXTRAS
 P:	Jonathan Woithe
 M:	jwoithe@physics.adelaide.edu.au
 L:	linux-acpi@vger.kernel.org
 S:	Maintained
 F:	drivers/misc/fujitsu-laptop.c
 
-- 
1.6.0.2

