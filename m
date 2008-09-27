Return-Path: <linux-kernel-owner+w=401wt.eu-S1752500AbYI0CLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbYI0CLD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 22:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbYI0CKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 22:10:54 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:58249 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbYI0CKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 22:10:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:sender;
        b=FNyiGMGBaOmT/HgXhKZqMIkYALr2eybLmRnwM5ch/qzj78E+8r2HKAofLNp/KQZ6BT
         ok9RsDlqe/QEt6tluO2rwQrr/wq9OhHNZE3VQsnUa2hrsALgzcfUuKwotp4UIGJPimB2
         JAdQQ5w7lAQffd0YoF4WOf8RUI2cXFrZat/aM=
From: Alberto Bertogli <albertito@blitiri.com.ar>
To: Jens Axboe <jens.axboe@oracle.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       linux-kernel@vger.kernel.org
Cc: Alberto Bertogli <albertito@blitiri.com.ar>
Subject: [PATCH] Documentation/block/data-integrity.txt: Fix section numbers
Date: Fri, 26 Sep 2008 23:10:31 -0300
Message-Id: <1222481431-15476-1-git-send-email-albertito@blitiri.com.ar>
X-Mailer: git-send-email 1.6.0.87.g2858d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>
---
 Documentation/block/data-integrity.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/block/data-integrity.txt b/Documentation/block/data-integrity.txt
index e9dc8d8..e8ca040 100644
--- a/Documentation/block/data-integrity.txt
+++ b/Documentation/block/data-integrity.txt
@@ -246,7 +246,7 @@ will require extra work due to the application tag.
       retrieve the tag buffer using bio_integrity_get_tag().
 
 
-6.3 PASSING EXISTING INTEGRITY METADATA
+5.3 PASSING EXISTING INTEGRITY METADATA
 
     Filesystems that either generate their own integrity metadata or
     are capable of transferring IMD from user space can use the
@@ -283,7 +283,7 @@ will require extra work due to the application tag.
       integrity upon completion.
 
 
-6.4 REGISTERING A BLOCK DEVICE AS CAPABLE OF EXCHANGING INTEGRITY
+5.4 REGISTERING A BLOCK DEVICE AS CAPABLE OF EXCHANGING INTEGRITY
     METADATA
 
     To enable integrity exchange on a block device the gendisk must be
-- 
1.6.0.87.g2858d

