Return-Path: <linux-kernel-owner+w=401wt.eu-S971262AbXHMJKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971262AbXHMJKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966944AbXHMGbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:31:35 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4992 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966890AbXHMGbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:31:31 -0400
Date: Sun, 12 Aug 2007 23:31:16 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linuxppc-embedded@ozlabs.org,
       linux-kernel@vger.kernel.org, galak@kernel.crashing.org,
       akpm@linux-foundation.org
Subject: [PATCH] [295/2many] MAINTAINERS - LINUX FOR POWERPC EMBEDDED
 PPC83XX AND PPC85XX
Message-ID: <46bffab4.3GfGfPg42InTJWd+%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 896c8bf..a289176 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2829,6 +2829,7 @@ M:	galak@kernel.crashing.org
 W:	http://www.penguinppc.org/
 L:	linuxppc-embedded@ozlabs.org
 S:	Maintained
+F:	arch/ppc/syslib/ppc83xx_*
 
 LINUX FOR POWERPC PA SEMI PWRFICIENT
 P:	Olof Johansson
