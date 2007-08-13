Return-Path: <linux-kernel-owner+w=401wt.eu-S944333AbXHML2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S944333AbXHML2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966086AbXHMGi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:38:28 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2182 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965914AbXHMGi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:38:26 -0400
Date: Sun, 12 Aug 2007 23:38:07 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       akpm@linux-foundation.org
Subject: [PATCH] [493/2many] MAINTAINERS - USB EHCI DRIVER
Message-ID: <46bffc4f.YFAwWBHo1UP5rLM/%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index b7498bf..5bec508 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4669,6 +4669,8 @@ P:	David Brownell
 M:	dbrownell@users.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Odd Fixes
+F:	Documentation/usb/ehci.txt
+F:	drivers/usb/host/ehci*
 
 USB ET61X[12]51 DRIVER
 P:	Luca Risolia
