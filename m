Return-Path: <linux-kernel-owner+w=401wt.eu-S1763542AbXHMKeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763542AbXHMKeE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967221AbXHMGf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:35:58 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1790 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967223AbXHMGfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:35:52 -0400
Date: Sun, 12 Aug 2007 23:35:38 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, support@simtec.co.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [430/2many] MAINTAINERS - SIMTEC EB110ATX (Chalice CATS)
Message-ID: <46bffbba.v7z7PrRtxhMU2RFB%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index a4aa6af..5b95582 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4099,6 +4099,8 @@ P:	Vincent Sanders
 M:	support@simtec.co.uk
 W:	http://www.simtec.co.uk/products/EB110ATX/
 S:	Supported
+F:	arch/arm/mach-ebsa110/
+F:	include/asm-arm/arch-ebsa110/
 
 SIMTEC EB2410ITX (BAST)
 P:	Ben Dooks
