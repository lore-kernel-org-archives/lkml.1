Return-Path: <linux-kernel-owner+w=401wt.eu-S936977AbXHMLkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936977AbXHMLkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967406AbXHMGjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:39:00 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2273 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967322AbXHMGi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:38:58 -0400
Date: Sun, 12 Aug 2007 23:38:46 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-usb-users@lists.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [512/2many] MAINTAINERS - USB SERIAL CYBERJACK
 PINPAD/E-COM DRIVER
Message-ID: <46bffc76.CcP1HxhDbZBhFQbF%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index e540357..8b4d497 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4841,6 +4841,7 @@ USB SERIAL CYBERJACK PINPAD/E-COM DRIVER
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Maintained
+F:	drivers/usb/serial/cyberjack.c
 
 USB AUERSWALD DRIVER
 P:	Wolfgang Muees
