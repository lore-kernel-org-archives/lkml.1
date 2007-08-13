Return-Path: <linux-kernel-owner+w=401wt.eu-S971358AbXHMJMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971358AbXHMJMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966048AbXHMGbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:31:44 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1049 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966973AbXHMGbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:31:43 -0400
Date: Sun, 12 Aug 2007 23:31:27 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-ntfs-dev@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, ldm@flatcap.org,
       akpm@linux-foundation.org
Subject: [PATCH] [301/2many] MAINTAINERS - LOGICAL DISK MANAGER SUPPORT
 (LDM, Windows 2000/XP/Vista Dynamic Disks)
Message-ID: <46bffabf.TGzL8slsoRk8KMWl%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index be709c1..8ae4d49 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2891,6 +2891,8 @@ M:	ldm@flatcap.org
 L:	linux-ntfs-dev@lists.sourceforge.net
 W:	http://www.linux-ntfs.org/content/view/19/37/
 S:	Maintained
+F:	/Documentation/ldm.txt
+F:	fs/partitions/ldm.*
 
 LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)
 P:	Eric Moore
