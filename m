Return-Path: <linux-kernel-owner+w=401wt.eu-S1760321AbXGVQb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760321AbXGVQb1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 12:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591AbXGVQbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 12:31:19 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:52297 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbXGVQbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 12:31:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=V2uKJV9N3XDItxBdMEwHpux/QJUEx0NMsnBGhf0bvHCAux3kigxYxn++Vy7A6G0EiXBTiFaHS8MJLQKJniNvMRQfZak2W5AYJWMVWL24dwyi1kKbpysmdj+NjoY7kPNDWsGmijKx7NVArpaTxccGEaH766Rx0mBnLYWfwVg1iGY=
Message-ID: <46A385CD.6000102@googlemail.com>
Date: Sun, 22 Jul 2007 18:29:01 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] [RESEND] Typo fixes retrun -> return
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
