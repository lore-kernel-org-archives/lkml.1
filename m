Return-Path: <linux-kernel-owner+w=401wt.eu-S940324AbXHMLLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940324AbXHMLLN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966719AbXHMGhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:37:50 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1660 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967231AbXHMGfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:35:09 -0400
Date: Sun, 12 Aug 2007 23:34:54 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, reiserfs-devel@vger.kernel.org,
       reiserfs-dev@namesys.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [407/2many] MAINTAINERS - REISERFS FILE SYSTEM
Message-ID: <46bffb8e.aZ07lFqNw9n11SB8%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 390e389..1a2d474 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3880,6 +3880,7 @@ M:	reiserfs-dev@namesys.com
 L:	reiserfs-devel@vger.kernel.org
 W:	http://www.namesys.com
 S:	Supported
+F:	fs/reiserfs/
 
 ROCKETPORT DRIVER
 P:	Comtrol Corp.
