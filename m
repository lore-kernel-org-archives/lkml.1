Return-Path: <linux-kernel-owner+w=401wt.eu-S934796AbXHMKgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934796AbXHMKgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967309AbXHMGgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:36:06 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1755 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967261AbXHMGfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:35:41 -0400
Date: Sun, 12 Aug 2007 23:35:21 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Kai.Makisara@kolumbus.fi
Subject: [PATCH] [421/2many] MAINTAINERS - SCSI TAPE DRIVER
Message-ID: <46bffba9.6+Hv0+R8yAp+v2wI%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index c4d29d9..2e15975 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4006,6 +4006,7 @@ P:	Kai Mäkisara
 M:	Kai.Makisara@kolumbus.fi
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	drivers/scsi/st*
 
 SCTP PROTOCOL
 P:	Vlad Yasevich
