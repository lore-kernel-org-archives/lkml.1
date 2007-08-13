Return-Path: <linux-kernel-owner+w=401wt.eu-S971150AbXHMJIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971150AbXHMJIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965290AbXHMGbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:31:31 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4971 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965017AbXHMGb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:31:26 -0400
Date: Sun, 12 Aug 2007 23:31:13 -0700
From: joe@perches.com
To: trini@kernel.crashing.org, torvalds@linux-foundation.org,
       linuxppc-embedded@ozlabs.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [293/2many] MAINTAINERS - LINUX FOR POWERPC BOOT CODE
Message-ID: <46bffab1.929TczOdDPFBpADQ%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 38810b7..e295b18 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2813,6 +2813,7 @@ M:	trini@kernel.crashing.org
 W:	http://www.penguinppc.org/
 L:	linuxppc-embedded@ozlabs.org
 S:	Maintained
+F:	arch/ppc/boot/
 
 LINUX FOR POWERPC EMBEDDED PPC8XX
 P:	Marcelo Tosatti
