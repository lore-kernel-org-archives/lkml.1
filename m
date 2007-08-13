Return-Path: <linux-kernel-owner+w=401wt.eu-S965132AbXHMLWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965132AbXHMLWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939190AbXHMGiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:38:16 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2128 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939159AbXHMGiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:38:04 -0400
Date: Sun, 12 Aug 2007 23:37:49 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       bfennema@falcon.csc.calpoly.edu, akpm@linux-foundation.org
Subject: [PATCH] [487/2many] MAINTAINERS - UDF FILESYSTEM
Message-ID: <46bffc3d.mL8kSMMVOUW/hs8u%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index e28c8d4..9bea953 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4616,6 +4616,8 @@ P:	Ben Fennema
 M:	bfennema@falcon.csc.calpoly.edu
 W:	http://linux-udf.sourceforge.net
 S:	Maintained
+F:	Documentation/filesystems/udf.txt
+F:	fs/udf/
 
 UNIFORM CDROM DRIVER
 P:	Jens Axboe
