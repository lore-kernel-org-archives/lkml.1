Return-Path: <linux-kernel-owner+w=401wt.eu-S971018AbXHMLlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971018AbXHMLlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966746AbXHMGjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:39:07 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2285 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966771AbXHMGjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:39:05 -0400
Date: Sun, 12 Aug 2007 23:38:50 -0700
From: joe@perches.com
To: xavyer@ix.netcom.com, torvalds@linux-foundation.org,
       linux-usb-users@lists.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [514/2many] MAINTAINERS - USB SERIAL EMPEG EMPEG-CAR MARK I/II DRIVER
Message-ID: <46bffc7a.zKblkVoIzLUwXmHa%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 42830d6..df159d9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4857,6 +4857,7 @@ M:	xavyer@ix.netcom.com
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Maintained
+F:	drivers/usb/serial/empeg.c
 
 USB SERIAL KEYSPAN DRIVER
 P:	Greg Kroah-Hartman
