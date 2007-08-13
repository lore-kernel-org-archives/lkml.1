Return-Path: <linux-kernel-owner+w=401wt.eu-S939336AbXHMGo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939336AbXHMGo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965285AbXHMGXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:23:10 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3589 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934790AbXHMGXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:23:07 -0400
Date: Sun, 12 Aug 2007 23:22:54 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, spyro@f2s.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [48/2many] MAINTAINERS - ARM MFM AND FLOPPY DRIVERS
Message-ID: <46bff8be.Rm2ImM7V7+lJ/DhO%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 435bafd..ca4a132 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -457,6 +457,9 @@ ARM MFM AND FLOPPY DRIVERS
 P:	Ian Molton
 M:	spyro@f2s.com
 S:	Maintained
+F:	arch/arm/lib/floppydma.S
+F:	drivers/block/floppy.c
+F:	drivers/asm-arm/floppy.h
 
 ARM PRIMECELL MMCI PL180/1 DRIVER
 P:	Russell King
