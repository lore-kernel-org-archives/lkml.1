Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbXHMK2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbXHMK2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965896AbXHMGfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:35:36 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1726 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967270AbXHMGfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:35:30 -0400
Date: Sun, 12 Aug 2007 23:35:15 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, axboe@kernel.dk,
       akpm@linux-foundation.org
Subject: [PATCH] [418/2many] MAINTAINERS - SCSI CDROM DRIVER
Message-ID: <46bffba3.92NZRByJnVYnqXQs%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index c08c8af..d7a1c74 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3981,6 +3981,7 @@ M:	axboe@kernel.dk
 L:	linux-scsi@vger.kernel.org
 W:	http://www.kernel.dk
 S:	Maintained
+F:	drivers/scsi/sr.*
 
 SCSI SG DRIVER
 P:	Doug Gilbert
