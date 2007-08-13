Return-Path: <linux-kernel-owner+w=401wt.eu-S944194AbXHML25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S944194AbXHML25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967239AbXHMGib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:38:31 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2190 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966847AbXHMGi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:38:29 -0400
Date: Sun, 12 Aug 2007 23:38:15 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-usb-users@lists.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       johannes@erdfelt.com, akpm@linux-foundation.org
Subject: [PATCH] [497/2many] MAINTAINERS - USB HUB DRIVER
Message-ID: <46bffc57.+VLVIUHqG3mGbW2w%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 270952c..d46c083 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4705,6 +4705,7 @@ M:	johannes@erdfelt.com
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Maintained
+F:	drivers/usb/core/hub.*
 
 USB ISP116X DRIVER
 P:	Olav Kongas
