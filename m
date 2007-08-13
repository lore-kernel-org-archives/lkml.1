Return-Path: <linux-kernel-owner+w=401wt.eu-S943984AbXHMLc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943984AbXHMLc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939268AbXHMGii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:38:38 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2209 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938009AbXHMGie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:38:34 -0400
Date: Sun, 12 Aug 2007 23:38:21 -0700
From: joe@perches.com
To: usb-storage@lists.one-eyed-alien.net, torvalds@linux-foundation.org,
       mdharm-usb@one-eyed-alien.net, linux-usb-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [500/2many] MAINTAINERS - USB MASS STORAGE DRIVER
Message-ID: <46bffc5d.iOp5UbUrexaidQ9h%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 94d4bac..0d6b162 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4730,6 +4730,7 @@ L:	linux-usb-users@lists.sourceforge.net
 L:	usb-storage@lists.one-eyed-alien.net
 S:	Maintained
 W:	http://www.one-eyed-alien.net/~mdharm/linux-usb/
+F:	drivers/usb/storage/
 
 USB OHCI DRIVER
 P:	David Brownell
