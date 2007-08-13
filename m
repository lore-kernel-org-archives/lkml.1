Return-Path: <linux-kernel-owner+w=401wt.eu-S969866AbXHMJIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969866AbXHMJIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966936AbXHMGbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:31:34 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4978 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966939AbXHMGb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:31:27 -0400
Date: Sun, 12 Aug 2007 23:31:15 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, marcelo@kvack.org,
       linuxppc-embedded@ozlabs.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [294/2many] MAINTAINERS - LINUX FOR POWERPC EMBEDDED
 PPC8XX
Message-ID: <46bffab3.asnUCoB0NHzqk6/c%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index e295b18..896c8bf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2821,6 +2821,7 @@ M:	marcelo@kvack.org
 W:	http://www.penguinppc.org/
 L:	linuxppc-embedded@ozlabs.org
 S:	Maintained
+F:	arch/ppc/syslib/ppc8xx*
 
 LINUX FOR POWERPC EMBEDDED PPC83XX AND PPC85XX
 P:	Kumar Gala
