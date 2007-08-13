Return-Path: <linux-kernel-owner+w=401wt.eu-S1758344AbXHMKDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344AbXHMKDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:03:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965991AbXHMGeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:34:13 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1478 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966511AbXHMGeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:34:00 -0400
Date: Sun, 12 Aug 2007 23:33:06 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, ocfs2-devel@oss.oracle.com,
       mark.fasheh@oracle.com, linux-kernel@vger.kernel.org,
       kurt.hackel@oracle.com, akpm@linux-foundation.org
Subject: [PATCH] [352/2many] MAINTAINERS - ORACLE CLUSTER FILESYSTEM 2
 (OCFS2)
Message-ID: <46bffb22.0082+Mt2C9uJMxe9%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 14a983d..ab954f1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3392,6 +3392,8 @@ M:	kurt.hackel@oracle.com
 L:	ocfs2-devel@oss.oracle.com
 W:	http://oss.oracle.com/projects/ocfs2/
 S:	Supported
+F:	Documentation/filesystems/ocfs2.txt
+F:	fs/ocfs2/
 
 OLYMPIC NETWORK DRIVER
 P:	Peter De Shrijver
