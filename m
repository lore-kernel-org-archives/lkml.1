Return-Path: <linux-kernel-owner+w=401wt.eu-S932465AbXHMKfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465AbXHMKfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967305AbXHMGgC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:36:02 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1794 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965988AbXHMGfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:35:53 -0400
Date: Sun, 12 Aug 2007 23:35:40 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, support@simtec.co.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [431/2many] MAINTAINERS - SIMTEC EB2410ITX (BAST)
Message-ID: <46bffbbc.OFXT+WO+Wtpvl8on%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 5b95582..71be2f5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4108,6 +4108,11 @@ P:	Vincent Sanders
 M:	support@simtec.co.uk
 W:	http://www.simtec.co.uk/products/EB2410ITX/
 S:	Supported
+F:	Documentation/arm/Samsung-S3C24XX/EB2410ITX.txt
+F:	arch/arm/mach-s3c2410/
+F:	drivers/*/*s3c2410*
+F:	drivers/*/*/*s3c2410*
+F:	include/asm-arm/arch-s3c2410/
 
 SIS 190 ETHERNET DRIVER
 P:	Francois Romieu
