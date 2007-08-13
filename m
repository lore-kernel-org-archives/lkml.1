Return-Path: <linux-kernel-owner+w=401wt.eu-S970933AbXHMLmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970933AbXHMLmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967417AbXHMGjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:39:09 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2292 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967203AbXHMGjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:39:06 -0400
Date: Sun, 12 Aug 2007 23:38:52 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-usb-users@lists.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       greg@kroah.com, akpm@linux-foundation.org
Subject: [PATCH] [515/2many] MAINTAINERS - USB SERIAL KEYSPAN DRIVER
Message-ID: <46bffc7c.uZl/1S2uB+n8TJdl%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index df159d9..25500cc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4866,6 +4866,7 @@ L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 W:	http://www.kroah.com/linux/
 S:	Maintained
+F:	drivers/usb/serial/*keyspan*
 
 USB SERIAL WHITEHEAT DRIVER
 P:	Support Department
