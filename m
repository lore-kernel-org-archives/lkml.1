Return-Path: <linux-kernel-owner+w=401wt.eu-S933145AbXHMJ6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145AbXHMJ6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967089AbXHMGeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:34:01 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1446 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967146AbXHMGdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:33:52 -0400
Date: Sun, 12 Aug 2007 23:33:38 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, sailer@ife.ee.ethz.ch,
       linux-sound@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [369/2many] MAINTAINERS - PCI SOUND DRIVERS (ES1370,
 ES1371 and SONICVIBES)
Message-ID: <46bffb42.66N9BeQ36i0N7cgE%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 93f385f..59ba494 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3552,6 +3552,9 @@ M:	sailer@ife.ee.ethz.ch
 L:	linux-sound@vger.kernel.org
 W:	http://www.ife.ee.ethz.ch/~sailer/linux/pciaudio.html
 S:	Maintained
+F:	sound/pci/ens1370.c
+F:	sound/pci/ens1371.c
+F:	sound/pci/sonicvibes.c
 
 PCI SUBSYSTEM
 P:	Greg Kroah-Hartman
