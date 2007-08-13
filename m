Return-Path: <linux-kernel-owner+w=401wt.eu-S967016AbXHMLZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967016AbXHMLZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939213AbXHMGiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:38:18 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2154 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939191AbXHMGiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:38:16 -0400
Date: Sun, 12 Aug 2007 23:38:00 -0700
From: joe@perches.com
To: zaitcev@redhat.com, torvalds@linux-foundation.org,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [490/2many] MAINTAINERS - USB BLOCK DRIVER (UB ub)
Message-ID: <46bffc48.jq7Ax2MlK/hZ/ANM%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 228b49f..3aafacf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4644,6 +4644,7 @@ M:	zaitcev@redhat.com
 L:	linux-kernel@vger.kernel.org
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Supported
+F:	drivers/block/ub.c
 
 USB CDC ETHERNET DRIVER
 P:	Greg Kroah-Hartman
