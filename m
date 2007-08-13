Return-Path: <linux-kernel-owner+w=401wt.eu-S944546AbXHMLeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S944546AbXHMLeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965939AbXHMGil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:38:41 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2220 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939274AbXHMGij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:38:39 -0400
Date: Sun, 12 Aug 2007 23:38:26 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, mmcclell@bigfoot.com,
       linux-usb-users@lists.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [503/2many] MAINTAINERS - USB OV511 DRIVER
Message-ID: <46bffc62.Bdc5Y9mUzU0e4aQG%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 23b7c3d..d822865 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4755,6 +4755,7 @@ L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 W:	http://alpha.dyndns.org/ov511/
 S:	Maintained
+F:	drivers/media/video/ov511.*
 
 USB PEGASUS DRIVER
 P:	Petko Manolov
