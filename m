Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbXIEMyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbXIEMyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 08:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754865AbXIEMyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 08:54:01 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:59570 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058AbXIEMyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 08:54:00 -0400
Date: Wed, 5 Sep 2007 13:53:55 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Spelling fix: weired -> weird
Message-ID: <20070905125355.GA18863@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/Documentation/scsi/ibmmca.txt b/Documentation/scsi/ibmmca.txt
index 9707941..a08e225 100644
--- a/Documentation/scsi/ibmmca.txt
+++ b/Documentation/scsi/ibmmca.txt
@@ -1188,7 +1188,7 @@
 	and 15 get ignored by the driver & adapter!
      Q: I have a 9595 and I get a NMI during heavy SCSI I/O e.g. during fsck.
         A COMMAND ERROR is reported and characters on the screen are missing.
-	Warm reboot is not possible. Things look like quite weired.
+	Warm reboot is not possible. Things look like quite weird.
      A: Check the processor type of your 9595. If you have an 80486 or 486DX-2
         processor complex on your mainboard and you compiled a kernel that
 	supports 80386 processors, it is possible, that the kernel cannot
