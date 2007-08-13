Return-Path: <linux-kernel-owner+w=401wt.eu-S1760964AbXHMKcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760964AbXHMKcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966684AbXHMGfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:35:47 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1736 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967076AbXHMGfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:35:33 -0400
Date: Sun, 12 Aug 2007 23:35:19 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       James.Bottomley@SteelEye.com
Subject: [PATCH] [420/2many] MAINTAINERS - SCSI SUBSYSTEM
Message-ID: <46bffba7.a/HzsshGBNUiTFM7%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index c156f9f..c4d29d9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3998,6 +3998,8 @@ M:	James.Bottomley@SteelEye.com
 L:	linux-scsi@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
 S:	Maintained
+F:	drivers/scsi/
+F:	include/scsi/
 
 SCSI TAPE DRIVER
 P:	Kai Mäkisara
