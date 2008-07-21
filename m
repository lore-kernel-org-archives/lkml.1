Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbYGUTO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbYGUTO1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 15:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754855AbYGUTNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 15:13:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:33470 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbYGUTNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 15:13:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=aFAj4vkCIXD5f7l7R/9+J40NokVNMfb0cspIr1Bo9jLmq21dGCjRhsIq9AAX7P7Khm
         mGU+z9Da4eMIki52A5TNKvOiVfSTW9nsCAhwzVtJeO5LVNZaWFY3IT4/agIeK7Ueec69
         OnG9V2AUtkDEJ0ZoBPlChsZx1K3klqHH0jiqc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: remove stale comments from drivers/ide/Makefile
Date: Mon, 21 Jul 2008 21:09:53 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807212109.53577.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Makefile |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

Index: b/drivers/ide/Makefile
===================================================================
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -1,13 +1,6 @@
 #
-# Makefile for the kernel ata, atapi, and ide block device drivers.
-#
-# 12 September 2000, Bartlomiej Zolnierkiewicz <bkz@linux-ide.org>
-# Rewritten to use lists instead of if-statements.
-#
-# Note : at this point, these files are compiled on all systems.
-# In the future, some of these should be built conditionally.
-#
 # link order is important here
+#
 
 EXTRA_CFLAGS				+= -Idrivers/ide
 
