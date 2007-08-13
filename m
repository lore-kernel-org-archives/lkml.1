Return-Path: <linux-kernel-owner+w=401wt.eu-S1030361AbXHMJon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030361AbXHMJon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966940AbXHMGdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:33:23 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1318 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966950AbXHMGdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:33:16 -0400
Date: Sun, 12 Aug 2007 23:33:02 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, sreenivasa.honnur@neterion.com,
       sivakumar.subramani@neterion.com, santosh.rastapur@neterion.com,
       ram.vepa@neterion.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [350/2many] MAINTAINERS - NETERION (S2IO) Xframe 10GbE
 DRIVER
Message-ID: <46bffb1e.RWqUKBlIRRtufRxJ%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 6e78725..9e9775a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3373,6 +3373,8 @@ M:	sreenivasa.honnur@neterion.com
 L:	netdev@vger.kernel.org
 W:	http://trac.neterion.com/cgi-bin/trac.cgi/wiki/TitleIndex?anonymous
 S:	Supported
+F:	Documentation/networking/s2io.txt
+F:	drivers/net/s2io*
 
 OPENCORES I2C BUS DRIVER
 P:	Peter Korsgaard
