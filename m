Return-Path: <linux-kernel-owner+w=401wt.eu-S942439AbXHMHlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942439AbXHMHlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966305AbXHMG00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:26:26 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4158 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966299AbXHMG0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:26:25 -0400
Date: Sun, 12 Aug 2007 23:26:06 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, patrick@tykepenguin.com,
       linux-kernel@vger.kernel.org, linux-decnet-user@lists.sourceforge.net,
       akpm@linux-foundation.org
Subject: [PATCH] [149/2many] MAINTAINERS - DECnet NETWORK LAYER
Message-ID: <46bff97e.vVlPgIbC9AktbnVy%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index c786066..02bdd54 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1443,6 +1443,8 @@ M:	patrick@tykepenguin.com
 W:	http://linux-decnet.sourceforge.net
 L:	linux-decnet-user@lists.sourceforge.net
 S:	Maintained
+F:	Documentation/networking/decnet.txt
+F:	net/decnet/
 
 DEFXX FDDI NETWORK DRIVER
 P:	Maciej W. Rozycki
