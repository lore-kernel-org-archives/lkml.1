Return-Path: <linux-kernel-owner+w=401wt.eu-S970692AbXHMJEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970692AbXHMJEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966456AbXHMGbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:31:20 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4948 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966925AbXHMGbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:31:18 -0400
Date: Sun, 12 Aug 2007 23:31:05 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [289/2many] MAINTAINERS - LINUX FOR POWERPC
Message-ID: <46bffaa9.Up0nOpoPeVCIyvqc%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index c643ebe..1d1da70 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2775,6 +2775,8 @@ W:	http://www.penguinppc.org/
 L:	linuxppc-dev@ozlabs.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/paulus/powerpc.git
 S:	Supported
+F:	arch/powerpc
+F:	include/asm-powerpc/
 
 LINUX FOR POWER MACINTOSH
 P:	Benjamin Herrenschmidt
