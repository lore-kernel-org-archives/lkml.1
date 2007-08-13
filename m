Return-Path: <linux-kernel-owner+w=401wt.eu-S939988AbXHMM0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939988AbXHMM0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:26:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967581AbXHMGti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:49:38 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2578 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966149AbXHMGth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:49:37 -0400
Date: Sun, 12 Aug 2007 23:26:04 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dccp@vger.kernel.org, akpm@linux-foundation.org,
       acme@ghostprotocols.net
Subject: [PATCH] [148/2many] MAINTAINERS - DCCP PROTOCOL
Message-ID: <46bff97c.9avHEM3TinhF1DrA%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 7f54480..c786066 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1434,6 +1434,8 @@ M:	acme@ghostprotocols.net
 L:	dccp@vger.kernel.org
 W:	http://linux-net.osdl.org/index.php/DCCP
 S:	Maintained
+F:	include/linux/dccp.h
+F:	net/dccp/
 
 DECnet NETWORK LAYER
 P:	Patrick Caulfield
