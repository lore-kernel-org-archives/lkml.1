Return-Path: <linux-kernel-owner+w=401wt.eu-S970310AbXHMInL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970310AbXHMInL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966368AbXHMGaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:30:12 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4738 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966856AbXHMGaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:30:02 -0400
Date: Sun, 12 Aug 2007 23:29:08 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       akpm@linux-foundation.org
Subject: [PATCH] [234/2many] MAINTAINERS - i386 SETUP CODE / CPU ERRATA
 WORKAROUNDS
Message-ID: <46bffa34.otqRRuQcGyden3eA%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index d8287d7..802960b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2227,6 +2227,8 @@ P:	H. Peter Anvin
 M:	hpa@zytor.com
 T:	git.kernel.org:/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git
 S:	Maintained
+F:	arch/i386/kernel/setup.c
+F:	include/asm-i386/setup.h
 
 IA64 (Itanium) PLATFORM
 P:	Tony Luck
