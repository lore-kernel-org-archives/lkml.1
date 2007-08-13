Return-Path: <linux-kernel-owner+w=401wt.eu-S944760AbXHMLrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S944760AbXHMLrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966607AbXHMGj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:39:27 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2338 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967091AbXHMGjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:39:21 -0400
Date: Sun, 12 Aug 2007 23:39:07 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, pe1rxq@amsat.org,
       linux-usb-users@lists.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [523/2many] MAINTAINERS - USB ZD1201 DRIVER
Message-ID: <46bffc8b.uAEHT6MVkXPP6UnU%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 16ddb78..6cfd315 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4945,6 +4945,7 @@ L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 W:	http://linux-lc100020.sourceforge.net
 S:	Maintained
+F:	drivers/net/wireless/zd1201.*
 
 USB ZR364XX DRIVER
 P:	Antoine Jacquet
