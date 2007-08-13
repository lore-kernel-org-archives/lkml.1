Return-Path: <linux-kernel-owner+w=401wt.eu-S1030489AbXHMM3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030489AbXHMM3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:29:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968316AbXHMGwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:52:23 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2584 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968307AbXHMGwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:52:21 -0400
Date: Sun, 12 Aug 2007 23:25:53 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, acme@ghostprotocols.net
Subject: [PATCH] [143/2many] MAINTAINERS - CYCLADES 2X SYNC CARD DRIVER
Message-ID: <46bff971.L389oiN6pCwDMwYn%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 062e662..b816e4d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1379,6 +1379,7 @@ P:	Arnaldo Carvalho de Melo
 M:	acme@ghostprotocols.net
 W:	http://oops.ghostprotocols.net:81/blog
 S:	Maintained
+F:	drivers/net/wan/cycx*
 
 CYCLADES ASYNC MUX DRIVER
 W:	http://www.cyclades.com/
