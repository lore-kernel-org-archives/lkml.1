Return-Path: <linux-kernel-owner+w=401wt.eu-S971937AbXHMJmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971937AbXHMJmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967087AbXHMGdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:33:16 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1311 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967070AbXHMGdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:33:13 -0400
Date: Sun, 12 Aug 2007 23:32:56 -0700
From: joe@perches.com
To: yokota@netlab.is.tsukuba.ac.jp, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, gotom@debian.or.jp,
       akpm@linux-foundation.org
Subject: [PATCH] [347/2many] MAINTAINERS - NINJA SCSI-32Bi/UDE PCI/CARDBUS SCSI HOST ADAPTER DRIVER
Message-ID: <46bffb18.d2jtcobSM4uNoxbu%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 6f7fc81..378ad04 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3339,6 +3339,8 @@ P:	YOKOTA Hiroshi
 M:	yokota@netlab.is.tsukuba.ac.jp
 W:	http://www.netlab.is.tsukuba.ac.jp/~yokota/izumi/ninja/
 S:	Maintained
+F:	Documentation/scsi/NinjaSCSI.txt
+F:	drivers/scsi/pcmcia/nsp_*
 
 NTFS FILESYSTEM
 P:	Anton Altaparmakov
