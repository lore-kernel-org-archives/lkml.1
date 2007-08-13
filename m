Return-Path: <linux-kernel-owner+w=401wt.eu-S971028AbXHMJHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971028AbXHMJHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966884AbXHMGba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:31:30 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4968 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966850AbXHMGbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:31:25 -0400
Date: Sun, 12 Aug 2007 23:31:09 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, tnt@246tNt.com,
       linuxppc-embedded@ozlabs.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [291/2many] MAINTAINERS - LINUX FOR POWERPC EMBEDDED
 MPC52XX
Message-ID: <46bffaad.AUgmjGFlO0xv860X%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 8282088..0862965 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2795,6 +2795,8 @@ W:	http://www.penguinppc.org/
 L:	linuxppc-dev@ozlabs.org
 L:	linuxppc-embedded@ozlabs.org
 S:	Maintained
+F:	arch/powerpc/platforms/52xx/
+F:	include/asm-powerpc/mpc52xx.h
 
 LINUX FOR POWERPC EMBEDDED PPC4XX
 P:	Matt Porter
