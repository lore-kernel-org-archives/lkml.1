Return-Path: <linux-kernel-owner+w=401wt.eu-S965034AbXHMFxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965034AbXHMFxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 01:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbXHMFxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 01:53:30 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3324 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843AbXHMFx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 01:53:29 -0400
Subject: [PATCH] [2/2many] - FInd the maintainer(s) for a patch -
	MAINTAINERS
From: Joe Perches <joe@perches.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Content-Type: text/plain
Date: Sun, 12 Aug 2007 22:53:19 -0700
Message-Id: <1186984399.10249.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Describe the new F: pattern

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 0d7f856..d3a0684 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -83,13 +83,6 @@ S: Status, one of the following:
 			it has been replaced by a better system and you
 			should be using that.
 
-F: Files and directories with wildcard patterns.
-   A trailing slash includes all files and subdirectory files.
-	F:	drivers/net/	all files in and below drivers/net
-	F:	drivers/net/*	all files in drivers/net, but not below
-	F:	*/net/*		all files in "any top level directory"/net
-   One pattern per line.  Multiple F: lines acceptable.
-
 3C359 NETWORK DRIVER
 P:	Mike Phillips
 M:	mikep@linuxtr.net



