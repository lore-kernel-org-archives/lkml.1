Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbXHMLSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbXHMLSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965842AbXHMGiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:38:08 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2105 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938636AbXHMGho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:37:44 -0400
Date: Sun, 12 Aug 2007 23:37:23 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, tlinux-users@linux.toshiba-dme.co.jp,
       linux-kernel@vger.kernel.org, jonathan@buzzard.org.uk,
       akpm@linux-foundation.org
Subject: [PATCH] [480/2many] MAINTAINERS - TOSHIBA SMM DRIVER
Message-ID: <46bffc23.OZWI3zpYZY7agi2A%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index ba55e00..7927653 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4555,6 +4555,8 @@ M:	jonathan@buzzard.org.uk
 L:	tlinux-users@tce.toshiba-dme.co.jp
 W:	http://www.buzzard.org.uk/toshiba/
 S:	Maintained
+F:	drivers/char/toshiba.c
+F:	include/linux/toshiba.h
 
 TRIDENT 4DWAVE/SIS 7018 PCI AUDIO CORE
 P:	Muli Ben-Yehuda
