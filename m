Return-Path: <linux-kernel-owner+w=401wt.eu-S971297AbXHMJis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971297AbXHMJis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967068AbXHMGc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:32:57 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1237 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967047AbXHMGcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:32:48 -0400
Date: Sun, 12 Aug 2007 23:32:35 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org, linux-hams@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [336/2many] MAINTAINERS - NETROM NETWORK LAYER
Message-ID: <46bffb03./w2dyICYBc17xiWJ%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index d05ffcd..c448360 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3223,6 +3223,9 @@ M:	ralf@linux-mips.org
 L:	linux-hams@vger.kernel.org
 W:	http://www.linux-ax25.org/
 S:	Maintained
+F:	include/linux/netrom.h
+F:	include/net/netrom.h
+F:	net/netrom/
 
 NETWORK BLOCK DEVICE (NBD)
 P:	Paul Clements
