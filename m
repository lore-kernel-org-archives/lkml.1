Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030223Ab0B0QwM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:52:12 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030206Ab0B0QwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:52:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=sQjmlM3vFNQ6GsiNcP1xqInPLmFYxoh4lZgCPKBEp0Wbk3hUkTVjf51irCPKmPggX5
         501SGU+KYEQmG3di2O38vwbociroNH+OMgazq3FhcFBTEmMaIq46qxj3N05JHM0n+srW
         BlUeMrOJF3GpSk7M6VxoE36hhoHiwAhSSKq/c=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       "Sergey S. Kostyliov" <rathamahata@php4.ru>
Subject: [PATCH 02/66] fs/befs/inode.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:50:43 +0100
Message-Id: <1267289508-31031-3-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/befs/inode.h:3: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 fs/befs/inode.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/befs/inode.h b/fs/befs/inode.h
index 9dc7fd9..1dcefba 100644
--- a/fs/befs/inode.h
+++ b/fs/befs/inode.h
@@ -1,8 +1,7 @@
 /*
  * inode.h
- * 
+ *
  */
 
 int befs_check_inode(struct super_block *sb, befs_inode * raw_inode,
 		     befs_blocknr_t inode);
-
-- 
1.7.0.90.g251a4

