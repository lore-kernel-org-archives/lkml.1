Return-Path: <linux-kernel-owner+w=401wt.eu-S1753350AbXHMG4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbXHMG4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:56:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965962AbXHMGXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:23:42 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3691 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965949AbXHMGXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:23:41 -0400
Date: Sun, 12 Aug 2007 23:23:26 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dirk@opfer-online.de, akpm@linux-foundation.org
Subject: [PATCH] [65/2many] MAINTAINERS - ARM/TOSA MACHINE SUPPORT
Message-ID: <46bff8de.L53QGn6vUCnHASWx%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 6387b12..029f82f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -624,6 +624,8 @@ ARM/TOSA MACHINE SUPPORT
 P:	Dirk Opfer
 M:	dirk@opfer-online.de
 S:	Maintained
+F:	arch/arm/mach-pxa/tosa.c
+F:	include/asm-arm/arch-pxa/
 
 ARM/PLEB SUPPORT
 P:	Peter Chubb
