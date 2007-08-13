Return-Path: <linux-kernel-owner+w=401wt.eu-S968818AbXHMIB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968818AbXHMIB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966531AbXHMG1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:27:42 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4375 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966530AbXHMG1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:27:39 -0400
Date: Sun, 12 Aug 2007 23:27:24 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, sct@redhat.com,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       akpm@linux-foundation.org, adilger@clusterfs.com
Subject: [PATCH] [188/2many] MAINTAINERS - EXT4 FILE SYSTEM
Message-ID: <46bff9cc.cxIrFM29roaPmcfV%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 814168d..992a314 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1808,10 +1808,16 @@ F:	fs/ext3/
 F:	include/linux/ext3*
 
 EXT4 FILE SYSTEM
-P:	Stephen Tweedie, Andrew Morton
-M:	sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
+P:	Stephen Tweedie
+M:	sct@redhat.com
+P:	Andrew Morton
+M:	akpm@linux-foundation.org
+P:	Andreas Dilger
+M:	adilger@clusterfs.com
 L:	linux-ext4@vger.kernel.org
 S:	Maintained
+F:	fs/ext4/
+F:	include/linux/ext4*
 
 F71805F HARDWARE MONITORING DRIVER
 P:	Jean Delvare
