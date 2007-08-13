Return-Path: <linux-kernel-owner+w=401wt.eu-S970820AbXHMI6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970820AbXHMI6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966750AbXHMGbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:31:08 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4906 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966348AbXHMGbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:31:04 -0400
Date: Sun, 12 Aug 2007 23:30:38 -0700
From: joe@perches.com
To: vgoyal@in.ibm.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       hbabu@us.ibm.com, akpm@linux-foundation.org
Subject: [PATCH] [275/2many] MAINTAINERS - KDUMP
Message-ID: <46bffa8e.NHuk7h7puR+3eDXo%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 1ea2c63..d61676a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2634,6 +2634,7 @@ L:	kexec@lists.infradead.org
 L:	linux-kernel@vger.kernel.org
 W:	http://lse.sourceforge.net/kdump/
 S:	Maintained
+F:	Documentation/kdump
 
 KERNEL AUTOMOUNTER (AUTOFS)
 P:	H. Peter Anvin
