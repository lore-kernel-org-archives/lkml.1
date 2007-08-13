Return-Path: <linux-kernel-owner+w=401wt.eu-S969998AbXHMIiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969998AbXHMIiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966838AbXHMG3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:29:52 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4703 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966403AbXHMG3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:29:49 -0400
Date: Sun, 12 Aug 2007 23:29:35 -0700
From: joe@perches.com
To: ttb@tentacle.dhs.org, torvalds@linux-foundation.org, rml@novell.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [248/2many] MAINTAINERS - INOTIFY
Message-ID: <46bffa4f.7Z62RhcOqBa9NAol%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 7460778..9608731 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2361,6 +2361,8 @@ P:	Robert Love
 M:	rml@novell.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/filesystems/inotify.txt
+F:	fs/inotify*
 
 INTEL FRAMEBUFFER DRIVER (excluding 810 and 815)
 P:	Sylvain Meyer
