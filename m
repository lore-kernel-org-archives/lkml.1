Return-Path: <linux-kernel-owner+w=401wt.eu-S1761598AbXGPXu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761598AbXGPXu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 19:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbXGPXuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 19:50:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:1071 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbXGPXut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 19:50:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=J6HFPPa4ZjQcQRMJJza++2n35FgqCNCRx8kxIlnzctmugo8ibfILYeDLxhc8IPagtVk/ii/Zp688wurqZnzj//V5we45d0JVKLIH0a/ROknThiX4wRhjSl/fDhC1zPgOPb/zXGGN631LiZwYvH4Qme533eSl8ggyMmarZTgfFBc=
Message-ID: <469C0429.5030504@googlemail.com>
Date: Tue, 17 Jul 2007 01:50:01 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: trivial@kernel.org
Subject: [PATCH] Typo fixes retrun -> return
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Typo fixes retrun -> return

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>

---

 Documentation/scsi/arcmsr_spec.txt |    2 +-
 mm/migrate.c                       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/scsi/arcmsr_spec.txt b/Documentation/scsi/arcmsr_spec.txt
index 5e00423..45d9482 100644
--- a/Documentation/scsi/arcmsr_spec.txt
+++ b/Documentation/scsi/arcmsr_spec.txt
@@ -3,7 +3,7 @@
 *******************************************************************************
 **	Usage of IOP331 adapter
 **	(All In/Out is in IOP331's view)
-**	1. Message 0 --> InitThread message and retrun code
+**	1. Message 0 --> InitThread message and return code
 **	2. Doorbell is used for RS-232 emulation
 **		inDoorBell :    bit0 -- data in ready
 **			(DRIVER DATA WRITE OK)
diff --git a/mm/migrate.c b/mm/migrate.c
index a91ca00..3c8b374 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -682,7 +682,7 @@ move_newpage:
  * The function returns after 10 attempts or if no pages
  * are movable anymore because to has become empty
  * or no retryable pages exist anymore. All pages will be
- * retruned to the LRU or freed.
+ * returned to the LRU or freed.
  *
  * Return: Number of pages not migrated or error code.
  */


