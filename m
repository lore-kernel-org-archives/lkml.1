Return-Path: <linux-kernel-owner+w=401wt.eu-S967555AbXHMGkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967555AbXHMGkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965799AbXHMGW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:22:57 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3526 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965738AbXHMGWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:22:45 -0400
Date: Sun, 12 Aug 2007 23:22:27 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, airlied@linux.ie
Subject: [PATCH] [34/2many] MAINTAINERS - AGPGART DRIVER
Message-ID: <46bff8a3.lbOlrUlp4i1eA62t%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index e973233..c35092f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -339,6 +339,7 @@ P:	David Airlie
 M:	airlied@linux.ie
 T:	git kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
 S:	Maintained
+F:	drivers/char/agp/
 
 AHA152X SCSI DRIVER
 P:	Juergen E. Fischer
