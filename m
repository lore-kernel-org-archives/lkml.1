Return-Path: <linux-kernel-owner+w=401wt.eu-S965618AbXHMMFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965618AbXHMMFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966379AbXHMGkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:40:17 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2483 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967496AbXHMGkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:40:08 -0400
Date: Sun, 12 Aug 2007 23:39:45 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       acme@ghostprotocols.net
Subject: [PATCH] [543/2many] MAINTAINERS - WL3501 WIRELESS PCMCIA CARD
 DRIVER
Message-ID: <46bffcb1.4pQ3AxPuL9R1oYU1%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index e1fd743..454494e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5134,6 +5134,7 @@ M:	acme@ghostprotocols.net
 L:	linux-wireless@vger.kernel.org
 W:	http://oops.ghostprotocols.net:81/blog
 S:	Maintained
+F:	drivers/net/wireless/wl3501*
 
 X.25 NETWORK LAYER
 P:	Henner Eisen
