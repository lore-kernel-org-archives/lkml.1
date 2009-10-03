Return-Path: <linux-kernel-owner+w=401wt.eu-S1754076AbZJCIRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbZJCIRj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 04:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753921AbZJCIRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 04:17:39 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49658 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbZJCIRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 04:17:37 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 3 Oct 2009 10:17:29 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: add documentation entry to MAINTAINERS
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       Joe Perches <joe@perches.com>
In-Reply-To: <tkrat.f4970b0de587f089@s5r6.in-berlin.de>
Message-ID: <tkrat.e8df41aa057738d7@s5r6.in-berlin.de>
References: <1254262438-31323-1-git-send-email-justinmattock@gmail.com>
 <1254262438-31323-2-git-send-email-justinmattock@gmail.com>
 <tkrat.f4970b0de587f089@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the file pattern of drivers/ieee1394/init_ohci1394_dma.c's
documentation to the maintainers database.  init_ohci1394_dma.c is not
really part of the IEEE 1394 subsystem, but this maintainers contact
seems to be better than none at all.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.32-rc1/MAINTAINERS
===================================================================
--- linux-2.6.32-rc1.orig/MAINTAINERS
+++ linux-2.6.32-rc1/MAINTAINERS
@@ -2583,6 +2583,7 @@ L:	linux1394-devel@lists.sourceforge.net
 W:	http://www.linux1394.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
 S:	Maintained
+F:	Documentation/debugging-via-ohci1394.txt
 F:	drivers/ieee1394/
 
 IEEE 1394 RAW I/O DRIVER

-- 
Stefan Richter
-=====-==--= =-=- ---==
http://arcgraph.de/sr/

