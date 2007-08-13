Return-Path: <linux-kernel-owner+w=401wt.eu-S1758705AbXHMGzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705AbXHMGzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965955AbXHMGXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:23:42 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3688 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965298AbXHMGXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:23:40 -0400
Date: Sun, 12 Aug 2007 23:23:28 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, pleb@gelato.unsw.edu.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [66/2many] MAINTAINERS - ARM/PLEB SUPPORT
Message-ID: <46bff8e0.j+wrgm1yHJ/aPa7m%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 029f82f..3761d06 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -632,6 +632,8 @@ P:	Peter Chubb
 M:	pleb@gelato.unsw.edu.au
 W:	http://www.disy.cse.unsw.edu.au/Hardware/PLEB
 S:	Maintained
+F:	arch/arm/mach-sa1100/pleb.c
+F:	include/asm-arm/arch-sa1100/
 
 ARM/PT DIGITAL BOARD PORT
 P:	Stefan Eletzhofer
