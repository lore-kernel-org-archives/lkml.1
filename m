Return-Path: <linux-kernel-owner+w=401wt.eu-S968299AbXHMHz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968299AbXHMHz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966281AbXHMG1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:27:23 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4324 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966464AbXHMG1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:27:21 -0400
Date: Sun, 12 Aug 2007 23:27:09 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [180/2many] MAINTAINERS - EFS FILESYSTEM
Message-ID: <46bff9bd.F+nd14al2P2k6Ef2%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 208bfea..ad6dc93 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1742,6 +1742,7 @@ F:	drivers/net/eepro100.c
 EFS FILESYSTEM
 W:	http://aeschi.ch.eu.org/efs/
 S:	Orphan
+F:	fs/efs/
 
 EHCA (IBM GX bus InfiniBand adapter) DRIVER:
 P:	Hoang-Nam Nguyen
