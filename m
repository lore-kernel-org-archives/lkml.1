Return-Path: <linux-kernel-owner+w=401wt.eu-S1753673AbXDTVWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbXDTVWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 17:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbXDTVWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 17:22:45 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53168 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673AbXDTVWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 17:22:44 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 20 Apr 2007 23:21:35 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: update MAINTAINERS database
To: Ben Collins <ben.collins@ubuntu.com>,
       Jody McIntyre <scjody@modernduck.com>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Message-ID: <tkrat.04564966d265736f@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  - update Ben's address
  - replace Ben's contact by mine as raw1394's 2nd contact
  - eth1394's and pcilynx's maintenance doesn't really differ from that
    of other parts of the stack like video1394

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Ben, is this correct?


 MAINTAINERS |   22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

Index: linux/MAINTAINERS
===================================================================
--- linux.orig/MAINTAINERS
+++ linux/MAINTAINERS
@@ -1681,7 +1681,7 @@ S:	Maintained
 
 IEEE 1394 SUBSYSTEM
 P:	Ben Collins
-M:	bcollins@debian.org
+M:	ben.collins@ubuntu.com
 P:	Stefan Richter
 M:	stefanr@s5r6.in-berlin.de
 L:	linux1394-devel@lists.sourceforge.net
@@ -1689,25 +1689,11 @@ W:	http://www.linux1394.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
 S:	Maintained
 
-IEEE 1394 IPV4 DRIVER (eth1394)
-P:	Stefan Richter
-M:	stefanr@s5r6.in-berlin.de
-L:	linux1394-devel@lists.sourceforge.net
-S:	Odd Fixes
-
-IEEE 1394 PCILYNX DRIVER
-P:	Jody McIntyre
-M:	scjody@modernduck.com
-P:	Stefan Richter
-M:	stefanr@s5r6.in-berlin.de
-L:	linux1394-devel@lists.sourceforge.net
-S:	Odd Fixes
-
-IEEE 1394 RAW I/O DRIVER
-P:	Ben Collins
-M:	bcollins@debian.org
+IEEE 1394 RAW I/O DRIVER (raw1394)
 P:	Dan Dennedy
 M:	dan@dennedy.org
+P:	Stefan Richter
+M:	stefanr@s5r6.in-berlin.de
 L:	linux1394-devel@lists.sourceforge.net
 S:	Maintained
 

-- 
Stefan Richter
-=====-=-=== -=-- =-=--
http://arcgraph.de/sr/

