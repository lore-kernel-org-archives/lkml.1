Return-Path: <linux-kernel-owner+w=401wt.eu-S966639AbXHMJaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966639AbXHMJaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967038AbXHMGce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:32:34 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1187 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966896AbXHMGca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:32:30 -0400
Date: Sun, 12 Aug 2007 23:32:17 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, rgooch@atnf.csiro.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [326/2many] MAINTAINERS - MTRR AND SIMILAR SUPPORT [i386]
Message-ID: <46bffaf1.WYCzXdM6t8kqPZdt%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 502c6ff..88ef194 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3132,6 +3132,9 @@ M:	rgooch@atnf.csiro.au
 L:	linux-kernel@vger.kernel.org
 W:	http://www.atnf.csiro.au/~rgooch/linux/kernel-patches.html
 S:	Maintained
+F:	/Documentation/mtrr.txt
+F:	arch/i386/kernel/cpu/mtrr/
+F:	include/asm-i386/mtrr.h
 
 MULTIMEDIA CARD (MMC) AND SECURE DIGITAL (SD) SUBSYSTEM
 P:	Pierre Ossman
