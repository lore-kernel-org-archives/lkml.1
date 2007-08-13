Return-Path: <linux-kernel-owner+w=401wt.eu-S943040AbXHMIJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943040AbXHMIJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966060AbXHMG2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:28:20 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4455 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966353AbXHMG2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:28:17 -0400
Date: Sun, 12 Aug 2007 23:27:57 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, stefanr@s5r6.in-berlin.de,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       krh@redhat.com, akpm@linux-foundation.org
Subject: [PATCH] [198/2many] MAINTAINERS - FIREWIRE SUBSYSTEM
Message-ID: <46bff9ed.Ya9JdXR0dvc3Ionf%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 9aa822a..18dfe29 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1895,12 +1895,15 @@ S:	Maintained
 F:	fs/*
 
 FIREWIRE SUBSYSTEM
-P:	Kristian Hoegsberg, Stefan Richter
-M:	krh@redhat.com, stefanr@s5r6.in-berlin.de
+P:	Kristian Hoegsberg
+M:	krh@redhat.com
+P:	Stefan Richter
+M:	stefanr@s5r6.in-berlin.de
 L:	linux1394-devel@lists.sourceforge.net
 W:	http://www.linux1394.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
 S:	Maintained
+F:	drivers/ieee/1394/
 
 FIRMWARE LOADER (request_firmware)
 L:	linux-kernel@vger.kernel.org
