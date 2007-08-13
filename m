Return-Path: <linux-kernel-owner+w=401wt.eu-S971964AbXHMJv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971964AbXHMJv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967048AbXHMGdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:33:44 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1373 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967119AbXHMGdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:33:32 -0400
Date: Sun, 12 Aug 2007 23:33:19 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, phil.el@wanadoo.fr,
       oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [359/2many] MAINTAINERS - OPROFILE
Message-ID: <46bffb2f.Vx+ONumoJ74QIl2T%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 89a586a..96aeb40 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3449,6 +3449,9 @@ P:	Philippe Elie
 M:	phil.el@wanadoo.fr
 L:	oprofile-list@lists.sf.net
 S:	Maintained
+F:	arch/*/oprofile/
+F:	drivers/oprofile/
+F:	include/linux/oprofile.h
 
 ORINOCO DRIVER
 P:	Pavel Roskin
