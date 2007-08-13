Return-Path: <linux-kernel-owner+w=401wt.eu-S939199AbXHML0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939199AbXHML0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:26:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939215AbXHMGiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:38:19 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2155 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965914AbXHMGiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:38:16 -0400
Date: Sun, 12 Aug 2007 23:38:02 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-usb-users@lists.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       greg@kroah.com, akpm@linux-foundation.org
Subject: [PATCH] [491/2many] MAINTAINERS - USB CDC ETHERNET DRIVER
Message-ID: <46bffc4a.lHVBM6kVQmUSRtLn%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 3aafacf..8f496de 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4653,6 +4653,8 @@ L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Maintained
 W:	http://www.kroah.com/linux-usb/
+F:	drivers/net/usb/cdc_*.c
+F:	include/linux/usb/cdc.h
 
 USB DAVICOM DM9601 DRIVER
 P:	Peter Korsgaard
