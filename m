Return-Path: <linux-kernel-owner+w=401wt.eu-S968284AbXHMLe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968284AbXHMLe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966847AbXHMGio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:38:44 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2227 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939030AbXHMGim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:38:42 -0400
Date: Sun, 12 Aug 2007 23:38:22 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-usb-users@lists.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       dbrownell@users.sourceforge.net, akpm@linux-foundation.org
Subject: [PATCH] [501/2many] MAINTAINERS - USB OHCI DRIVER
Message-ID: <46bffc5e.iM1GKA/q0XIK1RjQ%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 0d6b162..94ce5ce 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4738,6 +4738,8 @@ M:	dbrownell@users.sourceforge.net
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Odd Fixes
+F:	Documentation/usb/ohci.txt
+F:	drivers/usb/host/ohci*
 
 USB OPTION-CARD DRIVER
 P:	Matthias Urlichs
