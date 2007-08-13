Return-Path: <linux-kernel-owner+w=401wt.eu-S944100AbXHMLIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S944100AbXHMLIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937286AbXHMGhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:37:42 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2025 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967341AbXHMGhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:37:14 -0400
Date: Sun, 12 Aug 2007 23:36:59 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       hch@infradead.org, akpm@linux-foundation.org
Subject: [PATCH] [468/2many] MAINTAINERS - SYSV FILESYSTEM
Message-ID: <46bffc0b.0FUWUfd3ZJOPur6I%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index cde4be1..f00640b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4448,6 +4448,9 @@ SYSV FILESYSTEM
 P:	Christoph Hellwig
 M:	hch@infradead.org
 S:	Maintained
+F:	Documentation/filesystems/sysv-fs.txt
+F:	fs/sysv/
+F:	include/linux/sysv_fs.h
 
 TC CLASSIFIER
 P:	Jamal Hadi Salim
