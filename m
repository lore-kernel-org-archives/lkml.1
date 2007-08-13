Return-Path: <linux-kernel-owner+w=401wt.eu-S971904AbXHMJlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971904AbXHMJlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967083AbXHMGdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:33:13 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1296 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967084AbXHMGdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:33:08 -0400
Date: Sun, 12 Aug 2007 23:32:54 -0700
From: joe@perches.com
To: yokota@netlab.is.tsukuba.ac.jp, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [346/2many] MAINTAINERS - NINJA SCSI-3 / NINJA SCSI-32Bi
 (16bit/CardBus) PCMCIA SCSI HOST ADAPTER DRIVER
Message-ID: <46bffb16./dGyVRU9bsz/VQd+%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 35afb38..6f7fc81 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3329,6 +3329,8 @@ P:	YOKOTA Hiroshi
 M:	yokota@netlab.is.tsukuba.ac.jp
 W:	http://www.netlab.is.tsukuba.ac.jp/~yokota/izumi/ninja/
 S:	Maintained
+F:	Documentation/scsi/NinjaSCSI.txt
+F:	drivers/scsi/nsp32*
 
 NINJA SCSI-32Bi/UDE PCI/CARDBUS SCSI HOST ADAPTER DRIVER
 P:	GOTO Masanori
