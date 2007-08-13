Return-Path: <linux-kernel-owner+w=401wt.eu-S939090AbXHMLOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939090AbXHMLOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939125AbXHMGh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:37:59 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2082 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967249AbXHMGhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:37:36 -0400
Date: Sun, 12 Aug 2007 23:36:49 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       laredo@gnu.org, akpm@linux-foundation.org
Subject: [PATCH] [463/2many] MAINTAINERS - STRADIS MPEG-2 DECODER DRIVER
Message-ID: <46bffc01.7c95Dz5xUUkjysHI%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 9da5a44..3e51fc6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4406,6 +4406,7 @@ P:	Nathan Laredo
 M:	laredo@gnu.org
 W:	http://www.stradis.com/
 S:	Maintained
+F:	drivers/media/video/stradis.c
 
 SUPERH (sh)
 P:	Paul Mundt
