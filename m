Return-Path: <linux-kernel-owner+w=401wt.eu-S938774AbXHMKkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938774AbXHMKkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967320AbXHMGgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:36:14 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1829 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965988AbXHMGgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:36:05 -0400
Date: Sun, 12 Aug 2007 23:35:51 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, thomas@winischhofer.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [437/2many] MAINTAINERS - SIS USB2VGA DRIVER
Message-ID: <46bffbc7.wEArQR0wPKpDbOlh%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 08d0b06..b2dd6f5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4159,6 +4159,7 @@ P:	Thomas Winischhofer
 M:	thomas@winischhofer.net
 W:	http://www.winischhofer.at/linuxsisusbvga.shtml
 S:	Maintained
+F:	drivers/usb/misc/sisusbvga/
 
 SLAB ALLOCATOR
 P:	Christoph Lameter
